local log = require("vim-be-better.log")
local bind = require("vim-be-better.bind")
local types = require("vim-be-better.types")

vim.g["vim_be_better_log_file"] = true
vim.g["vim_be_better_log_console"] = false

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
    "VimBebetter is a collection of small games for neovim which are",
    "intended to help you improve your vim proficiency.",
    "delete a line to select the line.  If you delete a difficulty,",
    "it will select that difficulty, but if you delete a game it ",
    "will start the game."
}

local credits = {
    "",
    "",
    "Created by ThePrimeagen",
    "Brandoncc",
    "polarmutex",
    "",
    "https://github.com/ThePrimeagen/vim-be-better",
    "https://twitch.tv/ThePrimeagen",
}

function Menu:new(window, onResults)
    local menuObj = {
        window = window,
        buffer = window.buffer,
        onResults = onResults,

        difficulty = types.difficulty[2],

        game = types.games[1],

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

    log.info("Menu:new - Menu utworzone pomyślnie", "difficulty:", menuObj.difficulty, "game:", menuObj.game)

    return createdMenu
end

local function getExpectedMenuLength()
    return #gameHeader + #types.games + #difficultyHeader + #types.difficulty + #credits
end

function Menu:buildLineTypeMap()
    local map = {}
    local lineIndex = 1

    for i = 1, #gameHeader do
        map[lineIndex] = { type = "game_header", index = i }
        lineIndex = lineIndex + 1
    end

    for i = 1, #types.games do
        map[lineIndex] = { type = "game", index = i, value = types.games[i] }
        lineIndex = lineIndex + 1
    end

    for i = 1, #difficultyHeader do
        map[lineIndex] = { type = "difficulty_header", index = i }
        lineIndex = lineIndex + 1
    end

    for i = 1, #types.difficulty do
        map[lineIndex] = { type = "difficulty", index = i, value = types.difficulty[i] }
        lineIndex = lineIndex + 1
    end

    for i = 1, #credits do
        map[lineIndex] = { type = "credits", index = i }
        lineIndex = lineIndex + 1
    end

    self.lineTypeMap = map
    log.info("Menu:buildLineTypeMap - Mapa typów linii utworzona", "total_lines:", lineIndex - 1)
    return map
end

function Menu:detectChanges(currentLines)
    local expectedLength = getExpectedMenuLength()
    local currentLength = #currentLines

    log.info("Menu:detectChanges - Sprawdzanie zmian",
        "expected_length:", expectedLength,
        "current_length:", currentLength,
        "last_rendered_length:", #self.lastRenderedLines)

    if currentLength ~= expectedLength then
        log.warn("Menu:detectChanges - Wykryto zmianę długości menu")
        return true, "length_mismatch"
    end

    for i, line in ipairs(currentLines) do
        local lineInfo = self.lineTypeMap[i]
        if not lineInfo then
            log.error("Menu:detectChanges - Brak informacji o linii", "line_index:", i)
            return true, "unknown_line"
        end

        local expectedLine = self:getExpectedLineContent(lineInfo)
        if line ~= expectedLine then
            log.info("Menu:detectChanges - Wykryto modyfikację linii",
                "line_index:", i,
                "type:", lineInfo.type,
                "expected:", expectedLine,
                "actual:", line)

            if lineInfo.type == "game" then
                log.info("Menu:detectChanges - Wykryto wybór gry", "game:", lineInfo.value)
                return false, "game_selected", lineInfo.value
            end

            if lineInfo.type == "difficulty" then
                log.info("Menu:detectChanges - Wykryto wybór poziomu trudności", "difficulty:", lineInfo.value)
                return false, "difficulty_selected", lineInfo.value
            end

            return true, "line_modified"
        end
    end

    return false, "no_changes"
end

function Menu:getExpectedLineContent(lineInfo)
    if lineInfo.type == "game_header" then
        return gameHeader[lineInfo.index]
    elseif lineInfo.type == "game" then
        return self:createMenuItem(lineInfo.value, self.game)
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
        log.info("Menu:onChange - Pomijanie onChange podczas re-renderowania")
        return
    end

    local currentLines = self.window.buffer:getGameLines()
    log.info("Menu:onChange - Wykryto zmianę w menu", "lines_count:", #currentLines)

    if not self.lineTypeMap or #self.lineTypeMap == 0 then
        self:buildLineTypeMap()
    end

    local hasChanges, changeType, selectedValue = self:detectChanges(currentLines)

    if changeType == "game_selected" then
        log.info("Menu:onChange - Uruchamianie gry", "game:", selectedValue, "difficulty:", self.difficulty)
        self.game = selectedValue

        local ok, msg = pcall(self.onResults, self.game, self.difficulty)
        if not ok then
            log.error("Menu:onChange - Błąd podczas uruchamiania gry", "error:", msg)
        end
        return
    elseif changeType == "difficulty_selected" then
        log.info("Menu:onChange - Zmiana poziomu trudności", "new_difficulty:", selectedValue)
        self.difficulty = selectedValue
        self:safeRerender("difficulty_change")
        return
    elseif hasChanges then
        log.warn("Menu:onChange - Wykryto niepożądane zmiany, wykonuję re-render", "change_type:", changeType)
        self:safeRerender("restore_menu")
        return
    end

    log.info("Menu:onChange - Brak zmian wymagających akcji")
end

function Menu:safeRerender(reason)
    log.info("Menu:safeRerender - Rozpoczynanie bezpiecznego re-renderowania", "reason:", reason)

    if self.isRerendering then
        log.warn("Menu:safeRerender - Re-renderowanie już w toku, pomijanie")
        return
    end

    self.isRerendering = true

    vim.schedule(function()
        log.info("Menu:safeRerender - Wykonywanie re-renderowania")

        pcall(function()
            self:render()
        end)

        vim.defer_fn(function()
            self.isRerendering = false
            log.info("Menu:safeRerender - Re-renderowanie zakończone")
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
    log.info("Menu:render - Rozpoczynanie renderowania menu")

    self.window.buffer:clearGameLines()

    local lines = {}

    for idx = 1, #gameHeader do
        table.insert(lines, gameHeader[idx])
    end

    for idx = 1, #types.games do
        table.insert(lines, self:createMenuItem(types.games[idx], self.game))
    end

    for idx = 1, #difficultyHeader do
        table.insert(lines, difficultyHeader[idx])
    end

    for idx = 1, #types.difficulty do
        table.insert(lines, self:createMenuItem(types.difficulty[idx], self.difficulty))
    end

    for idx = 1, #credits do
        table.insert(lines, credits[idx])
    end

    self.lastRenderedLines = vim.deepcopy(lines)

    self:buildLineTypeMap()

    self.window.buffer:render(lines)

    log.info("Menu:render - Renderowanie zakończone",
        "total_lines:", #lines,
        "selected_game:", self.game,
        "selected_difficulty:", self.difficulty)
end

function Menu:close()
    log.info("Menu:close - Zamykanie menu")
    if self.buffer and self._onChange then
        self.buffer:removeListener(self._onChange)
    end

    self.lineTypeMap = {}
    self.lastRenderedLines = {}
    self.isRerendering = false
end

return Menu
