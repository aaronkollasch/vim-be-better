local log = require("vim-be-better.log")
local bind = require("vim-be-better.bind")
local types = require("vim-be-better.types")

local Menu = {}

local MENU_STATES = {
    MAIN = "main",
    CATEGORY = "category",
    DIFFICULTY = "difficulty"
}

local mainMenuHeader = {
    "",
    "🎮 VIM BE BETTER - Select Category",
    "==================================",
    "(delete a line to select)",
    ""
}

local categoryHeader = {
    "",
    "Select a Game (delete from the list to select)",
    "----------------------------------------------",
}

local difficultyHeader = {
    "",
    "Select a Difficulty (delete from the list to select)",
    "Noob difficulty is endless so it must be quit with :q",
    "----------------------------------------------------",
}

local instructions = {
    "VimBeBetter is a collection of categorized mini-games for neovim",
    "designed to systematically improve your vim proficiency.",
    "",
    "🎯 Navigation        - Master vim movement commands",
    "✂️ Text Objects      - Learn powerful text manipulation",
    "🔄 Substitution      - Master find & replace operations",
    "📝 Formatting        - Text formatting and structure",
    "🔍 Search            - Advanced search techniques",
    "🎨 Visual Mode       - Selection and visual operations",
    "🔢 Numbers           - Numeric operations and sequences",
    "🏗️ Advanced          - Macros, folds, and complex features",
    "🎪 Challenges        - Mixed skill challenges",
    "📚 Classics (legacy) - Original vim-be-good games",
    "",
    "Navigation: Use hjkl, delete line (dd) to select"
}

local credits = {
    "",
    "",
    "Extended by Szymon Wilczek",
    "Based on vim-be-good by ThePrimeagen",
    "",
    "https://github.com/your-username/vim-be-better",
}

function Menu:new(window, onResults)
    local menuObj = {
        window = window,
        buffer = window.buffer,
        onResults = onResults,

        state = MENU_STATES.MAIN,
        selectedCategory = nil,
        selectedGame = nil,

        difficulty = types.difficulty[2], -- easy
    }

    window.buffer:clear()
    window.buffer:setInstructions(instructions)

    self.__index = self
    local createdMenu = setmetatable(menuObj, self)

    createdMenu._onChange = bind(createdMenu, "onChange")
    window.buffer:onChange(createdMenu._onChange)

    return createdMenu
end

function Menu:showMainMenu()
    self.state = MENU_STATES.MAIN
    self.selectedCategory = nil
    self.selectedGame = nil

    local lines = {}

    for _, line in ipairs(mainMenuHeader) do
        table.insert(lines, line)
    end

    for i, category in ipairs(types.categories) do
        table.insert(lines, "[ ] " .. category)
    end

    table.insert(lines, "")
    table.insert(lines, "[ ] 🚪 Exit")

    for _, line in ipairs(credits) do
        table.insert(lines, line)
    end

    self.window.buffer:render(lines)
end

function Menu:showCategoryMenu(categoryIndex)
    self.state = MENU_STATES.CATEGORY
    self.selectedCategory = categoryIndex

    local lines = {}

    for _, line in ipairs(categoryHeader) do
        table.insert(lines, line)
    end

    table.insert(lines, "Category: " .. types.categories[categoryIndex])
    table.insert(lines, "")

    local categoryGames = types.getGamesByCategory(categoryIndex)
    for _, game in ipairs(categoryGames) do
        table.insert(lines, "[ ] " .. game)
    end

    table.insert(lines, "")
    table.insert(lines, "[ ] ⬅️ Back to Categories")
    table.insert(lines, "[ ] 🚪 Exit")

    self.window.buffer:render(lines)
end

function Menu:showDifficultyMenu(game)
    self.state = MENU_STATES.DIFFICULTY
    self.selectedGame = game

    local lines = {}

    for _, line in ipairs(difficultyHeader) do
        table.insert(lines, line)
    end

    table.insert(lines, "Selected Game: " .. game)
    table.insert(lines, "")

    for _, difficulty in ipairs(types.difficulty) do
        local marker = (difficulty == self.difficulty) and "[x]" or "[ ]"
        table.insert(lines, marker .. " " .. difficulty)
    end

    table.insert(lines, "")
    table.insert(lines, "[ ] ⬅️ Back to Games")
    table.insert(lines, "[ ] 🏠 Main Menu")
    table.insert(lines, "[ ] 🚪 Exit")

    self.window.buffer:render(lines)
end

function Menu:onChange()
    local lines = self.window.buffer:getGameLines()

    if self.state == MENU_STATES.MAIN then
        self:handleMainMenuChange(lines)
    elseif self.state == MENU_STATES.CATEGORY then
        self:handleCategoryMenuChange(lines)
    elseif self.state == MENU_STATES.DIFFICULTY then
        self:handleDifficultyMenuChange(lines)
    end
end

function Menu:handleMainMenuChange(lines)
    for i, category in ipairs(types.categories) do
        local expectedLine = "[ ] " .. category
        local found = false

        for _, line in ipairs(lines) do
            if line == expectedLine then
                found = true
                break
            end
        end

        if not found then
            self:showCategoryMenu(i)
            return
        end
    end

    local exitFound = false
    for _, line in ipairs(lines) do
        if line == "[ ] 🚪 Exit" then
            exitFound = true
            break
        end
    end

    if not exitFound then
        endItAll()
    end
end

function Menu:handleCategoryMenuChange(lines)
    if not self.selectedCategory then return end

    local categoryGames = types.getGamesByCategory(self.selectedCategory)

    for _, game in ipairs(categoryGames) do
        local expectedLine = "[ ] " .. game
        local found = false

        for _, line in ipairs(lines) do
            if line == expectedLine then
                found = true
                break
            end
        end

        if not found then
            self:showDifficultyMenu(game)
            return
        end
    end

    self:handleNavigationOptions(lines)
end

function Menu:handleDifficultyMenuChange(lines)
    if not self.selectedGame then return end

    for _, difficulty in ipairs(types.difficulty) do
        local expectedLine = "[ ] " .. difficulty
        local markedLine = "[x] " .. difficulty
        local found = false

        for _, line in ipairs(lines) do
            if line == expectedLine or line == markedLine then
                found = true
                break
            end
        end

        if not found then
            log.info("Starting game:", self.selectedGame, "difficulty:", difficulty)
            self.onResults(self.selectedGame, difficulty)
            return
        end
    end

    self:handleNavigationOptions(lines)
end

function Menu:handleNavigationOptions(lines)
    for _, line in ipairs(lines) do
        if line:match("⬅️ Back") then
            return
        end
    end

    if self.state == MENU_STATES.CATEGORY then
        self:showMainMenu()
    elseif self.state == MENU_STATES.DIFFICULTY then
        self:showCategoryMenu(self.selectedCategory)
    end
end

function Menu:render()
    self:showMainMenu()
end

function Menu:close()
    self.buffer:removeListener(self._onChange)
end

return Menu
