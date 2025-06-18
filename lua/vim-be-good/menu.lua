<<<<<<< HEAD:lua/vim-be-better/menu.lua
local log = require("vim-be-better.log")
local bind = require("vim-be-better.bind")
local types = require("vim-be-better.types")
<<<<<<< HEAD:lua/vim-be-good/menu.lua
=======
local log = require("vim-be-good.log")
local bind = require("vim-be-good.bind")
local types = require("vim-be-good.types")
local createEmpty = require("vim-be-good.game-utils").createEmpty
>>>>>>> parent of 294a694 (renamed plugin to `vim-be-better`):lua/vim-be-good/menu.lua
=======
local createEmpty = require("vim-be-better.game-utils").createEmpty
>>>>>>> parent of 06b7f84 (new types and categories):lua/vim-be-better/menu.lua

local Menu = {}

local gameHeader = {
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
<<<<<<< HEAD:lua/vim-be-good/menu.lua
<<<<<<< HEAD:lua/vim-be-better/menu.lua
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
=======
    "VimBeGood is a collection of small games for neovim which are",
=======
    "VimBebetter is a collection of small games for neovim which are",
>>>>>>> parent of 06b7f84 (new types and categories):lua/vim-be-better/menu.lua
    "intended to help you improve your vim proficiency.",
    "delete a line to select the line.  If you delete a difficulty,",
    "it will select that difficulty, but if you delete a game it ",
    "will start the game."
<<<<<<< HEAD:lua/vim-be-good/menu.lua
>>>>>>> parent of 294a694 (renamed plugin to `vim-be-better`):lua/vim-be-good/menu.lua
=======
>>>>>>> parent of 06b7f84 (new types and categories):lua/vim-be-better/menu.lua
}

local credits = {
    "",
    "",
    "Created by ThePrimeagen",
    "Brandoncc",
    "polarmutex",
    "",
<<<<<<< HEAD:lua/vim-be-good/menu.lua
<<<<<<< HEAD:lua/vim-be-better/menu.lua
    "https://github.com/your-username/vim-be-better",
=======
    "https://github.com/ThePrimeagen/vim-be-good",
    "https://twitch.tv/ThePrimeagen",
>>>>>>> parent of 294a694 (renamed plugin to `vim-be-better`):lua/vim-be-good/menu.lua
=======
    "https://github.com/ThePrimeagen/vim-be-better",
    "https://twitch.tv/ThePrimeagen",
>>>>>>> parent of 06b7f84 (new types and categories):lua/vim-be-better/menu.lua
}

function Menu:new(window, onResults)
    local menuObj = {
        window = window,
        buffer = window.buffer,
        onResults = onResults,

        -- easy
        difficulty = types.difficulty[2],

        -- relative
        game = types.games[1],
    }

    window.buffer:clear()
    window.buffer:setInstructions(instructions)

    self.__index = self
    local createdMenu = setmetatable(menuObj, self)

    createdMenu._onChange = bind(createdMenu, "onChange")
    window.buffer:onChange(createdMenu._onChange)

    return createdMenu
end

local function getMenuLength()
    return #types.games + #types.difficulty + #gameHeader +
        #difficultyHeader + #credits
end

local function getTableChanges(lines, compareSet, startIdx)
    local maxCount = #lines
    local idx = startIdx
    local i = 1
    local found = false

    while found == false and idx <= maxCount and i <= #compareSet do
        if lines[idx] == nil or lines[idx]:find(compareSet[i], 1, true) == nil then
            found = true
        else
            i = i + 1
            idx = idx + 1
        end
    end

    return found, i, idx
end

function Menu:onChange()
    local lines = self.window.buffer:getGameLines()
    local maxCount = getMenuLength()

    if #lines == maxCount then
        return
    end

    local found, i, idx = getTableChanges(lines, gameHeader, 1)
    log.info("Menu:onChange initial instructions", found, i, idx)
    if found then
        self:render()
        return
    end

    found, i, idx = getTableChanges(lines, types.games, idx)
    log.info("Menu:onChange game changes", found, i, idx)
    if found then
        self.game = types.games[i]

        log.info("Starting Game", self.game, self.difficulty)
        ok, msg = pcall(self.onResults, self.game, self.difficulty)

        if not ok then
            log.info("Menu:onChange error", msg)
        end
        return
    end

    found, i, idx = getTableChanges(lines, difficultyHeader, idx)
    if found then
        self:render()
        return
    end

    found, i, idx = getTableChanges(lines, types.difficulty, idx)
    if found then
        self.difficulty = types.difficulty[i]
        self:render()
        return
    end
end

local function createMenuItem(str, currentValue)
    if currentValue == str then
        return "[x] " .. str
    end
    return "[ ] " .. str
end

function Menu:render()
    self.window.buffer:clearGameLines()

    local lines = { }
    for idx = 1, #gameHeader do
        table.insert(lines, gameHeader[idx])
    end

    for idx = 1, #types.games do
        table.insert(lines, createMenuItem(types.games[idx], self.game))
    end

    for idx = 1, #difficultyHeader do
        table.insert(lines, difficultyHeader[idx])
    end

    for idx = 1, #types.difficulty do
        table.insert(lines, createMenuItem(types.difficulty[idx], self.difficulty))
    end

    for idx = 1, #credits do
        table.insert(lines, credits[idx])
    end

    self.window.buffer:render(lines)
end

function Menu:close()
    self.buffer:removeListener(self._onChange)
end

return Menu

