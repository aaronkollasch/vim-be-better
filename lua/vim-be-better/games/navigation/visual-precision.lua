local GameUtils = require("vim-be-better.game-utils")

local instructions = {
    "--- Visual Operations ---",
    "",
    "Master visual selection + operations in vim!",
    "Perform the exact operation to transform the code.",
    "",
    "  viw+d - delete word           vi'+y - copy quoted text",
    "  vaw+c - change word+space     vip+d - delete paragraph",
    "  vi(+y - copy in parentheses   V+> - indent line",
    "",
    "Goal: Transform the code using visual selection + operation.",
}

local difficultyConfig = {
    noob = {
        challenges = {
            {
                name = "Delete single word",
                startText = {
                    "hello world example",
                    "another line here"
                },
                expectedText = {
                    "hello  example",
                    "another line here"
                },
                cursorPos = { line = 1, col = 7 },
                targetWord = "world",
                operation = "viw+d",
                hint = "Position cursor on 'world', use viw to select it, then d to delete"
            },
            {
                name = "Delete quoted content",
                startText = {
                    "local msg = 'hello world'",
                    "print(msg)"
                },
                expectedText = {
                    "local msg = ''",
                    "print(msg)"
                },
                cursorPos = { line = 1, col = 16 },
                targetWord = "hello world",
                operation = "vi'+d",
                hint = "Position cursor inside quotes, use vi' to select content, then d"
            },
            {
                name = "Copy and paste word",
                startText = {
                    "local variable = 123",
                    "print()"
                },
                expectedText = {
                    "local variable = 123",
                    "print(variable)"
                },
                cursorPos = { line = 1, col = 7 },
                targetWord = "variable",
                operation = "viw+y, then p",
                hint = "Select 'variable' with viw, copy with y, go to (), paste with p"
            }
        }
    },

    easy = {
        challenges = {
            {
                name = "Delete function parameters",
                startText = {
                    "function test(param1, param2)",
                    "  return true",
                    "end"
                },
                expectedText = {
                    "function test()",
                    "  return true",
                    "end"
                },
                cursorPos = { line = 1, col = 20 },
                targetWord = "param1, param2",
                operation = "vi(+d",
                hint = "Select content inside parentheses with vi(, then delete with d"
            },
            {
                name = "Change variable name",
                startText = {
                    "local oldName = getValue()",
                    "print(oldName)"
                },
                expectedText = {
                    "local newName = getValue()",
                    "print(oldName)"
                },
                cursorPos = { line = 1, col = 7 },
                targetWord = "oldName",
                operation = "viw+c+newName",
                hint = "Select 'oldName' with viw, change with c, type 'newName'"
            },
            {
                name = "Copy text in brackets",
                startText = {
                    "result = calculate(a, b)",
                    "backup = calculate()",
                },
                expectedText = {
                    "result = calculate(a, b)",
                    "backup = calculate(a, b)",
                },
                cursorPos = { line = 1, col = 20 },
                targetWord = "a, b",
                operation = "vi(+y, navigate, vi(+p",
                hint = "Copy parameters from first function to second using vi(+y then vi(+p"
            },
            {
                name = "Delete until character",
                startText = {
                    "for i = 1, 10 do",
                    "  print(i)",
                    "end"
                },
                expectedText = {
                    "for i do",
                    "  print(i)",
                    "end"
                },
                cursorPos = { line = 1, col = 7 },
                targetWord = "= 1, 10 ",
                operation = "vt +d",
                hint = "Use vt<space> to select until space before 'do', then delete"
            }
        }
    },

    medium = {
        challenges = {
            {
                name = "Transform entire function",
                startText = {
                    "function oldFunction()",
                    "  local result = 42",
                    "  return result",
                    "end"
                },
                expectedText = {
                    "function newFunction()",
                    "  local result = 42",
                    "  return result",
                    "end"
                },
                cursorPos = { line = 1, col = 10 },
                targetWord = "oldFunction",
                operation = "viw+c+newFunction",
                hint = "Change function name from 'oldFunction' to 'newFunction'"
            },
            {
                name = "Copy complex expression",
                startText = {
                    "local config = getData().filter(x => x.active)",
                    "local backup = nil"
                },
                expectedText = {
                    "local config = getData().filter(x => x.active)",
                    "local backup = getData().filter(x => x.active)"
                },
                cursorPos = { line = 1, col = 16 },
                targetWord = "getData().filter(x => x.active)",
                operation = "visual selection + y/p",
                hint = "Copy the entire method chain to backup variable"
            },
            {
                name = "Delete nested braces content",
                startText = {
                    "local config = {",
                    "  database = {",
                    "    host = 'localhost',",
                    "    port = 5432",
                    "  },",
                    "  debug = true",
                    "}"
                },
                expectedText = {
                    "local config = {",
                    "  database = {},",
                    "  debug = true",
                    "}"
                },
                cursorPos = { line = 3, col = 5 },
                targetWord = "database content",
                operation = "vi{+d (inner braces)",
                hint = "Delete content inside database object braces"
            }
        }
    },

    hard = {
        challenges = {
            {
                name = "Restructure API call",
                startText = {
                    "result = api.getData({",
                    "  filters: { active: true },",
                    "  sort: 'name'",
                    "})"
                },
                expectedText = {
                    "result = api.getData({",
                    "  sort: 'name'",
                    "})"
                },
                cursorPos = { line = 2, col = 3 },
                targetWord = "filters line",
                operation = "V+d (line delete)",
                hint = "Delete entire filters line using V (line visual) + d"
            }
        }
    },

    nightmare = {
        challenges = {
            {
                name = "Advanced text transformation",
                startText = {
                    "const users = await fetch('/api/users')",
                    "  .then(response => response.json())",
                    "  .then(data => data.map(u => u.name))",
                    "console.log(users)"
                },
                expectedText = {
                    "const users = await processUsers()",
                    "console.log(users)"
                },
                cursorPos = { line = 1, col = 15 },
                targetWord = "complex chain",
                operation = "multi-line visual + c + replacement",
                hint = "Replace entire async chain with simple function call"
            }
        }
    },

    tpope = {
        challenges = {
            {
                name = "Master code refactoring",
                startText = {
                    "if (condition && anotherCondition) {",
                    "  const result = processData(input)",
                    "  if (result.isValid) {",
                    "    return result.data",
                    "  }",
                    "  return null",
                    "}"
                },
                expectedText = {
                    "if (condition && anotherCondition) {",
                    "  return processAndValidate(input)",
                    "}"
                },
                cursorPos = { line = 2, col = 3 },
                targetWord = "nested logic",
                operation = "complex visual selection + refactoring",
                hint = "Replace nested logic with single function call"
            }
        }
    }
}

local VisualOperationsRound = {}

function VisualOperationsRound:new(difficulty, window)
    local round = {
        window = window,
        difficulty = difficulty or "easy",
        currentChallenge = nil,
        challengeIndex = 1,
    }

    self.__index = self
    return setmetatable(round, self)
end

function VisualOperationsRound:getInstructions()
    return instructions
end

function VisualOperationsRound:getConfig()
    vim.schedule(function()
        if self.window and self.window.bufh then
            vim.api.nvim_buf_set_option(self.window.bufh, 'modifiable', true)
        end
    end)

    self:generateChallenge()

    return {
        roundTime = GameUtils.difficultyToTime[self.difficulty] or 20000,
        canEndRound = true,
    }
end

function VisualOperationsRound:generateChallenge()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy

    self.currentChallenge = config.challenges[math.random(#config.challenges)]
end

function VisualOperationsRound:checkForWin()
    if not self.currentChallenge then
        return false
    end

    local allLines = vim.api.nvim_buf_get_lines(self.window.bufh, 0, -1, false)

    local codeStartLine = 11
    for i, line in ipairs(allLines) do
        if line:match("^Goal:") then
            codeStartLine = i + 1
            break
        end
    end

    local currentCodeLines = {}
    for i = 1, #self.currentChallenge.expectedText do
        local lineIndex = codeStartLine + i - 1
        if lineIndex <= #allLines then
            table.insert(currentCodeLines, allLines[lineIndex])
        end
    end

    local matches = true
    if #currentCodeLines ~= #self.currentChallenge.expectedText then
        matches = false
    else
        for i, expectedLine in ipairs(self.currentChallenge.expectedText) do
            if currentCodeLines[i] ~= expectedLine then
                matches = false
                break
            end
        end
    end
    return matches
end

function VisualOperationsRound:render()
    if not self.currentChallenge then
        self:generateChallenge()
    end

    local lines = vim.deepcopy(self.currentChallenge.startText)
    local cursorLine = self.currentChallenge.cursorPos.line or 1
    local cursorCol = self.currentChallenge.cursorPos.col or 1

    table.insert(lines, "")
    table.insert(lines, "--- GOAL ---")
    table.insert(lines, "Transform: '" .. self.currentChallenge.targetWord .. "'")
    table.insert(lines, "")
    table.insert(lines, "--- EXPECTED RESULT ---")

    for _, expectedLine in ipairs(self.currentChallenge.expectedText) do
        table.insert(lines, "| " .. expectedLine)
    end

    table.insert(lines, "")
    table.insert(lines, "--- HINT ---")
    table.insert(lines, self.currentChallenge.hint)

    if (self.difficulty == "noob" or self.difficulty == "easy") and self.currentChallenge.operation then
        table.insert(lines, "Operation: " .. self.currentChallenge.operation)
    end

    return lines, cursorLine, cursorCol
end

function VisualOperationsRound:name()
    return "visual-operations"
end

function VisualOperationsRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
end

return VisualOperationsRound
