local log = require("vim-be-better.log")
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
    log.info("FoldMasterRound:new", difficulty, window)

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
    log.info("FoldMasterRound:setEndRoundCallback", callback ~= nil)
    self.endRoundCallback = callback
    self.winDetected = false

    if self.setupComplete and not self.setupInProgress then
        log.info("FoldMasterRound:setEndRoundCallback - setup already complete, setting up keymaps now")
        self:setupFoldKeymaps()
    end
end

function FoldMasterRound:getConfig()
    log.info("FoldMasterRound:getConfig", self.difficulty)

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
        log.info("FoldMasterRound:getConfig - setup already in progress, skipping")
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
                        log.info("FoldMasterRound:getConfig - no callback or win detected, skipping setup")
                        self.setupInProgress = false
                        return
                    end

                    self:setupFoldsForChallenge()

                    if self.endRoundCallback and not self.winDetected then
                        self:setupFoldKeymaps()
                    end

                    self.setupInProgress = false
                    self.setupComplete = true

                    log.info("FoldMasterRound:getConfig - setup complete, fold state ready")
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
    log.info("FoldMasterRound:generateChallenge", self.currentChallenge.name)
end

function FoldMasterRound:setupFoldsForChallenge()
    log.info("FoldMasterRound:setupFoldsForChallenge START")

    local bufh = self.window.bufh
    local foldSetup = self.currentChallenge.foldSetup

    if not foldSetup then
        log.info("FoldMasterRound:setupFoldsForChallenge - no foldSetup")
        return
    end

    log.info("FoldMasterRound:setupFoldsForChallenge - setting up folds", #foldSetup.folds)

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

        log.info("FoldMasterRound:setupFoldsForChallenge - codeStartLine", codeStartLine)

        for i, fold in ipairs(foldSetup.folds) do
            local adjustedStart = codeStartLine + fold.start - 1
            local adjustedEnd = codeStartLine + fold["end"] - 1

            log.info("FoldMasterRound:setupFoldsForChallenge - creating fold", i, adjustedStart, adjustedEnd, fold
                .closed)

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

        log.info("FoldMasterRound:setupFoldsForChallenge - cursor set to", cursorLine, cursorCol)
    end)

    log.info("FoldMasterRound:setupFoldsForChallenge END")
end

function FoldMasterRound:setupFoldKeymaps()
    log.info("FoldMasterRound:setupFoldKeymaps START")

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
            log.info("FoldMasterRound:setupFoldKeymaps - saved existing mapping for", key)
        end

        vim.api.nvim_buf_set_keymap(bufh, 'n', key, '', {
            callback = function()
                self:handleFoldOperation(key)
            end,
            noremap = true,
            silent = true,
            desc = "Fold Master: " .. key
        })

        log.info("FoldMasterRound:setupFoldKeymaps - set mapping for", key)
    end

    log.info("FoldMasterRound:setupFoldKeymaps END")
end

function FoldMasterRound:handleFoldOperation(key)
    log.info("FoldMasterRound:handleFoldOperation", key)

    if self.winDetected or not self.endRoundCallback then
        log.info("FoldMasterRound:handleFoldOperation - game ended, ignoring", key)
        return
    end

    vim.cmd('normal! ' .. key)

    vim.defer_fn(function()
        if self.winDetected or not self.endRoundCallback then
            return
        end

        if self:checkForWin() then
            log.info("FoldMasterRound:handleFoldOperation - WIN DETECTED after", key)

            self.winDetected = true

            local callback = self.endRoundCallback
            self.endRoundCallback = nil

            self:restoreOriginalKeymaps()

            if callback then
                vim.defer_fn(function()
                    log.info("FoldMasterRound:handleFoldOperation - calling endRoundCallback")
                    callback(true)
                end, 10)
            end
        end
    end, 50)
end

function FoldMasterRound:restoreOriginalKeymaps()
    log.info("FoldMasterRound:restoreOriginalKeymaps START")

    local bufh = self.window.bufh
    if not bufh or not vim.api.nvim_buf_is_valid(bufh) then
        log.info("FoldMasterRound:restoreOriginalKeymaps - invalid buffer")
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
            log.info("FoldMasterRound:restoreOriginalKeymaps - removed mapping for", key)

            if self.originalKeymaps[key] then
                local orig = self.originalKeymaps[key]
                vim.api.nvim_buf_set_keymap(bufh, 'n', key, orig.rhs or '', {
                    noremap = orig.noremap == 1,
                    silent = orig.silent == 1,
                    expr = orig.expr == 1,
                    desc = orig.desc
                })
                log.info("FoldMasterRound:restoreOriginalKeymaps - restored original mapping for", key)
            end
        end
    end

    self.originalKeymaps = {}

    log.info("FoldMasterRound:restoreOriginalKeymaps END")
end

function FoldMasterRound:checkForWin()
    log.info("FoldMasterRound:checkForWin START")

    if self.setupInProgress or not self.setupComplete then
        log.info("FoldMasterRound:checkForWin - setup not complete, skipping")
        return false
    end

    if not self.currentChallenge then
        log.info("FoldMasterRound:checkForWin - no currentChallenge")
        return false
    end

    local winCondition = self.currentChallenge.winCondition
    if not winCondition then
        log.info("FoldMasterRound:checkForWin - no winCondition")
        return false
    end

    log.info("FoldMasterRound:checkForWin - checking condition", winCondition.type)

    local allLines = vim.api.nvim_buf_get_lines(self.window.bufh, 0, -1, false)
    local codeStartLine = 12
    for i, line in ipairs(allLines) do
        if line:match("^Goal:") then
            codeStartLine = i + 1
            break
        end
    end

    log.info("FoldMasterRound:checkForWin - codeStartLine", codeStartLine)

    if winCondition.type == "fold_open" then
        local targetFold = winCondition.targetFold
        local adjustedStart = codeStartLine + targetFold.start - 1
        local adjustedEnd = codeStartLine + targetFold["end"] - 1
        local isOpen = self:isFoldOpen(adjustedStart, adjustedEnd)
        log.info("FoldMasterRound:checkForWin - fold_open check", adjustedStart, adjustedEnd, isOpen)
        return isOpen
    elseif winCondition.type == "fold_closed" then
        local targetFold = winCondition.targetFold
        local adjustedStart = codeStartLine + targetFold.start - 1
        local adjustedEnd = codeStartLine + targetFold["end"] - 1
        local isOpen = self:isFoldOpen(adjustedStart, adjustedEnd)
        log.info("FoldMasterRound:checkForWin - fold_closed check", adjustedStart, adjustedEnd, not isOpen)
        return not isOpen
    elseif winCondition.type == "all_closed" then
        local foldSetup = self.currentChallenge.foldSetup
        for _, fold in ipairs(foldSetup.folds) do
            local adjustedStart = codeStartLine + fold.start - 1
            local adjustedEnd = codeStartLine + fold["end"] - 1
            if self:isFoldOpen(adjustedStart, adjustedEnd) then
                log.info("FoldMasterRound:checkForWin - all_closed failed, fold open", adjustedStart, adjustedEnd)
                return false
            end
        end
        log.info("FoldMasterRound:checkForWin - all_closed success")
        return true
    elseif winCondition.type == "specific_states" then
        for _, state in ipairs(winCondition.states) do
            local adjustedStart = codeStartLine + state.start - 1
            local adjustedEnd = codeStartLine + state["end"] - 1
            local isOpen = self:isFoldOpen(adjustedStart, adjustedEnd)

            if state.shouldBeOpen and not isOpen then
                log.info("FoldMasterRound:checkForWin - specific_states failed, should be open", adjustedStart,
                    adjustedEnd)
                return false
            elseif not state.shouldBeOpen and isOpen then
                log.info("FoldMasterRound:checkForWin - specific_states failed, should be closed", adjustedStart,
                    adjustedEnd)
                return false
            end
        end
        log.info("FoldMasterRound:checkForWin - specific_states success")
        return true
    end

    log.info("FoldMasterRound:checkForWin - unknown condition type")
    return false
end

function FoldMasterRound:isFoldOpen(startLine, endLine)
    log.info("FoldMasterRound:isFoldOpen checking", startLine, endLine)

    for i = startLine, endLine do
        local foldclosed = vim.fn.foldclosed(i)
        if foldclosed ~= -1 then
            log.info("FoldMasterRound:isFoldOpen - fold closed at line", i, foldclosed)
            return false
        end
    end

    log.info("FoldMasterRound:isFoldOpen - fold is open")
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
    log.info("FoldMasterRound:cleanup")
    self:restoreOriginalKeymaps()
    self.endRoundCallback = nil
    self.winDetected = true
end

return FoldMasterRound
