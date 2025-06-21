local GameUtils = require("vim-be-better.game-utils")

local instructions = {
    "--- Number Sequence Master ---",
    "",
    "Create and manipulate number sequences!",
    "Master advanced vim number operations.",
    "",
    "  Visual + g<C-a>  - create ascending sequence   g<C-x> - descending",
    "  :put =range(1,5) - generate number range      Substitute patterns",
    "  Leading zeros, custom steps, mixed patterns supported",
    "",
    "Goal: Create the exact number sequence pattern.",
}

local difficultyConfig = {
    noob = {
        challenges = {
            {
                name = "Simple ascending sequence",
                startText = {
                    "item_1",
                    "item_1",
                    "item_1",
                    "item_1"
                },
                expectedResult = {
                    "item_1",
                    "item_2",
                    "item_3",
                    "item_4"
                },
                cursorPos = { line = 2, col = 6 },
                operation = "Visual + g<C-a>",
                hint = "Select numbers in lines 2-4, then use g<C-a> for sequential increment"
            },
            {
                name = "Create countdown",
                startText = {
                    "level_5",
                    "level_5",
                    "level_5"
                },
                expectedResult = {
                    "level_5",
                    "level_4",
                    "level_3"
                },
                cursorPos = { line = 2, col = 7 },
                operation = "Visual + g<C-x>",
                hint = "Select numbers in lines 2-3, then use g<C-x> for sequential decrement"
            },
            {
                name = "Array indices",
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
                operation = "Visual + g<C-a>",
                hint = "Select indices in lines 2-3, then use g<C-a> for 0,1,2 sequence"
            }
        }
    },

    easy = {
        challenges = {
            {
                name = "Step by 2 sequence",
                startText = {
                    "port = 8000",
                    "port = 8000",
                    "port = 8000",
                    "port = 8000"
                },
                expectedResult = {
                    "port = 8000",
                    "port = 8002",
                    "port = 8004",
                    "port = 8006"
                },
                cursorPos = { line = 2, col = 8 },
                operation = "2g<C-a>",
                hint = "Select numbers in lines 2-4, then use 2g<C-a> for step-by-2 sequence"
            },
            {
                name = "Leading zeros sequence",
                startText = {
                    "file_001.txt",
                    "file_001.txt",
                    "file_001.txt"
                },
                expectedResult = {
                    "file_001.txt",
                    "file_002.txt",
                    "file_003.txt"
                },
                cursorPos = { line = 2, col = 7 },
                operation = "Visual + g<C-a>",
                hint = "Select 3-digit numbers, vim preserves leading zeros in sequences"
            },
            {
                name = "Test case numbering",
                startText = {
                    "test_01: 'login'",
                    "test_01: 'logout'",
                    "test_01: 'profile'",
                    "test_01: 'settings'"
                },
                expectedResult = {
                    "test_01: 'login'",
                    "test_02: 'logout'",
                    "test_03: 'profile'",
                    "test_04: 'settings'"
                },
                cursorPos = { line = 2, col = 6 },
                operation = "Visual + g<C-a>",
                hint = "Create sequential test case numbers with leading zeros"
            },
            {
                name = "Reverse numbering",
                startText = {
                    "priority_10",
                    "priority_10",
                    "priority_10",
                    "priority_10"
                },
                expectedResult = {
                    "priority_10",
                    "priority_9",
                    "priority_8",
                    "priority_7"
                },
                cursorPos = { line = 2, col = 10 },
                operation = "Visual + g<C-x>",
                hint = "Select numbers in lines 2-4, then use g<C-x> for descending sequence"
            }
        }
    },

    medium = {
        challenges = {
            {
                name = "Mixed sequence pattern",
                startText = {
                    "server_a_01",
                    "server_a_01",
                    "server_a_01"
                },
                expectedResult = {
                    "server_a_01",
                    "server_b_02",
                    "server_c_03"
                },
                cursorPos = { line = 2, col = 8 },
                hint = "Increment both letters and numbers - use g<C-a> on both parts"
            },
            {
                name = "Version sequence",
                startText = {
                    "version: 'v1.0.1'",
                    "version: 'v1.0.1'",
                    "version: 'v1.0.1'",
                    "version: 'v1.0.1'"
                },
                expectedResult = {
                    "version: 'v1.0.1'",
                    "version: 'v1.0.2'",
                    "version: 'v1.0.3'",
                    "version: 'v1.0.4'"
                },
                cursorPos = { line = 2, col = 15 },
                hint = "Create patch version sequence for releases"
            },
            {
                name = "Database table IDs",
                startText = {
                    "INSERT INTO users (id, name) VALUES (100, 'user1');",
                    "INSERT INTO users (id, name) VALUES (100, 'user2');",
                    "INSERT INTO users (id, name) VALUES (100, 'user3');"
                },
                expectedResult = {
                    "INSERT INTO users (id, name) VALUES (100, 'user1');",
                    "INSERT INTO users (id, name) VALUES (101, 'user2');",
                    "INSERT INTO users (id, name) VALUES (102, 'user3');"
                },
                cursorPos = { line = 2, col = 41 },
                hint = "Create sequential IDs for database inserts"
            },
            {
                name = "Step by 5 with offset",
                startText = {
                    "timeout_15",
                    "timeout_15",
                    "timeout_15",
                    "timeout_15"
                },
                expectedResult = {
                    "timeout_15",
                    "timeout_20",
                    "timeout_25",
                    "timeout_30"
                },
                cursorPos = { line = 2, col = 9 },
                hint = "Create sequence with step of 5: 15,20,25,30"
            }
        }
    },

    hard = {
        challenges = {
            {
                name = "Complex numbering system",
                startText = {
                    "rule_A001_priority_10",
                    "rule_A001_priority_10",
                    "rule_A001_priority_10"
                },
                expectedResult = {
                    "rule_A001_priority_10",
                    "rule_B002_priority_20",
                    "rule_C003_priority_30"
                },
                cursorPos = { line = 2, col = 6 },
                hint = "Increment letters, numbers and priorities all in sequence"
            },
            {
                name = "Network configuration sequence",
                startText = {
                    "server { listen 192.168.1.10:8080; }",
                    "server { listen 192.168.1.10:8080; }",
                    "server { listen 192.168.1.10:8080; }"
                },
                expectedResult = {
                    "server { listen 192.168.1.10:8080; }",
                    "server { listen 192.168.1.11:8081; }",
                    "server { listen 192.168.1.12:8082; }"
                },
                cursorPos = { line = 2, col = 26 },
                hint = "Create sequential IPs and ports for server configuration"
            },
            {
                name = "Multi-dimensional array indices",
                startText = {
                    "matrix[0][0] = value1",
                    "matrix[0][0] = value2",
                    "matrix[0][0] = value3",
                    "matrix[0][0] = value4"
                },
                expectedResult = {
                    "matrix[0][0] = value1",
                    "matrix[0][1] = value2",
                    "matrix[1][0] = value3",
                    "matrix[1][1] = value4"
                },
                cursorPos = { line = 2, col = 9 },
                hint = "Create 2D matrix indices pattern: [0][1], [1][0], [1][1]"
            }
        }
    },

    nightmare = {
        challenges = {
            {
                name = "Hexadecimal sequence",
                startText = {
                    "color_0x00ff00",
                    "color_0x00ff00",
                    "color_0x00ff00",
                    "color_0x00ff00"
                },
                expectedResult = {
                    "color_0x00ff00",
                    "color_0x00ff10",
                    "color_0x00ff20",
                    "color_0x00ff30"
                },
                cursorPos = { line = 2, col = 13 },
                hint = "Create hex color sequence with step increment"
            },
            {
                name = "Advanced test patterns",
                startText = {
                    "test_suite_A_case_001_priority_high",
                    "test_suite_A_case_001_priority_high",
                    "test_suite_A_case_001_priority_high"
                },
                expectedResult = {
                    "test_suite_A_case_001_priority_high",
                    "test_suite_B_case_002_priority_medium",
                    "test_suite_C_case_003_priority_low"
                },
                cursorPos = { line = 2, col = 12 },
                hint = "Complex pattern: increment suite letters, case numbers, change priorities"
            }
        }
    },

    tpope = {
        challenges = {
            {
                name = "Ultimate sequence mastery",
                startText = {
                    "api_v1_endpoint_01_method_GET_priority_A",
                    "api_v1_endpoint_01_method_GET_priority_A",
                    "api_v1_endpoint_01_method_GET_priority_A"
                },
                expectedResult = {
                    "api_v1_endpoint_01_method_GET_priority_A",
                    "api_v2_endpoint_02_method_POST_priority_B",
                    "api_v3_endpoint_03_method_PUT_priority_C"
                },
                cursorPos = { line = 2, col = 6 },
                hint = "Master level: increment versions, endpoints, change methods and priorities"
            }
        }
    }
}

local NumberSequenceRound = {}

function NumberSequenceRound:new(difficulty, window)
    local round = {
        window = window,
        difficulty = difficulty or "easy",
        currentChallenge = nil,
        challengeIndex = 1,
    }

    self.__index = self
    return setmetatable(round, self)
end

function NumberSequenceRound:getInstructions()
    return instructions
end

function NumberSequenceRound:getConfig()
    vim.schedule(function()
        if self.window and self.window.bufh then
            vim.bo[self.window.bufh].modifiable = true
            vim.opt.nrformats = "bin,hex,alpha"
        end
    end)

    self:generateChallenge()

    return {
        roundTime = GameUtils.difficultyToTime[self.difficulty] or 15000,
        canEndRound = true,
    }
end

function NumberSequenceRound:generateChallenge()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy

    self.currentChallenge = config.challenges[math.random(#config.challenges)]
end

function NumberSequenceRound:checkForWin()
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

function NumberSequenceRound:render()
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

function NumberSequenceRound:name()
    return "number-sequence"
end

function NumberSequenceRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
end

return NumberSequenceRound
