local log = require("vim-be-better.log")
local bind = require("vim-be-better.bind")
local types = require("vim-be-better.types")

vim.g["vim_be_better_log_file"] = true
vim.g["vim_be_better_log_console"] = false

local Menu = {}

local categoryHeader = {
    "",
    "Select a Game Category (select with [x])",
    "----------------------------------------",
}

local gameHeader = {
    "",
    "Select a Game (select with \"x\" key)",
    "-------------------------------",
}

local difficultyHeader = {
    "",
    "Select a Difficulty (select with \"x\" key)",
    "Noob difficulty is endless so it must be quit with :q",
    "----------------------------------------------------",
}

local instructions = {
    "VimBeBetter is a fork of VimBeGood - collection of small games for neovim which are",
    "intended to help you improve your vim proficiency.",
    "First select a category, then a game, and finally a difficulty.",
    "Change [x] to select options."
}

local credits = {
    "",
    "",
    "VimBeBetter was created by Szymon Wilczek",
    "github.com/szymonwilczek/vim-be-better",
    "",
    "",
    "Original credits for VimBeGood:",
    "Created by ThePrimeagen",
    "Brandoncc",
    "polarmutex",
    "",
    "https://github.com/ThePrimeagen/vim-be-better",
}

local MenuState = {
    CATEGORY_SELECTION = "category_selection",
    GAME_SELECTION = "game_selection",
    DIFFICULTY_SELECTION = "difficulty_selection"
}

function Menu:new(window, onResults)
    local menuObj = {
        window = window,
        buffer = window.buffer,
        onResults = onResults,
        currentState = MenuState.CATEGORY_SELECTION,
        selectedCategory = nil,
        selectedGame = nil,
        difficulty = types.difficulty[2],
        lastRenderedLines = {},
        isRerendering = false,
        lineTypeMap = {},
    }

    window.buffer:clear()
    window.buffer:setInstructions(instructions)

    self.__index = self
    local createdMenu = setmetatable(menuObj, self)

    createdMenu._onChange = bind(createdMenu, "onChange")
    window.buffer:onChange(createdMenu._onChange)

    return createdMenu
end

function Menu:getExpectedMenuLength()
    if self.currentState == MenuState.CATEGORY_SELECTION then
        return #categoryHeader + #types.categories + #credits
    elseif self.currentState == MenuState.GAME_SELECTION then
        local gamesInCategory = types.gamesByCategory[self.selectedCategory] or {}
        return #gameHeader + #gamesInCategory + #credits
    elseif self.currentState == MenuState.DIFFICULTY_SELECTION then
        return #difficultyHeader + #types.difficulty + #credits
    end
    return 0
end

function Menu:buildLineTypeMap()
    local map = {}
    local lineIndex = 1

    if self.currentState == MenuState.CATEGORY_SELECTION then
        for i = 1, #categoryHeader do
            map[lineIndex] = { type = "category_header", index = i }
            lineIndex = lineIndex + 1
        end

        for i = 1, #types.categories do
            map[lineIndex] = { type = "category", index = i, value = types.categories[i] }
            lineIndex = lineIndex + 1
        end
    elseif self.currentState == MenuState.GAME_SELECTION then
        for i = 1, #gameHeader do
            map[lineIndex] = { type = "game_header", index = i }
            lineIndex = lineIndex + 1
        end

        local gamesInCategory = types.gamesByCategory[self.selectedCategory] or {}
        for i = 1, #gamesInCategory do
            map[lineIndex] = { type = "game", index = i, value = gamesInCategory[i] }
            lineIndex = lineIndex + 1
        end
    elseif self.currentState == MenuState.DIFFICULTY_SELECTION then
        for i = 1, #difficultyHeader do
            map[lineIndex] = { type = "difficulty_header", index = i }
            lineIndex = lineIndex + 1
        end

        for i = 1, #types.difficulty do
            map[lineIndex] = { type = "difficulty", index = i, value = types.difficulty[i] }
            lineIndex = lineIndex + 1
        end
    end

    for i = 1, #credits do
        map[lineIndex] = { type = "credits", index = i }
        lineIndex = lineIndex + 1
    end

    self.lineTypeMap = map
    return map
end

function Menu:detectChanges(currentLines)
    local expectedLength = self:getExpectedMenuLength()
    local currentLength = #currentLines

    if currentLength ~= expectedLength then
        return true, "length_mismatch"
    end

    for i, line in ipairs(currentLines) do
        local lineInfo = self.lineTypeMap[i]
        if not lineInfo then
            return true, "unknown_line"
        end

        local expectedLine = self:getExpectedLineContent(lineInfo)
        if line ~= expectedLine then

            if lineInfo.type == "category" then
                return false, "category_selected", lineInfo.value
            end

            if lineInfo.type == "game" then
                return false, "game_selected", lineInfo.value
            end

            if lineInfo.type == "difficulty" then
                return false, "difficulty_selected", lineInfo.value
            end

            return true, "line_modified"
        end
    end

    return false, "no_changes"
end

function Menu:getExpectedLineContent(lineInfo)
    if lineInfo.type == "category_header" then
        return categoryHeader[lineInfo.index]
    elseif lineInfo.type == "category" then
        return self:createMenuItem(lineInfo.value, self.selectedCategory)
    elseif lineInfo.type == "game_header" then
        return gameHeader[lineInfo.index]
    elseif lineInfo.type == "game" then
        return self:createMenuItem(lineInfo.value, self.selectedGame)
    elseif lineInfo.type == "difficulty_header" then
        return difficultyHeader[lineInfo.index]
    elseif lineInfo.type == "difficulty" then
        return self:createMenuItem(lineInfo.value, self.difficulty)
    elseif lineInfo.type == "credits" then
        return credits[lineInfo.index]
    end
    return ""
end

function Menu:onChange()
    if self.isRerendering then
        return
    end

    local currentLines = self.window.buffer:getGameLines()

    if not self.lineTypeMap or #self.lineTypeMap == 0 then
        self:buildLineTypeMap()
    end

    local hasChanges, changeType, selectedValue = self:detectChanges(currentLines)

    if changeType == "category_selected" then
        self.selectedCategory = selectedValue
        self.currentState = MenuState.GAME_SELECTION
        self:safeRerender("category_change")
        return
    elseif changeType == "game_selected" then
        self.selectedGame = selectedValue
        self.currentState = MenuState.DIFFICULTY_SELECTION
        self:safeRerender("game_change")
        return
    elseif changeType == "difficulty_selected" then
        self.difficulty = selectedValue

        local ok, msg = pcall(self.onResults, self.selectedGame, self.difficulty)
        if not ok then
            log.error("Menu:onChange - Error while trying to run a game: ", "error:", msg)
        end
        return
    elseif hasChanges then
        self:safeRerender("restore_menu")
        return
    end
end

function Menu:safeRerender(reason)
    log.info("Menu:safeRerender - starting re-rendering",
        "reason:", reason,
        "state:", self.currentState)

    if self.isRerendering then
        return
    end

    self.isRerendering = true

    vim.schedule(function()

        pcall(function()
            self:render()
        end)

        vim.defer_fn(function()
            self.isRerendering = false
        end, 50)
    end)
end

function Menu:createMenuItem(str, currentValue)
    if currentValue == str then
        return "[x] " .. str
    end
    return "[ ] " .. str
end

function Menu:render()
    self.window.buffer:clearGameLines()

    local lines = {}

    if self.currentState == MenuState.CATEGORY_SELECTION then
        for idx = 1, #categoryHeader do
            table.insert(lines, categoryHeader[idx])
        end

        for idx = 1, #types.categories do
            table.insert(lines, self:createMenuItem(types.categories[idx], self.selectedCategory))
        end
    elseif self.currentState == MenuState.GAME_SELECTION then
        for idx = 1, #gameHeader do
            table.insert(lines, gameHeader[idx])
        end

        local gamesInCategory = types.gamesByCategory[self.selectedCategory] or {}
        for idx = 1, #gamesInCategory do
            table.insert(lines, self:createMenuItem(gamesInCategory[idx], self.selectedGame))
        end
    elseif self.currentState == MenuState.DIFFICULTY_SELECTION then
        for idx = 1, #difficultyHeader do
            table.insert(lines, difficultyHeader[idx])
        end

        for idx = 1, #types.difficulty do
            table.insert(lines, self:createMenuItem(types.difficulty[idx], self.difficulty))
        end
    end

    for idx = 1, #credits do
        table.insert(lines, credits[idx])
    end

    self.lastRenderedLines = vim.deepcopy(lines)

    self:buildLineTypeMap()

    self.window.buffer:render(lines)
end

function Menu:close()
    if self.buffer and self._onChange then
        self.buffer:removeListener(self._onChange)
    end

    self.lineTypeMap = {}
    self.lastRenderedLines = {}
    self.isRerendering = false
    self.currentState = MenuState.CATEGORY_SELECTION
    self.selectedCategory = nil
    self.selectedGame = nil
end

return Menu
