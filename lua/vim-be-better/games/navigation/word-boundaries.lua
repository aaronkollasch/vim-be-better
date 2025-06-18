local GameUtils = require("vim-be-better.game-utils")
local log = require("vim-be-better.log")

local instructions = { "--- Word Boundary Master ---",
    "",
    "Use word motions to jump to the target character (^).",
    "Start from the character marked with 'S'.",
    "",
    "  w, b, e, ge  - move by 'word' (letters, numbers, underscore)",
    "  W, B, E, gE  - move by 'WORD' (delimited by whitespace)",
    "",
    "Pay attention to the required motion!",
}

local difficultyConfig = {
    noob = {
        motions = { "w", "b" },
        counts = { 1, 2 },
        texts = {
            "The cat sat on the mat and the dog ran away",
            "one two three four five six seven eight nine ten",
            "a simple line of text to practice basic motions",
            "hello world this is easy practice text",
            "move left and right with basic word jumps"
        }
    },
    easy = {
        motions = { "w", "b", "e" },
        counts = { 1, 2, 3 },
        texts = {
            "Vim's motions are-powerful and efficient.",
            "Use w, b, and e to navigate words; it's easy!",
            "local my_variable = 123 -- a simple assignment",
            "function setup() return true end",
            "const data = {name: 'test', value: 42};"
        }
    },
    medium = {
        motions = { "w", "b", "e", "ge", "W", "B" },
        counts = { 1, 2, 3 },
        texts = {
            "local my_variable = require('my-module.core')",
            "function setup(opts) -- setup function for the plugin",
            "const user = {id: 1, name: 'John_Doe'};",
            "vim.api.nvim_set_keymap('n', '<leader>f', ':Files<CR>')",
            "if condition then print('hello') else return false end"
        }
    },
    hard = {
        motions = { "w", "b", "e", "ge", "W", "B", "E" },
        counts = { 2, 3, 4 },
        texts = {
            "vim.api.nvim_set_keymap('n', '<leader>f', ':Files<CR>')",
            "const { data, error } = await fetch('/api/data');",
            "type UserProfile = { id: string; preferences: Record<string, any>; };",
            "local augroup = vim.api.nvim_create_augroup('MyGroup', { clear = true })",
            "grep -rn --include='*.lua' 'pattern' /path/to/search"
        }
    },
    nightmare = {
        motions = { "W", "B", "E", "gE" },
        counts = { 2, 3, 4, 5 },
        texts = {
            "const path = '/usr/local/bin/my-script.js';",
            "pcall(vim.api.nvim_del_augroup_by_name, 'MyGroup')",
            "git rebase -i HEAD~5 --autostash",
            "const regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$/;",
            "docker run --rm -it -v $(pwd):/app -p 3000:3000 node:16-alpine"
        }
    },
    tpope = {
        motions = { "w", "b", "e", "ge", "W", "B", "E", "gE" },
        counts = { 3, 4, 5, 6 },
        texts = {
            "awk '{count[$1]++} END {for (word in count) print word, count[word]}' file.txt | sort -rn -k2",
            "curl -H 'Authorization: token ${GITHUB_TOKEN}' https://api.github.com/user/repos",
            "docker run --rm -it -v $(pwd):/app -p 3000:3000 node:16-alpine",
            "type ComplexType<T> = T extends infer U ? (U extends string ? U : never) : never;",
            "sed -e 's/pattern/replacement/g' -e 's/another/pattern/g' file.txt | awk '{print NF, $0}'"
        }
    }
}

local WordBoundariesRound = {}

function WordBoundariesRound:new(difficulty, window)
    log.info("WordBoundariesRound:new", difficulty, window)

    local round = {
        window = window,
        difficulty = difficulty or "easy",
        textLine = "",
        startPos = 0,
        targetPos = 0,
        motion = "",
        cursorCheckAugroup = nil,
    }
    self.__index = self
    return setmetatable(round, self)
end

function WordBoundariesRound:getInstructions()
    return instructions
end

function WordBoundariesRound:getConfig()
    log.info("WordBoundariesRound:getConfig", self.difficulty)

    self:generateRound()

    return {
        roundTime = GameUtils.difficultyToTime[self.difficulty] or 15000,
        canEndRound = true,
    }
end

function WordBoundariesRound:generateRound()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy

    self.textLine = config.texts[math.random(#config.texts)]

    local motion_char = config.motions[math.random(#config.motions)]
    local count = config.counts[math.random(#config.counts)]
    self.motion = (count > 1 and tostring(count) or "") .. motion_char

    local success = false
    local attempts = 0

    while not success and attempts < 50 do
        attempts = attempts + 1
        local start_col = math.random(1, #self.textLine)

        local temp_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(temp_buf, 0, -1, false, { self.textLine })

        local win_config = {
            relative = 'editor',
            width = 1,
            height = 1,
            row = vim.o.lines,
            col = vim.o.columns,
            focusable = false,
            style = 'minimal'
        }
        local temp_win = vim.api.nvim_open_win(temp_buf, false, win_config)

        local ok, target_col = pcall(function()
            vim.api.nvim_win_set_cursor(temp_win, { 1, start_col - 1 })

            vim.api.nvim_set_current_win(temp_win)
            vim.cmd("normal! " .. self.motion)

            local cursor = vim.api.nvim_win_get_cursor(temp_win)
            return cursor[2] + 1
        end)

        if vim.api.nvim_win_is_valid(temp_win) then
            vim.api.nvim_win_close(temp_win, true)
        end
        if vim.api.nvim_buf_is_valid(temp_buf) then
            vim.api.nvim_buf_delete(temp_buf, { force = true })
        end

        if ok and target_col and target_col ~= start_col and target_col > 0 and target_col <= #self.textLine then
            self.startPos = start_col
            self.targetPos = target_col
            success = true
        end
    end

    if not success then
        log.warn("WordBoundariesRound:generateRound - Using fallback")
        self.textLine = "please use w to move here"
        self.motion = "w"
        self.startPos = 8
        self.targetPos = 14
    end

    log.info("WordBoundariesRound:generateRound",
        "DIFFICULTY:", difficultyKey,
        "MOTION:", self.motion,
        "START:", self.startPos,
        "TARGET:", self.targetPos,
        "TEXT:", self.textLine)
end

function WordBoundariesRound:render()
    local lines = {}

    table.insert(lines, self.textLine)

    local indicator = ""
    for i = 1, #self.textLine do
        if i == self.startPos then
            indicator = indicator .. "S"
        elseif i == self.targetPos then
            indicator = indicator .. "^"
        else
            indicator = indicator .. " "
        end
    end
    table.insert(lines, indicator)

    table.insert(lines, "")
    table.insert(lines, string.format("Required motion: %s", self.motion))

    vim.defer_fn(function()
        self:setupCursorMonitoring()
    end, 100)

    local cursorLine = 1
    local cursorCol = self.startPos - 1

    return lines, cursorLine, cursorCol
end

function WordBoundariesRound:setupCursorMonitoring()
    local augroup_name = "WordBoundariesCursorCheck_" .. vim.fn.localtime()
    self.cursorCheckAugroup = augroup_name

    vim.api.nvim_create_augroup(augroup_name, { clear = true })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = augroup_name,
        buffer = self.window.buffer.bufh,
        callback = function()
            self:onCursorMoved()
        end
    })

    log.info("WordBoundariesRound:setupCursorMonitoring - Created augroup:", augroup_name)
end

function WordBoundariesRound:cleanupCursorMonitoring()
    if self.cursorCheckAugroup then
        pcall(vim.api.nvim_del_augroup_by_name, self.cursorCheckAugroup)
        log.info("WordBoundariesRound:cleanupCursorMonitoring - Removed augroup:", self.cursorCheckAugroup)
        self.cursorCheckAugroup = nil
    end
end

function WordBoundariesRound:onCursorMoved()
    log.info("WordBoundariesRound:onCursorMoved - Cursor moved!")

    if self:checkForWin() then
        log.info("WordBoundariesRound:onCursorMoved - PLAYER WON!")
        self:cleanupCursorMonitoring()

        if self.endRoundCallback then
            self.endRoundCallback(true)
        end
    end
end

function WordBoundariesRound:checkForWin()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local current_line = cursor[1]
    local current_col = cursor[2] + 1

    local all_buffer_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local game_line_num = nil

    for i, line in ipairs(all_buffer_lines) do
        if line == self.textLine then
            game_line_num = i
            break
        end
    end

    log.info("WordBoundariesRound:checkForWin",
        "Current:", "L" .. current_line, "C" .. current_col,
        "Target:", "L" .. (game_line_num or "nil"), "C" .. self.targetPos)

    if game_line_num and current_line == game_line_num and current_col == self.targetPos then
        log.info("*** WORD BOUNDARIES LEVEL COMPLETED! ***")
        return true
    end

    return false
end

function WordBoundariesRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
end

function WordBoundariesRound:name()
    return "word-boundaries"
end

function WordBoundariesRound:close()
    self:cleanupCursorMonitoring()
end

return WordBoundariesRound
