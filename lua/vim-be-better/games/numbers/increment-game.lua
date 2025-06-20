local GameUtils = require("vim-be-better.game-utils")

local instructions = {
    "--- Increment Game ---",
    "",
    "Master vim number operations!",
    "Increment and decrement numbers using vim commands.",
    "",
    "  <C-a>     - increment number under cursor    <C-x> - decrement number",
    "  5<C-a>    - increment by 5                   10<C-x> - decrement by 10",
    "  Visual+<C-a> - increment all numbers         g<C-a> - sequential increment",
    "",
    "Goal: Fix numbers to match the expected values.",
}

local difficultyConfig = {
    noob = {
        challenges = {
            {
                name = "Simple increment",
                startText = {
                    "local count = 4",
                    "print(count)"
                },
                expectedResult = {
                    "local count = 5",
                    "print(count)"
                },
                cursorPos = { line = 1, col = 15 },
                operation = "<C-a>",
                hint = "Use <C-a> to increment number under cursor by 1"
            },
            {
                name = "Simple decrement",
                startText = {
                    "local lives = 4",
                    "local score = 100"
                },
                expectedResult = {
                    "local lives = 3",
                    "local score = 100"
                },
                cursorPos = { line = 1, col = 15 },
                operation = "<C-x>",
                hint = "Use <C-x> to decrement number under cursor by 1"
            },
            {
                name = "Fix array index",
                startText = {
                    "local item = arr[0]",
                    "print(item)"
                },
                expectedResult = {
                    "local item = arr[1]",
                    "print(item)"
                },
                cursorPos = { line = 1, col = 17 },
                operation = "<C-a>",
                hint = "Use <C-a> to fix array index (0 → 1)"
            }
        }
    },

    easy = {
        challenges = {
            {
                name = "Increment by 5",
                startText = {
                    "local timeout = 25",
                    "local retry = 3"
                },
                expectedResult = {
                    "local timeout = 30",
                    "local retry = 3"
                },
                cursorPos = { line = 1, col = 17 },
                operation = "5<C-a>",
                hint = "Use 5<C-a> to increment by 5"
            },
            {
                name = "Decrement by 10",
                startText = {
                    "local price = 150",
                    "local discount = 20"
                },
                expectedResult = {
                    "local price = 140",
                    "local discount = 20"
                },
                cursorPos = { line = 1, col = 15 },
                operation = "10<C-x>",
                hint = "Use 10<C-x> to decrement by 10"
            },
            {
                name = "Fix port number",
                startText = {
                    "const PORT = 3000",
                    "const HOST = 'localhost'"
                },
                expectedResult = {
                    "const PORT = 8080",
                    "const HOST = 'localhost'"
                },
                cursorPos = { line = 1, col = 14 },
                operation = "5080<C-a>",
                hint = "Use 5080<C-a> to change port from 3000 to 8080"
            },
            {
                name = "Update version",
                startText = {
                    "version = '1.2.3'",
                    "author = 'dev'"
                },
                expectedResult = {
                    "version = '1.2.4'",
                    "author = 'dev'"
                },
                cursorPos = { line = 1, col = 15 },
                operation = "<C-a>",
                hint = "Use <C-a> to bump patch version (3 → 4)"
            }
        }
    },

    medium = {
        challenges = {
            {
                name = "Create numbered list",
                startText = {
                    "1. First item",
                    "1. Second item",
                    "1. Third item",
                    "1. Fourth item"
                },
                expectedResult = {
                    "1. First item",
                    "2. Second item",
                    "3. Third item",
                    "4. Fourth item"
                },
                cursorPos = { line = 2, col = 1 },
                hint = "Select lines 2-4 in Visual mode, then use g<C-a> for sequential numbering"
            },
            {
                name = "Fix array indices",
                startText = {
                    "arr[0] = 'first'",
                    "arr[0] = 'second'",
                    "arr[0] = 'third'"
                },
                expectedResult = {
                    "arr[0] = 'first'",
                    "arr[1] = 'second'",
                    "arr[2] = 'third'"
                },
                cursorPos = { line = 2, col = 5 },
                hint = "Select the numbers in lines 2-3, then use g<C-a> for sequential increment"
            },
            {
                name = "Update multiple timeouts",
                startText = {
                    "timeout1 = 5000",
                    "timeout2 = 5000",
                    "timeout3 = 5000"
                },
                expectedResult = {
                    "timeout1 = 10000",
                    "timeout2 = 10000",
                    "timeout3 = 10000"
                },
                cursorPos = { line = 1, col = 12 },
                hint = "Select all three numbers and use <C-a> to increment them all by same amount"
            },
            {
                name = "Hex color adjustment",
                startText = {
                    "color = 0xff0000",
                    "background = 0x000000"
                },
                expectedResult = {
                    "color = 0xff0010",
                    "background = 0x000000"
                },
                cursorPos = { line = 1, col = 13 },
                hint = "Increment hex number - vim recognizes 0x format"
            }
        }
    },

    hard = {
        challenges = {
            {
                name = "Database connection config",
                startText = {
                    "db_config = {",
                    "  port = 5432,",
                    "  timeout = 30,",
                    "  max_connections = 50,",
                    "  retry_count = 3",
                    "}"
                },
                expectedResult = {
                    "db_config = {",
                    "  port = 5433,",
                    "  timeout = 60,",
                    "  max_connections = 100,",
                    "  retry_count = 5",
                    "}"
                },
                cursorPos = { line = 2, col = 10 },
                hint = "Update each database setting: port+1, timeout+30, connections+50, retries+2"
            },
            {
                name = "Version update across files",
                startText = {
                    "API_VERSION = 'v2.1.0'",
                    "CLIENT_VERSION = '2.1.0'",
                    "const version = '2.1.0'",
                    "version: '2.1.0'"
                },
                expectedResult = {
                    "API_VERSION = 'v2.2.0'",
                    "CLIENT_VERSION = '2.2.0'",
                    "const version = '2.2.0'",
                    "version: '2.2.0'"
                },
                cursorPos = { line = 1, col = 19 },
                hint = "Bump minor version from 2.1.0 to 2.2.0 in all occurrences"
            },
            {
                name = "Network configuration",
                startText = {
                    "servers = [",
                    "  { ip: '192.168.1.10', port: 8080 },",
                    "  { ip: '192.168.1.10', port: 8080 },",
                    "  { ip: '192.168.1.10', port: 8080 }",
                    "]"
                },
                expectedResult = {
                    "servers = [",
                    "  { ip: '192.168.1.10', port: 8080 },",
                    "  { ip: '192.168.1.11', port: 8081 },",
                    "  { ip: '192.168.1.12', port: 8082 }",
                    "]"
                },
                cursorPos = { line = 3, col = 21 },
                hint = "Create unique IPs and ports for each server using sequential increment"
            }
        }
    },

    nightmare = {
        challenges = {
            {
                name = "Complex numbering system",
                startText = {
                    "test_case_001: 'login test'",
                    "test_case_001: 'logout test'",
                    "test_case_001: 'profile test'",
                    "test_case_001: 'settings test'",
                    "test_case_001: 'admin test'"
                },
                expectedResult = {
                    "test_case_001: 'login test'",
                    "test_case_002: 'logout test'",
                    "test_case_003: 'profile test'",
                    "test_case_004: 'settings test'",
                    "test_case_005: 'admin test'"
                },
                cursorPos = { line = 2, col = 11 },
                hint = "Create sequential test case numbers with leading zeros"
            }
        }
    },

    tpope = {
        challenges = {
            {
                name = "Advanced numbering patterns",
                startText = {
                    "rule_a_001: { priority: 10, weight: 100 }",
                    "rule_a_001: { priority: 10, weight: 100 }",
                    "rule_a_001: { priority: 10, weight: 100 }"
                },
                expectedResult = {
                    "rule_a_001: { priority: 10, weight: 100 }",
                    "rule_b_002: { priority: 20, weight: 200 }",
                    "rule_c_003: { priority: 30, weight: 300 }"
                },
                cursorPos = { line = 2, col = 6 },
                hint = "Increment letters, numbers, priority and weight sequentially"
            }
        }
    }
}

local IncrementGameRound = {}

function IncrementGameRound:new(difficulty, window)
    local round = {
        window = window,
        difficulty = difficulty or "easy",
        currentChallenge = nil,
        challengeIndex = 1,
    }

    self.__index = self
    return setmetatable(round, self)
end

function IncrementGameRound:getInstructions()
    return instructions
end

function IncrementGameRound:getConfig()
    vim.schedule(function()
        if self.window and self.window.bufh then
            vim.api.nvim_buf_set_option(self.window.bufh, 'modifiable', true)
            vim.opt.nrformats = "bin,hex,alpha"
        end
    end)

    self:generateChallenge()

    return {
        roundTime = GameUtils.difficultyToTime[self.difficulty] or 15000,
        canEndRound = true,
    }
end

function IncrementGameRound:generateChallenge()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy

    self.currentChallenge = config.challenges[math.random(#config.challenges)]
end

function IncrementGameRound:checkForWin()
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

function IncrementGameRound:render()
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

function IncrementGameRound:name()
    return "increment-game"
end

function IncrementGameRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
end

return IncrementGameRound
