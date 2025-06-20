local difficultyConfig = require("vim-be-better.games.advanced.configs.fold-master-config")

local instructions = {
    "--- Fold Master ---",
    "",
    "Master vim folds for efficient code navigation and organization!",
    "Use folding to hide/show sections and navigate large files efficiently.",
    "",
    "  za       - toggle fold at cursor",
    "  zo       - open fold at cursor",
    "  zc       - close fold at cursor",
    "  zR       - open all folds",
    "  zM       - close all folds",
    "",
    "Goal: Navigate and organize code using fold operations.",
}

local FoldMasterRound = {}

function FoldMasterRound:new(difficulty, window)
    local round = {
        window = window,
        difficulty = difficulty or "easy",
        currentChallenge = nil,
        endRoundCallback = nil,
        winDetected = false,
        originalKeymaps = {},
    }

    self.__index = self
    return setmetatable(round, self)
end

function FoldMasterRound:name()
    return "fold-master"
end

function FoldMasterRound:getInstructions()
    return instructions
end

function FoldMasterRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
    self.winDetected = false

    if self.setupComplete and not self.setupInProgress then
        self:setupFoldKeymaps()
    end
end

function FoldMasterRound:getConfig()
    local timeConfig = {
        noob = 30000,
        easy = 35000,
        medium = 40000,
        hard = 45000,
        nightmare = 50000,
        tpope = 40000
    }

    self.winDetected = false
    self.setupComplete = false
    self:restoreOriginalKeymaps()

    if self.setupInProgress then
        return {
            roundTime = timeConfig[self.difficulty] or 35000,
            canEndRound = true,
        }
    end

    self.setupInProgress = true
    self:generateChallenge()

    vim.schedule(function()
        if self.window and self.window.bufh then
            vim.api.nvim_buf_set_option(self.window.bufh, 'modifiable', true)

            if self.currentChallenge.foldSetup then
                vim.defer_fn(function()
                    if not self.endRoundCallback or self.winDetected then
                        self.setupInProgress = false
                        return
                    end

                    self:setupFoldsForChallenge()

                    if self.endRoundCallback and not self.winDetected then
                        self:setupFoldKeymaps()
                    end

                    self.setupInProgress = false
                    self.setupComplete = true
                end, 150)
            else
                self.setupInProgress = false
                self.setupComplete = true
            end
        else
            self.setupInProgress = false
            self.setupComplete = true
        end
    end)

    return {
        roundTime = timeConfig[self.difficulty] or 35000,
        canEndRound = true,
    }
end

function FoldMasterRound:generateChallenge()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy

    self.currentChallenge = config.challenges[math.random(#config.challenges)]
end

function FoldMasterRound:setupFoldsForChallenge()
    local bufh = self.window.bufh
    local foldSetup = self.currentChallenge.foldSetup

    if not foldSetup then
        return
    end

    vim.api.nvim_buf_call(bufh, function()
        vim.opt_local.foldenable = true
        vim.opt_local.foldmethod = 'manual'
        vim.opt_local.foldlevel = 99

        vim.cmd('normal! zE')

        local allLines = vim.api.nvim_buf_get_lines(bufh, 0, -1, false)
        local codeStartLine = 12
        for i, line in ipairs(allLines) do
            if line:match("^Goal:") then
                codeStartLine = i + 1
                break
            end
        end

        for i, fold in ipairs(foldSetup.folds) do
            local adjustedStart = codeStartLine + fold.start - 1
            local adjustedEnd = codeStartLine + fold["end"] - 1

            vim.cmd(string.format("%d,%dfold", adjustedStart, adjustedEnd))

            vim.api.nvim_win_set_cursor(0, { adjustedStart, 0 })
            if fold.closed then
                vim.cmd('normal! zc')
            else
                vim.cmd('normal! zo')
            end
        end

        local cursorLine = codeStartLine + (self.currentChallenge.cursorPos.line or 1) - 1
        local cursorCol = (self.currentChallenge.cursorPos.col or 1) - 1
        vim.api.nvim_win_set_cursor(0, { cursorLine, cursorCol })
    end)
end

function FoldMasterRound:setupFoldKeymaps()
    local bufh = self.window.bufh

    local fold_keys = {
        'za', 'zA', 'zo', 'zO', 'zc', 'zC',
        'zr', 'zR', 'm', 'zM', 'zi', 'zn', 'zN',
        'zf', 'zF', 'zd', 'zD', 'zE'
    }

    self:restoreOriginalKeymaps()

    for _, key in ipairs(fold_keys) do
        local existing_map = vim.fn.maparg(key, 'n', false, true)
        if existing_map and existing_map.buffer == bufh then
            self.originalKeymaps[key] = existing_map
        end

        vim.api.nvim_buf_set_keymap(bufh, 'n', key, '', {
            callback = function()
                self:handleFoldOperation(key)
            end,
            noremap = true,
            silent = true,
            desc = "Fold Master: " .. key
        })
    end
end

function FoldMasterRound:handleFoldOperation(key)
    if self.winDetected or not self.endRoundCallback then
        return
    end

    vim.cmd('normal! ' .. key)

    vim.defer_fn(function()
        if self.winDetected or not self.endRoundCallback then
            return
        end

        if self:checkForWin() then
            self.winDetected = true

            local callback = self.endRoundCallback
            self.endRoundCallback = nil

            self:restoreOriginalKeymaps()

            if callback then
                vim.defer_fn(function()
                    callback(true)
                end, 10)
            end
        end
    end, 50)
end

function FoldMasterRound:restoreOriginalKeymaps()
    local bufh = self.window.bufh
    if not bufh or not vim.api.nvim_buf_is_valid(bufh) then
        return
    end

    local fold_keys = {
        'za', 'zA', 'zo', 'zO', 'zc', 'zC',
        'zr', 'zR', 'm', 'zM', 'zi', 'zn', 'zN',
        'zf', 'zF', 'zd', 'zD', 'zE'
    }

    for _, key in ipairs(fold_keys) do
        local current_map = vim.fn.maparg(key, 'n', false, true)
        if current_map and current_map.buffer == bufh and
            current_map.desc and current_map.desc:match("^Fold Master:") then
            pcall(vim.api.nvim_buf_del_keymap, bufh, 'n', key)

            if self.originalKeymaps[key] then
                local orig = self.originalKeymaps[key]
                vim.api.nvim_buf_set_keymap(bufh, 'n', key, orig.rhs or '', {
                    noremap = orig.noremap == 1,
                    silent = orig.silent == 1,
                    expr = orig.expr == 1,
                    desc = orig.desc
                })
            end
        end
    end

    self.originalKeymaps = {}
end

function FoldMasterRound:checkForWin()
    if self.setupInProgress or not self.setupComplete then
        return false
    end

    if not self.currentChallenge then
        return false
    end

    local winCondition = self.currentChallenge.winCondition
    if not winCondition then
        return false
    end


    local allLines = vim.api.nvim_buf_get_lines(self.window.bufh, 0, -1, false)
    local codeStartLine = 12
    for i, line in ipairs(allLines) do
        if line:match("^Goal:") then
            codeStartLine = i + 1
            break
        end
    end


    if winCondition.type == "fold_open" then
        local targetFold = winCondition.targetFold
        local adjustedStart = codeStartLine + targetFold.start - 1
        local adjustedEnd = codeStartLine + targetFold["end"] - 1
        local isOpen = self:isFoldOpen(adjustedStart, adjustedEnd)
        return isOpen
    elseif winCondition.type == "fold_closed" then
        local targetFold = winCondition.targetFold
        local adjustedStart = codeStartLine + targetFold.start - 1
        local adjustedEnd = codeStartLine + targetFold["end"] - 1
        local isOpen = self:isFoldOpen(adjustedStart, adjustedEnd)
        return not isOpen
    elseif winCondition.type == "all_closed" then
        local foldSetup = self.currentChallenge.foldSetup
        for _, fold in ipairs(foldSetup.folds) do
            local adjustedStart = codeStartLine + fold.start - 1
            local adjustedEnd = codeStartLine + fold["end"] - 1
            if self:isFoldOpen(adjustedStart, adjustedEnd) then
                return false
            end
        end
        return true
    elseif winCondition.type == "specific_states" then
        for _, state in ipairs(winCondition.states) do
            local adjustedStart = codeStartLine + state.start - 1
            local adjustedEnd = codeStartLine + state["end"] - 1
            local isOpen = self:isFoldOpen(adjustedStart, adjustedEnd)

            if state.shouldBeOpen and not isOpen then
                return false
            elseif not state.shouldBeOpen and isOpen then
                return false
            end
        end
        return true
    end

    return false
end

function FoldMasterRound:isFoldOpen(startLine, endLine)
    for i = startLine, endLine do
        local foldclosed = vim.fn.foldclosed(i)
        if foldclosed ~= -1 then
            return false
        end
    end

    return true
end

function FoldMasterRound:render()
    if not self.currentChallenge then
        return {}
    end

    local lines = {}

    for _, line in ipairs(self.currentChallenge.startText) do
        table.insert(lines, line)
    end

    table.insert(lines, "")
    table.insert(lines, "--- TASK ---")
    table.insert(lines, self.currentChallenge.task)
    table.insert(lines, "")
    table.insert(lines, "--- HINT ---")
    table.insert(lines, self.currentChallenge.hint)
    table.insert(lines, "")
    table.insert(lines, "Operation: " .. self.currentChallenge.operation)

    return lines
end

function FoldMasterRound:cleanup()
    self:restoreOriginalKeymaps()
    self.endRoundCallback = nil
    self.winDetected = true
end

return FoldMasterRound
