local instructions = {
    "This is a placeholder game.",
    "This game is coming soon!",
    "Press any key to return to menu.",
    "",
}

local PlaceholderGame = {}

function PlaceholderGame:new(difficulty, window, gameName)
    local round = {
        window = window,
        difficulty = difficulty,
        gameName = gameName or "Unknown Game",
    }

    self.__index = self
    return setmetatable(round, self)
end

function PlaceholderGame:getInstructions()
    local gameInstructions = vim.deepcopy(instructions)
    gameInstructions[1] = "Game: " .. self.gameName
    return gameInstructions
end

function PlaceholderGame:getConfig()
    return {
        roundTime = 5000,
        canEndRound = true,
    }
end

function PlaceholderGame:checkForWin()
    return true
end

function PlaceholderGame:render()
    local lines = {
        "",
        "🚧 PLACEHOLDER GAME 🚧",
        "",
        "Game: " .. self.gameName,
        "Difficulty: " .. self.difficulty,
        "",
        "This game will be implemented soon!",
        "",
        "This placeholder will automatically end",
        "and return you to the menu.",
        "",
    }

    return lines, 5
end

function PlaceholderGame:name()
    return self.gameName
end

function PlaceholderGame:setEndRoundCallback(endRoundCallback)
    self.endRoundCallback = endRoundCallback

    vim.defer_fn(function()
        if self.endRoundCallback then
            self.endRoundCallback("menu")
        end
    end, 3000)
end

return PlaceholderGame
