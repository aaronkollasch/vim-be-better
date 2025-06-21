local GameUtils = require("vim-be-better.game-utils")

local instructions = {
    "--- Global Replace Master ---",
    "",
    "Master vim global commands for structural file operations!",
    "Use :g and :v for complex file manipulations.",
    "",
    "  :g/pattern/d        - delete lines matching pattern",
    "  :g/pattern/m$       - move matching lines to end",
    "  :g/word/m0          - move matching lines to top",
    "  :v/pattern/d        - delete lines NOT matching",
    "  :g/OLD/s//NEW/g     - global replace within matches",
    "",
    "Goal: Use global commands to restructure the file.",
}

local difficultyConfig = {
    noob = {
        challenges = {
            {
                name = "Remove blank lines",
                startText = {
                    "function test()",
                    "",
                    "    print('hello')",
                    "",
                    "    return true",
                    "",
                    "end"
                },
                expectedResult = {
                    "function test()",
                    "    print('hello')",
                    "    return true",
                    "end"
                },
                cursorPos = { line = 1, col = 1 },
                operation = ":g/^$/d",
                hint = "Use :g/^$/d to delete all empty lines"
            },
            {
                name = "Delete comment lines",
                startText = {
                    "function calculate()",
                    "    -- this is a comment",
                    "    local result = 42",
                    "    -- another comment",
                    "    return result",
                    "end"
                },
                expectedResult = {
                    "function calculate()",
                    "    local result = 42",
                    "    return result",
                    "end"
                },
                cursorPos = { line = 1, col = 1 },
                operation = ":g/--/d",
                hint = "Use :g/--/d to delete all comment lines"
            }
        }
    },

    easy = {
        challenges = {
            {
                name = "Remove debug statements",
                startText = {
                    "function calculate(x, y)",
                    "    print('DEBUG: starting')",
                    "    local result = x + y",
                    "    print('DEBUG: result is', result)",
                    "    return result",
                    "end"
                },
                expectedResult = {
                    "function calculate(x, y)",
                    "    local result = x + y",
                    "    return result",
                    "end"
                },
                cursorPos = { line = 1, col = 1 },
                operation = ":g/DEBUG/d",
                hint = "Use :g with 'DEBUG' pattern to remove all debug print statements"
            },
            {
                name = "Clean up empty lines",
                startText = {
                    "local config = {",
                    "",
                    "    host = 'localhost',",
                    "",
                    "",
                    "    port = 3000,",
                    "",
                    "    debug = true",
                    "",
                    "}"
                },
                expectedResult = {
                    "local config = {",
                    "    host = 'localhost',",
                    "    port = 3000,",
                    "    debug = true",
                    "}"
                },
                cursorPos = { line = 1, col = 1 },
                operation = ":g/^$/d",
                hint = "Use :g/^$/d to remove all empty lines from the config"
            },
            {
                name = "Replace TODO with DONE",
                startText = {
                    "function processData()",
                    "    -- TODO: validate input",
                    "    local cleaned = clean(data)",
                    "    -- TODO: add logging",
                    "    return transform(cleaned)",
                    "    -- TODO: error handling",
                    "end"
                },
                expectedResult = {
                    "function processData()",
                    "    -- DONE: validate input",
                    "    local cleaned = clean(data)",
                    "    -- DONE: add logging",
                    "    return transform(cleaned)",
                    "    -- DONE: error handling",
                    "end"
                },
                cursorPos = { line = 1, col = 1 },
                operation = ":g/TODO/s/TODO/DONE/g",
                hint = "Use :g with task marker pattern to replace all occurrences with DONE"
            }
        }
    },

    medium = {
        challenges = {
            {
                name = "Organize code structure",
                startText = {
                    "local function process()",
                    "    return 'processed'",
                    "end",
                    "",
                    "local M = {}",
                    "",
                    "local function validate()",
                    "    return true",
                    "end",
                    "",
                    "M.process = process",
                    "M.validate = validate",
                    "",
                    "return M"
                },
                expectedResult = {
                    "local M = {}",
                    "",
                    "local function process()",
                    "    return 'processed'",
                    "end",
                    "",
                    "local function validate()",
                    "    return true",
                    "end",
                    "",
                    "M.process = process",
                    "M.validate = validate",
                    "",
                    "return M"
                },
                cursorPos = { line = 1, col = 1 },
                operation = ":g/^local M/m0",
                hint = "Move module definition to beginning using :g with 'local M' pattern"
            },
            {
                name = "Clean up task comments",
                startText = {
                    "function getData()",
                    "    -- TODO: add error handling",
                    "    local data = fetch()",
                    "    -- TODO: validate data",
                    "    return data",
                    "end",
                    "",
                    "-- DONE: implemented basic logic",
                    "function processData(data)",
                    "    return transform(data)",
                    "end"
                },
                expectedResult = {
                    "function getData()",
                    "    local data = fetch()",
                    "    return data",
                    "end",
                    "",
                    "-- DONE: implemented basic logic",
                    "function processData(data)",
                    "    return transform(data)",
                    "end"
                },
                cursorPos = { line = 1, col = 1 },
                operation = ":g/TODO/d",
                hint = "Use :g with task marker pattern to remove pending task comments"
            }
        }
    },

    hard = {
        challenges = {
            {
                name = "Advanced pattern operations",
                startText = {
                    "local config = {",
                    "    debug = true,     -- TODO: remove in production",
                    "    host = 'localhost',",
                    "    port = 3000,      -- TODO: make configurable",
                    "    ssl = false       -- TODO: enable in production",
                    "}"
                },
                expectedResult = {
                    "local config = {",
                    "    debug = true,     -- FIXME: remove in production",
                    "    host = 'localhost',",
                    "    port = 3000,      -- FIXME: make configurable",
                    "    ssl = false       -- FIXME: enable in production",
                    "}"
                },
                cursorPos = { line = 1, col = 1 },
                operation = ":g/TODO/s/TODO/FIXME/g",
                hint = "Use :g with task pattern, then substitute to change markers to FIXME"
            },
            {
                name = "Move specific debug lines",
                startText = {
                    "function process(data)",
                    "    print('DEBUG: processing')",
                    "    local result = transform(data)",
                    "    print('DEBUG: transformed')",
                    "    return result",
                    "end",
                    "",
                    "-- Debug output here:",
                    "",
                    "function main()",
                    "    return process(input)",
                    "end"
                },
                expectedResult = {
                    "function process(data)",
                    "    local result = transform(data)",
                    "    return result",
                    "end",
                    "",
                    "-- Debug output here:",
                    "    print('DEBUG: processing')",
                    "    print('DEBUG: transformed')",
                    "",
                    "function main()",
                    "    return process(input)",
                    "end"
                },
                cursorPos = { line = 1, col = 1 },
                operation = ":g/DEBUG/m8",
                hint = "Move debug print statements to specific location using line number target"
            }
        }
    },

    nightmare = {
        challenges = {
            {
                name = "Complex file organization",
                startText = {
                    "#!/usr/bin/env lua",
                    "",
                    "function main() startServer() end",
                    "",
                    "-- Dependencies",
                    "local http = require('http')",
                    "local json = require('json')",
                    "",
                    "function startServer() print('started') end",
                    "",
                    "-- Configuration",
                    "local config = { port = 8080 }",
                    "",
                    "main()",
                    "",
                    "-- Utilities",
                    "local utils = require('utils')"
                },
                expectedResult = {
                    "#!/usr/bin/env lua",
                    "",
                    "-- Dependencies",
                    "local http = require('http')",
                    "local json = require('json')",
                    "local utils = require('utils')",
                    "",
                    "-- Configuration",
                    "local config = { port = 8080 }",
                    "",
                    "function main() startServer() end",
                    "",
                    "function startServer() print('started') end",
                    "",
                    "main()"
                },
                cursorPos = { line = 1, col = 1 },
                operation = "Multiple :g commands for reorganization",
                hint = "Use sequence of :g operations: first dependency lines, then config, then functions"
            }
        }
    },

    tpope = {
        challenges = {
            {
                name = "Master level global operations",
                startText = {
                    "-- File: complex_module.lua",
                    "local M = {}",
                    "",
                    "function M.method1() end  -- TODO: implement",
                    "local helper1 = function() end",
                    "function M.method2() end  -- DONE",
                    "local helper2 = function() end  -- TODO: refactor",
                    "function M.method3() end",
                    "local helper3 = function() end  -- DONE",
                    "",
                    "-- Exports",
                    "return M"
                },
                expectedResult = {
                    "-- File: complex_module.lua",
                    "local M = {}",
                    "",
                    "local helper1 = function() end",
                    "local helper2 = function() end  -- FIXME: refactor",
                    "local helper3 = function() end  -- DONE",
                    "",
                    "function M.method1() end  -- FIXME: implement",
                    "function M.method2() end  -- DONE",
                    "function M.method3() end",
                    "",
                    "-- Exports",
                    "return M"
                },
                cursorPos = { line = 1, col = 1 },
                operation = "Advanced multi-step global restructuring",
                hint = "Complex sequence: move helpers up, group methods, update task markers"
            }
        }
    }
}
local GlobalReplaceRound = {}

function GlobalReplaceRound:new(difficulty, window)
    local round = {
        window = window,
        difficulty = difficulty or "easy",
        currentChallenge = nil,
        challengeIndex = 1,
        endRoundCallback = nil
    }

    self.__index = self
    return setmetatable(round, self)
end

function GlobalReplaceRound:getInstructions()
    return instructions
end

function GlobalReplaceRound:getConfig()
    vim.schedule(function()
        if self.window and self.window.bufh then
            vim.bo[self.window.bufh].modifiable = true
        end
    end)

    self:generateChallenge()

    return {
        roundTime = GameUtils.difficultyToTime[self.difficulty] or 15000,
        canEndRound = true,
    }
end

function GlobalReplaceRound:generateChallenge()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy

    self.currentChallenge = config.challenges[math.random(#config.challenges)]
end

function GlobalReplaceRound:checkForWin()
    if not self.currentChallenge then
        return false
    end

    local all_lines = vim.api.nvim_buf_get_lines(self.window.buffer.bufh, 0, -1, false)
    local actual_text = {}

    local start_line = nil
    for i, line in ipairs(all_lines) do
        if line:match("^Hint:") then
            start_line = i + 2
            break
        end
    end

    if start_line then
        for i = 1, #self.currentChallenge.expectedResult do
            actual_text[i] = all_lines[start_line + i - 1] or ""
        end
    end

    local matches = true
    if #actual_text == #self.currentChallenge.expectedResult then
        for i = 1, #self.currentChallenge.expectedResult do
            if actual_text[i] ~= self.currentChallenge.expectedResult[i] then
                matches = false
                break
            end
        end
    else
        matches = false
    end

    if matches then
        if self.endRoundCallback then
            vim.defer_fn(function()
                self.endRoundCallback(true)
            end, 100)
        end
        return true
    end

    return false
end

function GlobalReplaceRound:render()
    if not self.currentChallenge then
        return {}, 1, 0
    end

    local lines = {}

    table.insert(lines, "Challenge: " .. self.currentChallenge.name)
    table.insert(lines, "Operation: " .. self.currentChallenge.operation)
    table.insert(lines, "Hint: " .. self.currentChallenge.hint)
    table.insert(lines, "")

    for _, line in ipairs(self.currentChallenge.startText) do
        table.insert(lines, line)
    end

    local cursorLine = 5 + (self.currentChallenge.cursorPos.line or 1)
    local cursorCol = (self.currentChallenge.cursorPos.col or 1) - 1

    return lines, cursorLine, cursorCol
end

function GlobalReplaceRound:name()
    return "global-replace"
end

function GlobalReplaceRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
end

return GlobalReplaceRound
