local GameUtils = require("vim-be-better.game-utils")

local instructions = {
    "--- Case Converter ---",
    "",
    "Master vim case conversion commands!",
    "Change letter case using vim motions.",
    "",
    "  ~     - toggle case of character    gu + motion - lowercase",
    "  g~    - toggle case with motion     gU + motion - UPPERCASE",
    "  guw   - lowercase word              gUw - UPPERCASE word",
    "  g~ap  - toggle case paragraph       Visual + u/U/~ also work",
    "",
    "Goal: Convert text to the required case format.",
}

local difficultyConfig = {
    noob = {
        challenges = {
            {
                name = "Toggle single character",
                startText = {
                    "hello world",
                    "test example"
                },
                expectedResult = {
                    "Hello world",
                    "test example"
                },
                cursorPos = { line = 1, col = 1 },
                operation = "~",
                hint = "Use ~ to toggle case of character under cursor"
            },
            {
                name = "Lowercase single word",
                startText = {
                    "HELLO world",
                    "test example"
                },
                expectedResult = {
                    "hello world",
                    "test example"
                },
                cursorPos = { line = 1, col = 1 },
                operation = "guw",
                hint = "Use guw to make word lowercase"
            },
            {
                name = "Uppercase single word",
                startText = {
                    "hello WORLD",
                    "test example"
                },
                expectedResult = {
                    "hello WORLD",
                    "test example"
                },
                cursorPos = { line = 1, col = 7 },
                operation = "gUw",
                hint = "Use gUw to make word UPPERCASE"
            }
        }
    },

    easy = {
        challenges = {
            {
                name = "Toggle case multiple characters",
                startText = {
                    "hELLo WoRLd",
                    "test example"
                },
                expectedResult = {
                    "HellO wOrLd",
                    "test example"
                },
                cursorPos = { line = 1, col = 1 },
                operation = "~",
                hint = "Use ~ multiple times or g~w to toggle word case"
            },
            {
                name = "Lowercase with motion",
                startText = {
                    "HELLO BEAUTIFUL WORLD",
                    "test example"
                },
                expectedResult = {
                    "hello beautiful WORLD",
                    "test example"
                },
                cursorPos = { line = 1, col = 1 },
                operation = "gu2w",
                hint = "Use gu2w to lowercase 2 words"
            },
            {
                name = "Uppercase with motion",
                startText = {
                    "hello beautiful world",
                    "test example"
                },
                expectedResult = {
                    "hello BEAUTIFUL WORLD",
                    "test example"
                },
                cursorPos = { line = 1, col = 7 },
                operation = "gU2w",
                hint = "Use gU2w to UPPERCASE 2 words"
            },
            {
                name = "Fix variable name case",
                startText = {
                    "local MY_variable = 123",
                    "print(MY_variable)"
                },
                expectedResult = {
                    "local my_variable = 123",
                    "print(my_variable)"
                },
                cursorPos = { line = 1, col = 7 },
                operation = "guiw",
                hint = "Use guiw to lowercase inner word"
            }
        }
    },

    medium = {
        challenges = {
            {
                name = "Convert camelCase to snake_case",
                startText = {
                    "local myVariableName = 'test'",
                    "print(myVariableName)"
                },
                expectedResult = {
                    "local my_variable_name = 'test'",
                    "print(my_variable_name)"
                },
                cursorPos = { line = 1, col = 7 },
                hint = "Break camelCase and convert to snake_case"
            },
            {
                name = "Fix string case with text objects",
                startText = {
                    "print('HELLO world')",
                    "local msg = 'test'"
                },
                expectedResult = {
                    "print('hello WORLD')",
                    "local msg = 'test'"
                },
                cursorPos = { line = 1, col = 8 },
                hint = "Use text objects to target content inside quotes"
            },
            {
                name = "Toggle paragraph case",
                startText = {
                    "function testFunction()",
                    "  local myVar = 'hello'",
                    "  print(myVar)",
                    "end"
                },
                expectedResult = {
                    "FUNCTION TESTFUNCTION()",
                    "  LOCAL MYVAR = 'HELLO'",
                    "  PRINT(MYVAR)",
                    "END"
                },
                cursorPos = { line = 1, col = 1 },
                hint = "Use motions to convert larger text blocks"
            }
        }
    },

    hard = {
        challenges = {
            {
                name = "Complex variable renaming",
                startText = {
                    "const UserProfileData = {",
                    "  firstName: 'john',",
                    "  lastName: 'DOE',",
                    "  emailAddress: 'JOHN.DOE@EXAMPLE.COM'",
                    "}"
                },
                expectedResult = {
                    "const UserProfileData = {",
                    "  firstName: 'John',",
                    "  lastName: 'Doe',",
                    "  emailAddress: 'john.doe@example.com'",
                    "}"
                },
                cursorPos = { line = 2, col = 15 },
                hint = "Fix case in multiple object values"
            },
            {
                name = "SQL query case fix",
                startText = {
                    "select USER_NAME, email_address",
                    "from USERS",
                    "where STATUS = 'active'"
                },
                expectedResult = {
                    "SELECT user_name, email_address",
                    "FROM users",
                    "WHERE status = 'ACTIVE'"
                },
                cursorPos = { line = 1, col = 1 },
                hint = "Apply different case conventions to SQL keywords vs identifiers"
            }
        }
    },

    nightmare = {
        challenges = {
            {
                name = "Mixed language case conversion",
                startText = {
                    "const API_ENDPOINT = 'https://api.example.com'",
                    "const user_data = await fetchUserData(USER_ID)",
                    "const processedResult = transformData(user_data)"
                },
                expectedResult = {
                    "const api_endpoint = 'https://API.EXAMPLE.COM'",
                    "const userData = await fetchUserData(userId)",
                    "const PROCESSED_RESULT = transformData(userData)"
                },
                cursorPos = { line = 1, col = 7 },
                hint = "Apply different case patterns throughout the code"
            }
        }
    },

    tpope = {
        challenges = {
            {
                name = "Advanced case pattern matching",
                startText = {
                    "type UserProfile = {",
                    "  user_name: string;",
                    "  EMAIL_ADDRESS: string;",
                    "  profile_data: ProfileData;",
                    "  IS_ACTIVE: boolean;",
                    "}"
                },
                expectedResult = {
                    "type UserProfile = {",
                    "  userName: string;",
                    "  emailAddress: string;",
                    "  profileData: ProfileData;",
                    "  isActive: boolean;",
                    "}"
                },
                cursorPos = { line = 2, col = 3 },
                hint = "Convert entire interface to consistent camelCase"
            }
        }
    }
}

local CaseConverterRound = {}

function CaseConverterRound:new(difficulty, window)
    local round = {
        window = window,
        difficulty = difficulty or "easy",
        currentChallenge = nil,
        challengeIndex = 1,
    }

    self.__index = self
    return setmetatable(round, self)
end

function CaseConverterRound:getInstructions()
    return instructions
end

function CaseConverterRound:getConfig()
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

function CaseConverterRound:generateChallenge()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy

    self.currentChallenge = config.challenges[math.random(#config.challenges)]
end

function CaseConverterRound:checkForWin()
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

function CaseConverterRound:render()
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

function CaseConverterRound:name()
    return "case-converter"
end

function CaseConverterRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
end

return CaseConverterRound
