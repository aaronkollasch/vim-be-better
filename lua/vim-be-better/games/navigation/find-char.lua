local GameUtils = require("vim-be-better.game-utils")
local log = require("vim-be-better.log")

local instructions = {
    "SUPER SIMPLE (f/F)IND CHAR GAME!",
    "",
    "Just move your cursor to the highlighted character",
    "Use f/F motions to get there",
    "To go to the new line, use j/k",
    "",
    "Find the character marked with '^', ignore others marked with '·'",
    "",
}

local characterSets = {
    noob = { "a", "e", "i", "o", "u", "n", "t", "s", "r" },
    easy = { "b", "c", "d", "g", "h", "l", "m", "p", "w", "y" },
    medium = { "f", "k", "v", "x", "z", "j", "q" },
    hard = { "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "+", "=" },
    nightmare = { "[", "]", "{", "}", "|", "\\", ":", ";", "'", "\"", "<", ">", "?" },
    tpope = { "~", "`" }
}

local textTemplates = {
    noob = {
        "The quick brown fox jumps over the lazy dog.",
        "A journey of a thousand miles begins with a single step.",
        "To be or not to be, that is the question.",
    },
    easy = {
        "local function setup_plugin()",
        "vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>')",
        "print('Hello, World! This is a test.')",
    },
    medium = {
        "for i, v in ipairs(my_table) do process(v) end",
        "const user = { id: 1, name: 'John Doe', active: true };",
        "if err then return nil, err end",
    },
    hard = {
        "local augroup = vim.api.nvim_create_augroup('MyGroup', { clear = true })",
        "const { data, error } = await fetch('/api/data');",
        "SELECT id, name, email FROM users WHERE created_at > '2023-01-01';",
    },
    nightmare = {
        "pcall(vim.api.nvim_del_augroup_by_name, 'FindCharCursorCheck')",
        "const regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$/;",
        "type UserProfile = { id: string; preferences: Record<string, any>; };",
    },
    tpope = {
        "git rebase -i HEAD~5 --autostash",
        "curl -X POST -H 'Content-Type: application/json' -d '{\"key\":\"value\"}' http://localhost:3000/api",
        "awk '{print $1, $3}' file.log | sort | uniq -c",
    }
}

local linesCountConfig = {
    noob = { min = 1, max = 1 },
    easy = { min = 1, max = 2 },
    medium = { min = 2, max = 3 },
    hard = { min = 2, max = 4 },
    nightmare = { min = 3, max = 5 },
    tpope = { min = 4, max = 6 }
}

local FindCharRound = {}

function FindCharRound:new(difficulty, window)
    log.info("FindCharRound:new", difficulty, window)

    local round = {
        window = window,
        difficulty = difficulty,
        targetChar = "",
        textLines = {},
        correctTarget = {},
        cursorCheckAugroup = nil,
    }

    self.__index = self
    return setmetatable(round, self)
end

function FindCharRound:getInstructions()
    return instructions
end

function FindCharRound:getConfig()
    log.info("FindCharRound:getConfig", self.difficulty)

    self:generateRound()

    return {
        roundTime = GameUtils.difficultyToTime[self.difficulty] or 10000,
        canEndRound = true,
    }
end

function FindCharRound:generateRound()
    local difficultyKey = self.difficulty or "easy"
    local config = {
        chars = characterSets[difficultyKey] or characterSets.easy,
        templates = textTemplates[difficultyKey] or textTemplates.easy,
        lines = linesCountConfig[difficultyKey] or linesCountConfig.easy
    }

    self.targetChar = config.chars[math.random(#config.chars)]

    self.textLines = {}
    local numLines = math.random(config.lines.min, config.lines.max)
    for _ = 1, numLines do
        table.insert(self.textLines, config.templates[math.random(#config.templates)])
    end

    local allOccurrences = {}
    for lineNum, line in ipairs(self.textLines) do
        for col = 1, #line do
            if string.sub(line, col, col) == self.targetChar then
                table.insert(allOccurrences, { line = lineNum, col = col })
            end
        end
    end

    if #allOccurrences == 0 then
        local lineToModify = math.random(#self.textLines)
        local colToInsert = math.random(#self.textLines[lineToModify] + 1)
        local oldLine = self.textLines[lineToModify]
        self.textLines[lineToModify] = string.sub(oldLine, 1, colToInsert - 1) ..
        self.targetChar .. string.sub(oldLine, colToInsert)
        table.insert(allOccurrences, { line = lineToModify, col = colToInsert })
    end

    self.correctTarget = allOccurrences[math.random(#allOccurrences)]

    log.info("FindCharRound:generateRound",
        "DIFFICULTY:", difficultyKey,
        "CHAR:", self.targetChar,
        "TARGET:", "L" .. self.correctTarget.line .. " C" .. self.correctTarget.col,
        "LINES:", #self.textLines)
end

function FindCharRound:setupCursorMonitoring()
    local augroup_name = "FindCharCursorCheck_" .. vim.fn.localtime()
    self.cursorCheckAugroup = augroup_name

    vim.api.nvim_create_augroup(augroup_name, { clear = true })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = augroup_name,
        buffer = self.window.buffer.bufh,
        callback = function()
            self:onCursorMoved()
        end
    })

    log.info("FindCharRound:setupCursorMonitoring - Created augroup:", augroup_name)
end

function FindCharRound:cleanupCursorMonitoring()
    if self.cursorCheckAugroup then
        pcall(vim.api.nvim_del_augroup_by_name, self.cursorCheckAugroup)
        log.info("FindCharRound:cleanupCursorMonitoring - Removed augroup:", self.cursorCheckAugroup)
        self.cursorCheckAugroup = nil
    end
end

function FindCharRound:onCursorMoved()
    log.info("FindCharRound:onCursorMoved - Cursor moved!")

    if self:checkForWin() then
        log.info("FindCharRound:onCursorMoved - PLAYER WON!")
        self:cleanupCursorMonitoring()

        if self.endRoundCallback then
            self.endRoundCallback(true)
        end
    end
end

function FindCharRound:checkForWin()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local currentLineNum = cursor[1]
    local currentCol = cursor[2] + 1

    local allBufferLines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local targetLineText = self.textLines[self.correctTarget.line]
    local targetAbsoluteLineNum = nil

    for i, line in ipairs(allBufferLines) do
        if line == targetLineText then
            targetAbsoluteLineNum = i
            break
        end
    end

    log.info("=== CURSOR CHECK ===",
        "Cursor:", "L" .. currentLineNum, "C" .. currentCol,
        "Target:", "L" .. (targetAbsoluteLineNum or "nil"), "C" .. self.correctTarget.col)

    if targetAbsoluteLineNum and currentLineNum == targetAbsoluteLineNum and currentCol == self.correctTarget.col then
        log.info("*** LEVEL COMPLETED! ***")
        return true
    end

    return false
end

function FindCharRound:render()
    local lines = {}

    for lineNum, textLine in ipairs(self.textLines) do
        table.insert(lines, textLine)
        local indicator = ""
        for col = 1, #textLine do
            if lineNum == self.correctTarget.line and col == self.correctTarget.col then
                indicator = indicator .. "^"
            elseif string.sub(textLine, col, col) == self.targetChar then
                indicator = indicator .. "·"
            else
                indicator = indicator .. " "
            end
        end
        table.insert(lines, indicator)
    end

    table.insert(lines, "")
    table.insert(lines, string.format("TARGET: '%s' - Find the character marked with '^'", self.targetChar))

    vim.defer_fn(function()
        self:setupCursorMonitoring()
    end, 100)

    local cursorLine = 1
    local cursorCol = 0

    return lines, cursorLine, cursorCol
end

function FindCharRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
end

function FindCharRound:name()
    return "find-char"
end

function FindCharRound:close()
    self:cleanupCursorMonitoring()
end

return FindCharRound
