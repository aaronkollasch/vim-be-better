local GameUtils = require("vim-be-better.game-utils")

local instructions = {
    "--- Speed Editing ---",
    "",
    "Execute vim operations as fast as possible!",
    "Build muscle memory through speed challenges.",
    "",
    "  🥇 Gold:    ≤ target time (excellent!)",
    "  🥈 Silver:  110-130% target (good!)",
    "  🥉 Bronze:  130-150% target (okay)",
    "  ⏱️  Slow:    > 150% target (practice more)",
    "",
    "Goal: Complete the transformation as quickly as possible.",
}

local timeTargets = {
    noob = { base = 8, multiplier = 1.0 },      -- 8s base, easier targets
    easy = { base = 6, multiplier = 1.2 },      -- 7.2s base
    medium = { base = 5, multiplier = 1.5 },    -- 7.5s base
    hard = { base = 4, multiplier = 2.0 },      -- 8s base but more complex
    nightmare = { base = 3, multiplier = 2.5 }, -- 7.5s base, very complex
    tpope = { base = 2, multiplier = 3.0 }      -- 6s base, ultimate challenge
}

local difficultyConfig = {
    noob = {
        challenges = {
            {
                name = "Add semicolons",
                startText = {
                    "let x = 1",
                    "let y = 2",
                    "let z = 3"
                },
                expectedResult = {
                    "let x = 1;",
                    "let y = 2;",
                    "let z = 3;"
                },
                cursorPos = { line = 1, col = 1 },
                timeMultiplier = 1.0, -- 8 seconds
                description = "Add semicolons to 3 lines",
                hint = "Use A; and repeat for each line"
            },
            {
                name = "Delete word",
                startText = {
                    "hello world test",
                    "keep this line"
                },
                expectedResult = {
                    "hello test",
                    "keep this line"
                },
                cursorPos = { line = 1, col = 7 },
                timeMultiplier = 0.6, -- 4.8 seconds
                description = "Delete the word 'world'",
                hint = "Use dw to delete word"
            },
            {
                name = "Duplicate lines",
                startText = {
                    "console.log('debug');"
                },
                expectedResult = {
                    "console.log('debug');",
                    "console.log('debug');"
                },
                cursorPos = { line = 1, col = 1 },
                timeMultiplier = 0.5, -- 4 seconds
                description = "Duplicate the debug line",
                hint = "Use yyp to copy and paste"
            }
        }
    },

    easy = {
        challenges = {
            {
                name = "Add quotes to words",
                startText = {
                    "name: John",
                    "city: NYC",
                    "role: Dev",
                    "team: Frontend"
                },
                expectedResult = {
                    "name: 'John'",
                    "city: 'NYC'",
                    "role: 'Dev'",
                    "team: 'Frontend'"
                },
                cursorPos = { line = 1, col = 7 },
                timeMultiplier = 1.5, -- 10.8 seconds
                description = "Add quotes around 4 values",
                hint = "Navigate to each word and surround with quotes"
            },
            {
                name = "Remove debug statements",
                startText = {
                    "function test() {",
                    "    console.log('debug');",
                    "    let x = 1;",
                    "    console.log('debug');",
                    "    return x;",
                    "    console.log('debug');",
                    "}"
                },
                expectedResult = {
                    "function test() {",
                    "    let x = 1;",
                    "    return x;",
                    "}"
                },
                cursorPos = { line = 1, col = 1 },
                timeMultiplier = 1.2, -- 8.6 seconds
                description = "Remove 3 debug lines quickly",
                hint = "Find and delete console.log lines efficiently"
            },
            {
                name = "Change var to let",
                startText = {
                    "var userName = '';",
                    "var userAge = 0;",
                    "var userCity = '';",
                    "var userEmail = '';"
                },
                expectedResult = {
                    "let userName = '';",
                    "let userAge = 0;",
                    "let userCity = '';",
                    "let userEmail = '';"
                },
                cursorPos = { line = 1, col = 1 },
                timeMultiplier = 1.0, -- 7.2 seconds
                description = "Replace 'var' with 'let' in 4 lines",
                hint = "Use efficient word replacement"
            }
        }
    },

    medium = {
        challenges = {
            {
                name = "Camel to snake case",
                startText = {
                    "const userName = 'john';",
                    "const userAge = 25;",
                    "const userEmail = 'john@example.com';",
                    "const isActive = true;",
                    "const hasPermission = false;"
                },
                expectedResult = {
                    "const user_name = 'john';",
                    "const user_age = 25;",
                    "const user_email = 'john@example.com';",
                    "const is_active = true;",
                    "const has_permission = false;"
                },
                cursorPos = { line = 1, col = 7 },
                timeMultiplier = 2.0, -- 15 seconds
                description = "Convert 5 variables to snake_case",
                hint = "Navigate and modify variable names efficiently"
            },
            {
                name = "Reorganize imports",
                startText = {
                    "import { useState } from 'react';",
                    "const config = require('./config');",
                    "import React from 'react';",
                    "const utils = require('./utils');",
                    "import { useEffect } from 'react';"
                },
                expectedResult = {
                    "import React from 'react';",
                    "import { useState } from 'react';",
                    "import { useEffect } from 'react';",
                    "const config = require('./config');",
                    "const utils = require('./utils');"
                },
                cursorPos = { line = 1, col = 1 },
                timeMultiplier = 1.8, -- 13.5 seconds
                description = "Group imports and requires together",
                hint = "Move lines to organize import statements"
            },
            {
                name = "Format object properties",
                startText = {
                    "const obj={name:'John',age:25,city:'NYC'};"
                },
                expectedResult = {
                    "const obj = {",
                    "  name: 'John',",
                    "  age: 25,",
                    "  city: 'NYC'",
                    "};"
                },
                cursorPos = { line = 1, col = 12 },
                timeMultiplier = 1.5, -- 11.25 seconds
                description = "Format compressed object to multi-line",
                hint = "Add spacing and line breaks systematically"
            }
        }
    },

    hard = {
        challenges = {
            {
                name = "Convert to arrow functions",
                startText = {
                    "function getName() { return 'John'; }",
                    "function getAge() { return 25; }",
                    "function getCity() { return 'NYC'; }"
                },
                expectedResult = {
                    "const getName = () => { return 'John'; }",
                    "const getAge = () => { return 25; }",
                    "const getCity = () => { return 'NYC'; }"
                },
                cursorPos = { line = 1, col = 1 },
                timeMultiplier = 2.5, -- 20 seconds
                description = "Convert 3 functions to arrow syntax",
                hint = "Transform function declarations efficiently"
            },
            {
                name = "Extract method parameters",
                startText = {
                    "processUser(user.name, user.age, user.email, user.city);",
                    "validateUser(user.name, user.age, user.email, user.city);",
                    "saveUser(user.name, user.age, user.email, user.city);"
                },
                expectedResult = {
                    "const { name, age, email, city } = user;",
                    "processUser(name, age, email, city);",
                    "validateUser(name, age, email, city);",
                    "saveUser(name, age, email, city);"
                },
                cursorPos = { line = 1, col = 1 },
                timeMultiplier = 2.8, -- 22.4 seconds
                description = "Extract destructuring and update calls",
                hint = "Add destructuring line and simplify parameters"
            }
        }
    },

    nightmare = {
        challenges = {
            {
                name = "Complex refactoring",
                startText = {
                    "if (user && user.profile && user.profile.settings && user.profile.settings.theme) {",
                    "  applyTheme(user.profile.settings.theme);",
                    "} else {",
                    "  applyTheme('default');",
                    "}"
                },
                expectedResult = {
                    "const theme = user?.profile?.settings?.theme || 'default';",
                    "applyTheme(theme);"
                },
                cursorPos = { line = 1, col = 1 },
                timeMultiplier = 3.0, -- 22.5 seconds
                description = "Simplify nested conditional to optional chaining",
                hint = "Use optional chaining and ternary operator"
            }
        }
    },

    tpope = {
        challenges = {
            {
                name = "Ultimate speed challenge",
                startText = {
                    "function processData(data) {",
                    "  if (data) {",
                    "    if (data.length > 0) {",
                    "      return data.map(function(item) {",
                    "        return item.value * 2;",
                    "      });",
                    "    }",
                    "  }",
                    "  return [];",
                    "}"
                },
                expectedResult = {
                    "const processData = (data) => data?.length ? data.map(item => item.value * 2) : [];"
                },
                cursorPos = { line = 1, col = 1 },
                timeMultiplier = 4.0, -- 24 seconds
                description = "Ultimate one-liner transformation",
                hint = "Convert to modern arrow function with optional chaining"
            }
        }
    }
}

local SpeedEditingRound = {}

function SpeedEditingRound:new(difficulty, window)
    local round = {
        window = window,
        difficulty = difficulty or "easy",
        currentChallenge = nil,
        startTime = nil,
        endTime = nil,
        targetTime = nil,
        endRoundCallback = nil,
        hasWon = false,
        timerRunning = false
    }

    self.__index = self
    return setmetatable(round, self)
end

function SpeedEditingRound:getInstructions()
    return instructions
end

function SpeedEditingRound:getConfig()
    vim.schedule(function()
        if self.window and self.window.bufh then
            vim.api.nvim_buf_set_option(self.window.bufh, 'modifiable', true)
        end
    end)

    self:generateChallenge()
    self.hasWon = false
    self.timerRunning = false

    return {
        roundTime = GameUtils.difficultyToTime[self.difficulty] or 60000,
        canEndRound = true,
    }
end

function SpeedEditingRound:generateChallenge()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy
    local timeConfig = timeTargets[difficultyKey] or timeTargets.easy

    self.currentChallenge = vim.deepcopy(config.challenges[math.random(#config.challenges)])

    local baseTime = timeConfig.base
    local multiplier = timeConfig.multiplier * (self.currentChallenge.timeMultiplier or 1.0)
    self.targetTime = baseTime * multiplier
end

function SpeedEditingRound:startTimer()
    if not self.timerRunning then
        self.startTime = vim.fn.reltimefloat(vim.fn.reltime())
        self.timerRunning = true
    end
end

function SpeedEditingRound:getCurrentTime()
    if not self.startTime then return 0 end
    return vim.fn.reltimefloat(vim.fn.reltime()) - self.startTime
end

function SpeedEditingRound:getTimeStatus(currentTime)
    if not self.targetTime then return "⏱️" end

    local percentage = (currentTime / self.targetTime) * 100

    if percentage <= 100 then
        return "🥇 Gold"
    elseif percentage <= 130 then
        return "🥈 Silver"
    elseif percentage <= 150 then
        return "🥉 Bronze"
    else
        return "⏱️ Slow"
    end
end

function SpeedEditingRound:setupChangeMonitoring()
    local augroup_name = "SpeedEditingCheck_" .. vim.fn.localtime()
    self.changeAugroup = augroup_name

    vim.api.nvim_create_augroup(augroup_name, { clear = true })

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        group = augroup_name,
        buffer = self.window.buffer.bufh,
        callback = function()
            self:startTimer()
            if not self.hasWon then
                self:checkForWin()
            end
        end
    })
end

function SpeedEditingRound:checkForWin()
    if not self.currentChallenge or self.hasWon then
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
        self.hasWon = true
        self.endTime = self:getCurrentTime()

        if self.endRoundCallback then
            vim.defer_fn(function()
                self.endRoundCallback(true)
            end, 100)
        end
        return true
    end

    return false
end

function SpeedEditingRound:render()
    if not self.currentChallenge then
        return {}, 1, 0
    end

    local lines = {}

    table.insert(lines, "Challenge: " .. self.currentChallenge.name)
    table.insert(lines, "Description: " .. self.currentChallenge.description)
    table.insert(lines, "Target: < " .. string.format("%.1f", self.targetTime) .. " seconds")

    if self.timerRunning and not self.hasWon then
        local currentTime = self:getCurrentTime()
        local status = self:getTimeStatus(currentTime)
        table.insert(lines, "Time: " .. string.format("%.1f", currentTime) .. "s (" .. status .. ")")
    elseif self.hasWon then
        local status = self:getTimeStatus(self.endTime)
        table.insert(lines, "Finished: " .. string.format("%.1f", self.endTime) .. "s (" .. status .. ")")
    else
        table.insert(lines, "Time: Ready to start!")
    end

    if self.difficulty == "noob" or self.difficulty == "easy" then
        table.insert(lines, "Hint: " .. self.currentChallenge.hint)
    end

    table.insert(lines, "")

    for _, line in ipairs(self.currentChallenge.startText) do
        table.insert(lines, line)
    end

    local cursorLine = #lines - #self.currentChallenge.startText + (self.currentChallenge.cursorPos.line or 1)
    local cursorCol = (self.currentChallenge.cursorPos.col or 1) - 1

    vim.defer_fn(function()
        self:setupChangeMonitoring()
    end, 100)

    return lines, cursorLine, cursorCol
end

function SpeedEditingRound:cleanup()
    if self.changeAugroup then
        pcall(vim.api.nvim_del_augroup_by_name, self.changeAugroup)
        self.changeAugroup = nil
    end
end

function SpeedEditingRound:name()
    return "speed-editing"
end

function SpeedEditingRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
end

return SpeedEditingRound
