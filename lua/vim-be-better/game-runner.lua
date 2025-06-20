local GameUtils = require("vim-be-better.game-utils");
local RelativeRound = require("vim-be-better.games.legacy.relative");
local WordRound = require("vim-be-better.games.legacy.words");
local CiRound = require("vim-be-better.games.legacy.ci");
local HjklRound = require("vim-be-better.games.legacy.hjkl");
local WhackAMoleRound = require("vim-be-better.games.legacy.whackamole");
local Snake = require("vim-be-better.games.legacy.snake");
local PlaceholderGame = require("vim-be-better.games.placeholder");

local FindCharRound = require("vim-be-better.games.navigation.find-char");
local WordBoundariesRound = require("vim-be-better.games.navigation.word-boundaries")
local BracketJumpRound = require("vim-be-better.games.navigation.bracket-jump")
local VisualPrecisionRound = require("vim-be-better.games.navigation.visual-precision")

local TextObjectsBasicRound = require("vim-be-better.games.text-objects.text-objects-basic")
local BlockEditRound = require("vim-be-better.games.text-objects.block-edit")

local SubstituteBasicRound = require("vim-be-better.games.substitution.substitute-basic")
local RegexMasterRound = require("vim-be-better.games.substitution.regex-master")
local GlobalReplaceRound = require("vim-be-better.games.substitution.global-replace")

local IndentMasterRound = require("vim-be-better.games.formatting.indent-master")
local CaseConverterRound = require("vim-be-better.games.formatting.case-converter")
local JoinLinesRound = require("vim-be-better.games.formatting.join-lines")

local IncrementGameRound = require("vim-be-better.games.numbers.increment-game")
local NumberSequenceRound = require("vim-be-better.games.numbers.number-sequence")

local MacroRecorderRound = require("vim-be-better.games.advanced.macro-recorder")
local DotRepeatRound = require("vim-be-better.games.advanced.dot-repeat")
local FoldMasterRound = require("vim-be-better.games.advanced.fold-master")
local CommentToggleRound = require("vim-be-better.games.advanced.comment-toggle")

local SpeedEditingRound = require("vim-be-better.games.mixed.speed-editing")
local RefactorRaceRound = require("vim-be-better.games.mixed.refactor-race")
local VimGolfRound = require("vim-be-better.games.mixed.vim-golf")

local log = require("vim-be-better.log");
local statistics = require("vim-be-better.statistics");

Stats = statistics:new()

local endStates = {
    menu = "Menu",
    replay = "Replay",
    quit = "Quit (or just ZZ like a real man)",
}

local states = {
    playing = 1,
    gameEnd = 2,
}

local classicGames = {
    ["ci{"] = function(difficulty, window)
        return CiRound:new(difficulty, window)
    end,

    relative = function(difficulty, window)
        return RelativeRound:new(difficulty, window)
    end,

    words = function(difficulty, window)
        return WordRound:new(difficulty, window)
    end,

    hjkl = function(difficulty, window)
        return HjklRound:new(difficulty, window)
    end,

    whackamole = function(difficulty, window)
        return WhackAMoleRound:new(difficulty, window)
    end,

    snake = function(difficulty, window)
        return Snake:new(difficulty, window)
    end,
}

local newGames = {
    -- Navigation
    ["find-char"] = function(difficulty, window)
        return FindCharRound:new(difficulty, window)
    end,
    ["word-boundaries"] = function(difficulty, window)
        return WordBoundariesRound:new(difficulty, window)
    end,
    ["bracket-jump"] = function(difficulty, window)
        return BracketJumpRound:new(difficulty, window)
    end,
    ["visual-precision"] = function(difficulty, window)
        return VisualPrecisionRound:new(difficulty, window)
    end,

    -- Text Objects
    ["text-objects-basic"] = function(difficulty, window)
        return TextObjectsBasicRound:new(difficulty, window)
    end,
    ["block-edit"] = function(difficulty, window)
        return BlockEditRound:new(difficulty, window)
    end,

    -- Substitution
    ["substitute-basic"] = function(difficulty, window)
        return SubstituteBasicRound:new(difficulty, window)
    end,
    ["regex-master"] = function(difficulty, window)
        return RegexMasterRound:new(difficulty, window)
    end,
    ["global-replace"] = function(difficulty, window)
        return GlobalReplaceRound:new(difficulty, window)
    end,

    -- Formatting
    ["indent-master"] = function(difficulty, window)
        return IndentMasterRound:new(difficulty, window)
    end,
    ["case-converter"] = function(difficulty, window)
        return CaseConverterRound:new(difficulty, window)
    end,
    ["join-lines"] = function(difficulty, window)
        return JoinLinesRound:new(difficulty, window)
    end,

    -- Numbers & Operations
    ["increment-game"] = function(difficulty, window)
        return IncrementGameRound:new(difficulty, window)
    end,
    ["number-sequence"] = function(difficulty, window)
        return NumberSequenceRound:new(difficulty, window)
    end,

    -- Advanced Features
    ["macro-recorder"] = function(difficulty, window)
        return MacroRecorderRound:new(difficulty, window)
    end,
    ["dot-repeat"] = function(difficulty, window)
        return DotRepeatRound:new(difficulty, window)
    end,
    ["fold-master"] = function(difficulty, window)
        return FoldMasterRound:new(difficulty, window)
    end,
    ["comment-toggle"] = function(difficulty, window)
        return CommentToggleRound:new(difficulty, window)
    end,

    -- Mixed Challenges
    ["vim-golf"] = function(difficulty, window)
        return VimGolfRound:new(difficulty, window)
    end,
    ["speed-editing"] = function(difficulty, window)
        return SpeedEditingRound:new(difficulty, window)
    end,
    ["refactor-race"] = function(difficulty, window)
        return RefactorRaceRound:new(difficulty, window)
    end,
}

local games = vim.tbl_extend("force", classicGames, newGames)

local runningId = 0

local GameRunner = {}

local function getGame(game, difficulty, window)
    if game == "find-char" then
        package.loaded["vim-be-better.games.navigation.find-char"] = nil
        FindCharRound = require("vim-be-better.games.navigation.find-char")
        log.info("getGame - Force reloaded find-char module")
    end

    if not games[game] then
        log.warn("Game not found, using placeholder:", game)
        return PlaceholderGame:new(difficulty, window, game)
    end

    return games[game](difficulty, window)
end

function GameRunner:new(selectedGames, difficulty, window, onFinished)
    local config = {
        difficulty = difficulty,
        roundCount = GameUtils.getRoundCount(difficulty),
    }

    local rounds = {}

    if selectedGames[1] == "random" then
        selectedGames = {}
        for name, _ in pairs(classicGames) do
            table.insert(selectedGames, name)
        end
    end

    for idx = 1, #selectedGames do
        table.insert(rounds, getGame(selectedGames[idx], difficulty, window))
    end

    local gameRunner = {
        currentRound = 1,
        rounds = rounds,
        config = config,
        window = window,
        onFinished = onFinished,
        results = {
            successes = 0,
            failures = 0,
            timings = {},
            games = {},
        },
        state = states.playing
    }

    self.__index = self
    local game = setmetatable(gameRunner, self)

    local function onChange()
        if hasEverythingEnded then
            if not game.ended then
                game:close()
            end
            return
        end

        if game.state == states.playing then
            game:checkForWin()
        else
            game:checkForNext()
        end
    end

    game.onChange = onChange
    window.buffer:onChange(onChange)
    return game
end

function GameRunner:countdown(count, cb)
    local self = self
    local ok, msg = pcall(function()
        if count > 0 then
            local str = string.format("Game Starts in %d", count)

            self.window.buffer:debugLine(str)
            self.window.buffer:render({})

            vim.defer_fn(function()
                self:countdown(count - 1, cb)
            end, 1000)
        else
            cb()
        end
    end)

    if not ok then
        log.info("Error: GameRunner#countdown", msg)
    end
end

function GameRunner:init()
    local self = self

    vim.schedule(function()
        self.window.buffer:setInstructions({})
        self.window.buffer:clear()
        self:countdown(3, function() self:run() end)
    end)
end

function GameRunner:checkForNext()
    local lines = self.window.buffer:getGameLines()
    local expectedLines = self:renderEndGame()
    local idx = 0
    local found = false

    repeat
        idx = idx + 1
        found = lines[idx] ~= expectedLines[idx]
    until idx == #lines or found

    if found == false then
        return
    end

    local item = expectedLines[idx]

    local foundKey = nil
    for k, v in pairs(endStates) do
        if item == v then
            foundKey = k
        end
    end

    if foundKey then
        self.onFinished(self, foundKey)
    else
        self.window.buffer:render(expectedLines)
    end
end

function GameRunner:checkForWin()
    if not self.round then
        return
    end

    if not self.running then
        return
    end

    if not self.round:checkForWin() then
        return
    end

    self:endRound(true)
end

function GameRunner:endRound(success)
    success = success or false

    self.running = false
    if success then
        self.results.successes = self.results.successes + 1
    else
        self.results.failures = self.results.failures + 1
    end

    local endTime = GameUtils.getTime()
    local totalTime = endTime - self.startTime
    table.insert(self.results.timings, totalTime)
    table.insert(self.results.games, self.round:name())

    local result = {
        timestamp = vim.fn.localtime(),
        roundNum = self.currentRound,
        difficulty = self.config.difficulty,
        roundName = self.round:name(),
        success = success,
        time = totalTime,
    }
    Stats:logResult(result)
    if self.currentRound >= self.config.roundCount then
        self:endGame()
        return
    end
    self.currentRound = self.currentRound + 1

    if not self.window:isValid() then
        return
    end

    vim.schedule_wrap(function() self:run() end)()
end

function GameRunner:close()
    self.window.buffer:removeListener(self.onChange)
    self.ended = true
end

function GameRunner:renderEndGame()
    self.window.buffer:debugLine(string.format(
        "Round %d / %d", self.currentRound, self.config.roundCount))

    local lines = {}
    local sum = 0

    for idx = 1, #self.results.timings do
        sum = sum + self.results.timings[idx]
    end

    self.ended = true

    table.insert(lines, string.format("%d / %d completed successfully", self.results.successes, self.config.roundCount))
    table.insert(lines, string.format("Average %.2f", sum / self.config.roundCount))
    table.insert(lines, string.format("Game Type %s", self.results.games[1]))

    for idx = 1, 3 do
        table.insert(lines, "")
    end

    table.insert(lines, "Where do you want to go next? (Delete Line)")
    local optionLine = #lines + 1

    table.insert(lines, "Menu")
    table.insert(lines, "Replay")
    table.insert(lines, "Quit (or just ZZ like a real man)")

    return lines, optionLine
end

function GameRunner:endGame()
    local lines = self:renderEndGame()
    self.state = states.gameEnd
    self.window.buffer:setInstructions({})
    self.window.buffer:render(lines)
end

function GameRunner:run()
    local idx = math.random(1, #self.rounds)
    self.round = self.rounds[idx]

    local roundConfig = self.round:getConfig()
    log.info("RoundName:", self.round:name())

    self.window.buffer:debugLine(string.format(
        "Round %d / %d", self.currentRound, self.config.roundCount))

    if roundConfig.canEndRound then
        self.round:setEndRoundCallback(function(success) self:endRound(success) end)
    end

    self.window.buffer:setInstructions(self.round:getInstructions())
    local lines, cursorLine, cursorCol = self.round:render()
    self.window.buffer:render(lines)

    cursorLine = cursorLine or 0
    cursorCol = cursorCol or 0

    local instructionLen = #self.round:getInstructions()
    local curRoundLineLen = 1
    cursorLine = cursorLine + curRoundLineLen + instructionLen

    log.info("Setting current line to", cursorLine, cursorCol)
    if cursorLine > 0 and not roundConfig.noCursor then
        vim.api.nvim_win_set_cursor(0, { cursorLine, cursorCol })
    end

    self.startTime = GameUtils.getTime()

    runningId = runningId + 1
    local currentId = runningId
    self.running = true

    log.info("defer_fn", roundConfig.roundTime)
    vim.defer_fn(function()
        if self.state == states.gameEnd then
            return
        end
        log.info("Deferred?", currentId, runningId)
        if currentId < runningId then
            return
        end

        self:endRound()
    end, roundConfig.roundTime)
end

return GameRunner
