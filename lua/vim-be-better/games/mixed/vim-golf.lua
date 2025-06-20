local GameUtils = require("vim-be-better.game-utils")

local instructions = {
    "--- Vim Golf ---",
    "",
    "Complete tasks with minimum keystrokes - like golf, lower score wins!",
    "Every keystroke counts toward your final score.",
    "",
    "  🏆 Hole-in-one: = optimal score (perfect!)",
    "  🥇 Eagle:       < par (excellent!)",
    "  🥈 Birdie:      = par (good!)",
    "  🥉 Par:         ≤ par + 3 (okay)",
    "  ⛳ Bogey:       > par + 3 (practice more)",
    "",
    "Goal: Complete the transformation with fewest possible keystrokes.",
}

local difficultyConfig = {
    noob = {
        challenges = {
            {
                name = "Add semicolon",
                startText = {
                    "console.log('hello')"
                },
                expectedResult = {
                    "console.log('hello');"
                },
                cursorPos = { line = 1, col = 1 },
                par = 2,
                optimal = 2,
                description = "Add semicolon at end of line",
                optimalSolution = "A;",
                hint = "Use A; to append semicolon at end of line"
            },
            {
                name = "Delete word",
                startText = {
                    "hello beautiful world"
                },
                expectedResult = {
                    "hello world"
                },
                cursorPos = { line = 1, col = 7 },
                par = 2,
                optimal = 2,
                description = "Delete the word 'beautiful'",
                optimalSolution = "dw",
                hint = "Use dw to delete word under cursor"
            },
            {
                name = "Replace character",
                startText = {
                    "vim xs awesome"
                },
                expectedResult = {
                    "vim is awesome"
                },
                cursorPos = { line = 1, col = 5 },
                par = 2,
                optimal = 2,
                description = "Replace 'x' with 'i'",
                optimalSolution = "ri",
                hint = "Use ri to replace character with 'i'"
            },
            {
                name = "Duplicate line",
                startText = {
                    "const x = 1;"
                },
                expectedResult = {
                    "const x = 1;",
                    "const x = 1;"
                },
                cursorPos = { line = 1, col = 1 },
                par = 3,
                optimal = 3,
                description = "Duplicate the line",
                optimalSolution = "yyp",
                hint = "Use yyp to yank and paste line"
            },
            {
                name = "Join lines",
                startText = {
                    "hello",
                    "world"
                },
                expectedResult = {
                    "hello world"
                },
                cursorPos = { line = 1, col = 1 },
                par = 1,
                optimal = 1,
                description = "Join two lines",
                optimalSolution = "J",
                hint = "Use J to join lines"
            }
        }
    },

    easy = {
        challenges = {
            {
                name = "Change word",
                startText = {
                    "function old() {"
                },
                expectedResult = {
                    "function new() {"
                },
                cursorPos = { line = 1, col = 10 },
                par = 5,
                optimal = 5,
                description = "Change 'old' to 'new'",
                optimalSolution = "ciwnew<Esc>",
                hint = "Use ciw to change inner word, type 'new', then Esc"
            },
            {
                name = "Add quotes around word",
                startText = {
                    "name: John"
                },
                expectedResult = {
                    "name: 'John'"
                },
                cursorPos = { line = 1, col = 7 },
                par = 4,
                optimal = 4,
                description = "Add quotes around 'John'",
                optimalSolution = "i'<Esc>ea'",
                hint = "Insert quote before, escape, end of word, add quote"
            },
            {
                name = "Delete until character",
                startText = {
                    "remove this part, keep this"
                },
                expectedResult = {
                    "keep this"
                },
                cursorPos = { line = 1, col = 1 },
                par = 3,
                optimal = 3,
                description = "Delete everything before comma",
                optimalSolution = "dt,x",
                hint = "Use dt, to delete until comma, then x to delete comma and space"
            },
            {
                name = "Insert at beginning",
                startText = {
                    "console.log('test');"
                },
                expectedResult = {
                    "// console.log('test');"
                },
                cursorPos = { line = 1, col = 1 },
                par = 4,
                optimal = 4,
                description = "Comment out the line",
                optimalSolution = "I// ",
                hint = "Use I to insert at beginning, type '// '"
            },
            {
                name = "Change inside parentheses",
                startText = {
                    "print(old_value)"
                },
                expectedResult = {
                    "print(new_value)"
                },
                cursorPos = { line = 1, col = 7 },
                par = 11,
                optimal = 11,
                description = "Change content inside parentheses",
                optimalSolution = "ci(new_value",
                hint = "Use ci( to change inside parentheses, type new content"
            }
        }
    },

    medium = {
        challenges = {
            {
                name = "Multi-word replacement",
                startText = {
                    "var userName = '';",
                    "var userAge = 0;",
                    "var isActive = true;"
                },
                expectedResult = {
                    "let userName = '';",
                    "let userAge = 0;",
                    "let isActive = true;"
                },
                cursorPos = { line = 1, col = 1 },
                par = 12,
                optimal = 8,
                description = "Replace all 'var' with 'let'"
            },
            {
                name = "Rearrange function parameters",
                startText = {
                    "function test(a, b, c) {"
                },
                expectedResult = {
                    "function test(c, a, b) {"
                },
                cursorPos = { line = 1, col = 14 },
                par = 15,
                optimal = 12,
                description = "Rearrange parameters: move 'c' to front"
            },
            {
                name = "Extract number to variable",
                startText = {
                    "if (age >= 18 && age < 65) {"
                },
                expectedResult = {
                    "const MIN_AGE = 18;",
                    "if (age >= MIN_AGE && age < 65) {"
                },
                cursorPos = { line = 1, col = 1 },
                par = 20,
                optimal = 16,
                description = "Extract 18 to MIN_AGE constant"
            }
        }
    },

    hard = {
        challenges = {
            {
                name = "Complex refactoring",
                startText = {
                    "const items = data.filter(item => item.active).map(item => item.name);"
                },
                expectedResult = {
                    "const activeItems = data.filter(item => item.active);",
                    "const itemNames = activeItems.map(item => item.name);"
                },
                cursorPos = { line = 1, col = 1 },
                par = 35,
                optimal = 28,
                description = "Split chained operations into separate variables"
            },
            {
                name = "Format nested object",
                startText = {
                    "const config = {api: {url: 'test', timeout: 5000}};"
                },
                expectedResult = {
                    "const config = {",
                    "  api: {",
                    "    url: 'test',",
                    "    timeout: 5000",
                    "  }",
                    "};"
                },
                cursorPos = { line = 1, col = 17 },
                par = 25,
                optimal = 20,
                description = "Format object with proper indentation"
            }
        }
    },

    nightmare = {
        challenges = {
            {
                name = "Advanced text manipulation",
                startText = {
                    "function process(data) { return data.filter(x => x.active).sort((a,b) => a.name.localeCompare(b.name)).map(x => ({...x, processed: true})); }"
                },
                expectedResult = {
                    "function process(data) {",
                    "  return data",
                    "    .filter(x => x.active)",
                    "    .sort((a,b) => a.name.localeCompare(b.name))",
                    "    .map(x => ({...x, processed: true}));",
                    "}"
                },
                cursorPos = { line = 1, col = 25 },
                par = 40,
                optimal = 32,
                description = "Format method chain with proper line breaks"
            }
        }
    },

    tpope = {
        challenges = {
            {
                name = "Master-level golf",
                startText = {
                    "const a=1;const b=2;const c=3;console.log(a,b,c);"
                },
                expectedResult = {
                    "const values = [1, 2, 3];",
                    "console.log(...values);"
                },
                cursorPos = { line = 1, col = 1 },
                par = 30,
                optimal = 25,
                description = "Refactor to use array and spread operator"
            }
        }
    }
}

local VimGolfRound = {}

function VimGolfRound:new(difficulty, window)
    local round = {
        window = window,
        difficulty = difficulty or "easy",
        currentChallenge = nil,
        keystrokeCount = 0,
        endRoundCallback = nil,
        hasWon = false,
        lastBuffer = nil
    }

    self.__index = self
    return setmetatable(round, self)
end

function VimGolfRound:getInstructions()
    return instructions
end

function VimGolfRound:getConfig()
    vim.schedule(function()
        if self.window and self.window.bufh then
            vim.api.nvim_buf_set_option(self.window.bufh, 'modifiable', true)
        end
    end)

    self:generateChallenge()
    self.hasWon = false
    self.keystrokeCount = 0

    return {
        roundTime = GameUtils.difficultyToTime[self.difficulty] or 60000,
        canEndRound = true,
    }
end

function VimGolfRound:generateChallenge()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy

    self.currentChallenge = vim.deepcopy(config.challenges[math.random(#config.challenges)])
end

function VimGolfRound:getScoreStatus(keystrokes)
    if not self.currentChallenge then return "⛳" end

    local par = self.currentChallenge.par
    local optimal = self.currentChallenge.optimal or par

    if keystrokes == optimal then
        return "🏆 Hole-in-one"
    elseif keystrokes < par then
        return "🥇 Eagle"
    elseif keystrokes == par then
        return "🥈 Birdie"
    elseif keystrokes <= par + 3 then
        return "🥉 Par"
    else
        return "⛳ Bogey"
    end
end

function VimGolfRound:setupKeystrokeMonitoring()
    local augroup_name = "VimGolfKeystroke_" .. vim.fn.localtime()
    self.keystrokeAugroup = augroup_name

    vim.api.nvim_create_augroup(augroup_name, { clear = true })

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        group = augroup_name,
        buffer = self.window.buffer.bufh,
        callback = function()
            if not self.hasWon then
                self:checkForWin()
            end
        end
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
        group = augroup_name,
        buffer = self.window.buffer.bufh,
        callback = function()
        end
    })
end

function VimGolfRound:incrementKeystroke()
    self.keystrokeCount = self.keystrokeCount + 1
end

function VimGolfRound:checkForWin()
    if not self.currentChallenge or self.hasWon then
        return false
    end

    local all_lines = vim.api.nvim_buf_get_lines(self.window.buffer.bufh, 0, -1, false)
    local actual_text = {}

    local start_line = nil
    for i, line in ipairs(all_lines) do
        if line:match("^=== YOUR CODE %(edit below%) ===$") then
            start_line = i + 1
            break
        end
    end

    if start_line then
        for i = 1, #self.currentChallenge.expectedResult do
            actual_text[i] = all_lines[start_line + i - 1] or ""
        end
    end

    if self.lastBuffer then
        local changes = 0
        for i = 1, math.max(#actual_text, #self.lastBuffer) do
            if actual_text[i] ~= self.lastBuffer[i] then
                changes = changes + 1
            end
        end
        if changes > 0 then
            self.keystrokeCount = self.keystrokeCount + changes
        end
    end
    self.lastBuffer = vim.deepcopy(actual_text)

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

        if self.endRoundCallback then
            vim.defer_fn(function()
                self.endRoundCallback(true)
            end, 100)
        end
        return true
    end

    return false
end

function VimGolfRound:render()
    if not self.currentChallenge then
        return {}, 1, 0
    end

    local lines = {}

    table.insert(lines, "Challenge: " .. self.currentChallenge.name)
    table.insert(lines, "Description: " .. self.currentChallenge.description)
    table.insert(lines, "Par: " .. self.currentChallenge.par .. " keystrokes")

    if self.hasWon then
        local status = self:getScoreStatus(self.keystrokeCount)
        table.insert(lines, "Final Score: " .. self.keystrokeCount .. " keystrokes (" .. status .. ")")
    else
        table.insert(lines, "Current Score: " .. self.keystrokeCount .. " keystrokes")
    end

    if (self.difficulty == "noob" or self.difficulty == "easy") and self.currentChallenge.optimalSolution then
        table.insert(lines,
            "Optimal Solution: " ..
            self.currentChallenge.optimalSolution .. " (" .. self.currentChallenge.optimal .. " keystrokes)")
    end

    if self.difficulty == "noob" or self.difficulty == "easy" then
        table.insert(lines, "Hint: " .. self.currentChallenge.hint)
    end

    table.insert(lines, "")
    table.insert(lines, "=== EXPECTED RESULT ===")

    for _, line in ipairs(self.currentChallenge.expectedResult) do
        table.insert(lines, line)
    end

    table.insert(lines, "")
    table.insert(lines, "=== YOUR CODE (edit below) ===")

    for _, line in ipairs(self.currentChallenge.startText) do
        table.insert(lines, line)
    end

    local editableSectionStart = #lines - #self.currentChallenge.startText + 1
    local cursorLine = editableSectionStart + (self.currentChallenge.cursorPos.line or 1) - 1
    local cursorCol = (self.currentChallenge.cursorPos.col or 1) - 1

    vim.defer_fn(function()
        self:setupKeystrokeMonitoring()
    end, 100)

    return lines, cursorLine, cursorCol
end

function VimGolfRound:cleanup()
    if self.keystrokeAugroup then
        pcall(vim.api.nvim_del_augroup_by_name, self.keystrokeAugroup)
        self.keystrokeAugroup = nil
    end
end

function VimGolfRound:name()
    return "vim-golf"
end

function VimGolfRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
end

return VimGolfRound
