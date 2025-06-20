local log = require("vim-be-better.log")
local difficultyConfig = require("vim-be-better.games.advanced.configs.comment-toggle-config")

local instructions = {
    "--- Comment Toggle Master ---",
    "",
    "Master code commenting and uncommenting with Vim's commenting tools!",
    "Learn to efficiently toggle comments in various programming contexts.",
    "",
    "  gcc      - toggle comment on current line",
    "  gc{motion} - comment/uncomment motion (gcip, gc3j, etc.)",
    "  gc       - in visual mode, toggle comment on selection",
    "  gcu      - uncomment (if available)",
    "",
    "Different file types use different comment styles:",
    "  JavaScript/C: // or /* */",
    "  Python/Shell: #",
    "  Lua: --",
    "  HTML: <!-- -->",
    "",
    "Goal: Achieve the target commenting state efficiently.",
}


local CommentToggleRound = {}

function CommentToggleRound:new(difficulty, window)
    log.info("CommentToggleRound:new", difficulty, window)

    local round = {}
    setmetatable(round, { __index = CommentToggleRound })

    round.difficulty = difficulty
    round.window = window
    round.currentChallenge = nil
    round.endRoundCallback = nil
    round.winDetected = false

    return round
end

function CommentToggleRound:getInstructions()
    return instructions
end

function CommentToggleRound:getConfig()
    log.info("CommentToggleRound:getConfig", self.difficulty)

    local timeConfig = {
        noob = 45000,
        easy = 40000,
        medium = 35000,
        hard = 30000,
        nightmare = 25000,
        tpope = 20000
    }

    self.winDetected = false
    self:generateChallenge()

    return {
        roundTime = timeConfig[self.difficulty] or 35000,
        canEndRound = true,
    }
end

function CommentToggleRound:generateChallenge()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy

    self.currentChallenge = config.challenges[math.random(#config.challenges)]
    log.info("CommentToggleRound:generateChallenge", self.currentChallenge.name)
end

function CommentToggleRound:checkForWin()
    log.info("CommentToggleRound:checkForWin START")

    if not self.currentChallenge then
        log.info("CommentToggleRound:checkForWin - no currentChallenge")
        return false
    end

    if not self.window or not self.window.bufh then
        log.info("CommentToggleRound:checkForWin - no window/buffer")
        return false
    end

    local allLines = vim.api.nvim_buf_get_lines(self.window.bufh, 0, -1, false)

    local codeStartLine = nil
    for i, line in ipairs(allLines) do
        if line:match("^%-%-%-.*Current Code") then
            codeStartLine = i + 1
            break
        end
    end

    if not codeStartLine then
        log.info("CommentToggleRound:checkForWin - no code section found")
        return false
    end

    local currentLines = {}
    for i = 1, #self.currentChallenge.targetText do
        local lineIndex = codeStartLine + i - 1
        if lineIndex <= #allLines then
            table.insert(currentLines, allLines[lineIndex])
        else
            table.insert(currentLines, "")
        end
    end

    local targetLines = self.currentChallenge.targetText

    log.info("CommentToggleRound:checkForWin",
        "codeStartLine:", codeStartLine,
        "currentLines count:", #currentLines,
        "targetLines count:", #targetLines)
    log.info("CommentToggleRound:checkForWin - currentLines:", vim.inspect(currentLines))
    log.info("CommentToggleRound:checkForWin - targetLines:", vim.inspect(targetLines))

    if #currentLines ~= #targetLines then
        log.info("CommentToggleRound:checkForWin - line count mismatch", #currentLines, #targetLines)
        return false
    end

    for i, currentLine in ipairs(currentLines) do
        local currentTrimmed = currentLine:gsub("%s+$", "")
        local targetTrimmed = targetLines[i]:gsub("%s+$", "")

        if currentTrimmed ~= targetTrimmed then
            log.info("CommentToggleRound:checkForWin - line mismatch at", i,
                "current:", vim.inspect(currentTrimmed),
                "target:", vim.inspect(targetTrimmed))
            return false
        end
    end

    log.info("CommentToggleRound:checkForWin - SUCCESS! Comment toggle mastery achieved")
    return true
end

function CommentToggleRound:render()
    if not self.currentChallenge then
        log.info("CommentToggleRound:render - no currentChallenge")
        return {}, 0, 0
    end

    local lines = {}

    table.insert(lines, "📝 " .. self.currentChallenge.name)
    table.insert(lines, "")
    table.insert(lines, "Task: " .. self.currentChallenge.task)
    table.insert(lines, "Operation: " .. self.currentChallenge.operation)

    if self.currentChallenge.hint then
        table.insert(lines, "Hint: " .. self.currentChallenge.hint)
    end

    table.insert(lines, "")
    table.insert(lines, "--- Current Code ---")

    local codeStartLine = #lines + 1
    for _, line in ipairs(self.currentChallenge.startText) do
        table.insert(lines, line)
    end

    table.insert(lines, "")
    table.insert(lines, "--- Target State ---")
    for _, line in ipairs(self.currentChallenge.targetText) do
        table.insert(lines, "  " .. line)
    end

    local cursorLine = codeStartLine + (self.currentChallenge.cursorPos.line - 1)
    local cursorCol = self.currentChallenge.cursorPos.col - 1

    log.info("CommentToggleRound:render",
        "challenge=" .. self.currentChallenge.name,
        "lines=" .. #lines,
        "cursor=" .. cursorLine .. "," .. cursorCol)

    return lines, cursorLine, cursorCol
end

function CommentToggleRound:name()
    return "comment-toggle"
end

function CommentToggleRound:setEndRoundCallback(callback)
    log.info("CommentToggleRound:setEndRoundCallback", callback ~= nil)
    self.endRoundCallback = callback
    self.winDetected = false

    if self.currentChallenge and self.currentChallenge.fileType and self.window and self.window.bufh then
        vim.schedule(function()
            vim.api.nvim_buf_set_option(self.window.bufh, 'filetype', self.currentChallenge.fileType)
            log.info("CommentToggleRound:setEndRoundCallback - set filetype", self.currentChallenge.fileType)

            self:setupTextChangeMonitoring()
        end)
    end
end

function CommentToggleRound:setupTextChangeMonitoring()
    local augroup_name = "CommentToggleCheck_" .. vim.fn.localtime()
    self.textCheckAugroup = augroup_name

    vim.api.nvim_create_augroup(augroup_name, { clear = true })

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        group = augroup_name,
        buffer = self.window.bufh,
        callback = function()
            self:onTextChanged()
        end
    })

    log.info("CommentToggleRound:setupTextChangeMonitoring - Created augroup:", augroup_name)
end

function CommentToggleRound:cleanupTextChangeMonitoring()
    if self.textCheckAugroup then
        pcall(vim.api.nvim_del_augroup_by_name, self.textCheckAugroup)
        log.info("CommentToggleRound:cleanupTextChangeMonitoring - Removed augroup:", self.textCheckAugroup)
        self.textCheckAugroup = nil
    end
end

function CommentToggleRound:onTextChanged()
    log.info("CommentToggleRound:onTextChanged - Text changed!")

    if self.winDetected then
        return
    end

    vim.defer_fn(function()
        if self.winDetected then
            return
        end

        if self:checkForWin() then
            log.info("CommentToggleRound:onTextChanged - PLAYER WON!")
            self.winDetected = true
            self:cleanupTextChangeMonitoring()

            if self.endRoundCallback then
                self.endRoundCallback(true)
            end
        end
    end, 100)
end

function CommentToggleRound:cleanup()
    log.info("CommentToggleRound:cleanup")
    self:cleanupTextChangeMonitoring()
    self.endRoundCallback = nil
    self.winDetected = false
end

return CommentToggleRound
