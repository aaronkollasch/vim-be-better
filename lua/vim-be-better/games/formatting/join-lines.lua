local GameUtils = require("vim-be-better.game-utils")

local instructions = {
    "--- Join Lines Master ---",
    "",
    "Master vim line joining commands!",
    "Combine multiple lines into single lines.",
    "",
    "  J     - join line with next (with space)   gJ - join without space",
    "  3J    - join 3 lines together             VJ - visual join lines",
    "  V2jJ  - select 3 lines and join           ",
    "",
    "Goal: Join lines to match the expected format.",
}

local difficultyConfig = {
    noob = {
        challenges = {
            {
                name = "Join two simple lines",
                startText = {
                    "Hello",
                    "World",
                    "Test line"
                },
                expectedResult = {
                    "Hello World",
                    "Test line"
                },
                cursorPos = { line = 1, col = 1 },
                operation = "J",
                hint = "Use J to join current line with next (adds space)"
            },
            {
                name = "Join without space",
                startText = {
                    "file",
                    ".txt",
                    "other file"
                },
                expectedResult = {
                    "file.txt",
                    "other file"
                },
                cursorPos = { line = 1, col = 1 },
                operation = "gJ",
                hint = "Use gJ to join lines without adding space"
            },
            {
                name = "Join function call",
                startText = {
                    "print(",
                    "'hello')",
                    "other code"
                },
                expectedResult = {
                    "print('hello')",
                    "other code"
                },
                cursorPos = { line = 1, col = 1 },
                operation = "gJ",
                hint = "Use gJ to join function call without space"
            }
        }
    },

    easy = {
        challenges = {
            {
                name = "Join three lines",
                startText = {
                    "local",
                    "my_var",
                    "= 123",
                    "print(my_var)"
                },
                expectedResult = {
                    "local my_var = 123",
                    "print(my_var)"
                },
                cursorPos = { line = 1, col = 1 },
                operation = "2J",
                hint = "Use 2J to join current line with next 2 lines"
            },
            {
                name = "Join array elements",
                startText = {
                    "local arr = {",
                    "  'item1',",
                    "  'item2'",
                    "}"
                },
                expectedResult = {
                    "local arr = { 'item1', 'item2' }"
                },
                cursorPos = { line = 1, col = 1 },
                operation = "3J",
                hint = "Use 3J to join 4 lines together"
            },
            {
                name = "Join string concatenation",
                startText = {
                    "local msg = 'Hello' ..",
                    "            'World' ..",
                    "            '!'"
                },
                expectedResult = {
                    "local msg = 'Hello' .. 'World' .. '!'"
                },
                cursorPos = { line = 1, col = 1 },
                operation = "2J",
                hint = "Use 2J to join 3 lines of string concatenation"
            },
            {
                name = "Fix broken if statement",
                startText = {
                    "if condition",
                    "   then",
                    "  print('true')",
                    "end"
                },
                expectedResult = {
                    "if condition then",
                    "  print('true')",
                    "end"
                },
                cursorPos = { line = 1, col = 1 },
                operation = "J",
                hint = "Use J to join if statement properly"
            }
        }
    },

    medium = {
        challenges = {
            {
                name = "Join method chain",
                startText = {
                    "result = data",
                    "  :filter(function(x) return x > 0 end)",
                    "  :map(function(x) return x * 2 end)",
                    "  :reduce(function(a, b) return a + b end)"
                },
                expectedResult = {
                    "result = data:filter(function(x) return x > 0 end):map(function(x) return x * 2 end):reduce(function(a, b) return a + b end)"
                },
                cursorPos = { line = 1, col = 1 },
                hint = "Join method chain into single line using multiple J commands"
            },
            {
                name = "Selective line joining",
                startText = {
                    "function test()",
                    "  local a =",
                    "    123",
                    "  local b =",
                    "    456",
                    "  return a + b",
                    "end"
                },
                expectedResult = {
                    "function test()",
                    "  local a = 123",
                    "  local b = 456",
                    "  return a + b",
                    "end"
                },
                cursorPos = { line = 2, col = 1 },
                hint = "Join variable assignments while keeping function structure"
            },
            {
                name = "Join SQL query",
                startText = {
                    "SELECT name,",
                    "       email,",
                    "       age",
                    "FROM users",
                    "WHERE active = true"
                },
                expectedResult = {
                    "SELECT name, email, age",
                    "FROM users",
                    "WHERE active = true"
                },
                cursorPos = { line = 1, col = 1 },
                hint = "Join SELECT columns while keeping query structure"
            }
        }
    },

    hard = {
        challenges = {
            {
                name = "Complex function definition",
                startText = {
                    "function processData(",
                    "  input,",
                    "  options = {},",
                    "  callback = nil",
                    ")",
                    "  -- function body",
                    "end"
                },
                expectedResult = {
                    "function processData(input, options = {}, callback = nil)",
                    "  -- function body",
                    "end"
                },
                cursorPos = { line = 1, col = 1 },
                hint = "Join function parameters into single line"
            },
            {
                name = "Conditional chain joining",
                startText = {
                    "if condition1 and",
                    "   condition2 and",
                    "   condition3 then",
                    "  do_something()",
                    "elseif other_condition or",
                    "       another_condition then",
                    "  do_other_thing()",
                    "end"
                },
                expectedResult = {
                    "if condition1 and condition2 and condition3 then",
                    "  do_something()",
                    "elseif other_condition or another_condition then",
                    "  do_other_thing()",
                    "end"
                },
                cursorPos = { line = 1, col = 1 },
                hint = "Join conditional expressions while preserving structure"
            }
        }
    },

    nightmare = {
        challenges = {
            {
                name = "Complex object definition",
                startText = {
                    "local config = {",
                    "  database = {",
                    "    host =",
                    "      'localhost',",
                    "    port =",
                    "      5432,",
                    "    name =",
                    "      'mydb'",
                    "  },",
                    "  server = {",
                    "    port =",
                    "      8080",
                    "  }",
                    "}"
                },
                expectedResult = {
                    "local config = {",
                    "  database = {",
                    "    host = 'localhost',",
                    "    port = 5432,",
                    "    name = 'mydb'",
                    "  },",
                    "  server = {",
                    "    port = 8080",
                    "  }",
                    "}"
                },
                cursorPos = { line = 3, col = 1 },
                hint = "Join key-value pairs while preserving object structure"
            }
        }
    },

    tpope = {
        challenges = {
            {
                name = "Advanced formatting mix",
                startText = {
                    "const result = await Promise.all([",
                    "  fetch('/api/users')",
                    "    .then(response =>",
                    "      response.json())",
                    "    .then(data =>",
                    "      data.filter(user =>",
                    "        user.active)),",
                    "  fetch('/api/settings')",
                    "    .then(response =>",
                    "      response.json())",
                    "])"
                },
                expectedResult = {
                    "const result = await Promise.all([",
                    "  fetch('/api/users').then(response => response.json()).then(data => data.filter(user => user.active)),",
                    "  fetch('/api/settings').then(response => response.json())",
                    "])"
                },
                cursorPos = { line = 2, col = 1 },
                hint = "Join promise chains while maintaining array structure"
            }
        }
    }
}

local JoinLinesRound = {}

function JoinLinesRound:new(difficulty, window)
    local round = {
        window = window,
        difficulty = difficulty or "easy",
        currentChallenge = nil,
        challengeIndex = 1,
    }

    self.__index = self
    return setmetatable(round, self)
end

function JoinLinesRound:getInstructions()
    return instructions
end

function JoinLinesRound:getConfig()
    vim.schedule(function()
        if self.window and self.window.bufh then
            vim.api.nvim_buf_set_option(self.window.bufh, 'modifiable', true)
        end
    end)

    self:generateChallenge()

    return {
        roundTime = GameUtils.difficultyToTime[self.difficulty] or 15000,
        canEndRound = true,
    }
end

function JoinLinesRound:generateChallenge()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy

    self.currentChallenge = config.challenges[math.random(#config.challenges)]
end

function JoinLinesRound:checkForWin()
    if not self.currentChallenge then
        return false
    end

    local all_lines = vim.api.nvim_buf_get_lines(self.window.buffer.bufh, 0, -1, false)
    local actual_text = {}

    local start_line = nil
    for i, line in ipairs(all_lines) do
        for j, start_line_text in ipairs(self.currentChallenge.startText) do
            if line == start_line_text or line == self.currentChallenge.expectedResult[j] then
                start_line = i
                break
            end
        end
        if start_line then break end
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

    return matches
end

function JoinLinesRound:render()
    if not self.currentChallenge then
        self:generateChallenge()
    end

    local lines = vim.deepcopy(self.currentChallenge.startText)
    local cursorLine = self.currentChallenge.cursorPos.line or 1
    local cursorCol = self.currentChallenge.cursorPos.col or 1

    table.insert(lines, "")
    table.insert(lines, "--- HINT ---")
    table.insert(lines, self.currentChallenge.hint)

    if (self.difficulty == "noob" or self.difficulty == "easy") and self.currentChallenge.operation then
        table.insert(lines, "Operation: " .. self.currentChallenge.operation)
    end

    return lines, cursorLine, cursorCol
end

function JoinLinesRound:name()
    return "join-lines"
end

function JoinLinesRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
end

return JoinLinesRound
