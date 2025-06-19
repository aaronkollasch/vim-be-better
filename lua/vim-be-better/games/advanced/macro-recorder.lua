local log = require("vim-be-better.log")

local instructions = {
    "--- Macro Recorder ---",
    "",
    "Master vim macros for automated repetitive tasks!",
    "Record a sequence of commands, then replay to transform data.",
    "",
    "  qa       - start recording macro in register 'a'",
    "  q        - stop recording macro",
    "  @a       - execute macro from register 'a'",
    "  @@       - repeat last executed macro",
    "  3@a      - execute macro 3 times",
    "",
    "Goal: Record macro to transform all data, then execute it.",
}

local difficultyConfig = {
    noob = {
        challenges = {
            {
                name = "Add quotes to words",
                startText = {
                    "apple",
                    "banana",
                    "cherry"
                },
                expectedText = {
                    '"apple"',
                    '"banana"',
                    '"cherry"'
                },
                cursorPos = { line = 1, col = 1 },
                task = "Add quotes around each word",
                macroSteps = "qa + I\" + <Esc> + A\" + <Esc> + j + q",
                execution = "@@, @@",
                hint = "Record: qa, I\", Esc, A\", Esc, j, q. Then execute: @a, @@"
            },
            {
                name = "Add line numbers",
                startText = {
                    "first item",
                    "second item",
                    "third item"
                },
                expectedText = {
                    "1. first item",
                    "2. second item",
                    "3. third item"
                },
                cursorPos = { line = 1, col = 1 },
                task = "Add incremental numbers",
                macroSteps = "qa + I1. + <Esc> + j + q, then modify for 2., 3.",
                execution = "Manual number adjustment + macro",
                hint = "Add '1. ' to first line, then record macro for navigation and adjust numbers"
            },
            {
                name = "Add semicolons",
                startText = {
                    "let a = 1",
                    "let b = 2",
                    "let c = 3"
                },
                expectedText = {
                    "let a = 1;",
                    "let b = 2;",
                    "let c = 3;"
                },
                cursorPos = { line = 1, col = 1 },
                task = "Add semicolons to end of lines",
                macroSteps = "qa + A; + <Esc> + j + q",
                execution = "@a, @@",
                hint = "Record: qa, A;, Esc, j, q. Execute: @a, @@"
            }
        }
    },

    easy = {
        challenges = {
            {
                name = "Surround with brackets",
                startText = {
                    "apple",
                    "banana",
                    "cherry",
                    "orange"
                },
                expectedText = {
                    "[apple]",
                    "[banana]",
                    "[cherry]",
                    "[orange]"
                },
                cursorPos = { line = 1, col = 1 },
                task = "Surround each word with brackets",
                macroSteps = "qa + I[ + <Esc> + A] + <Esc> + j + q",
                execution = "3@a",
                hint = "Record bracket insertion macro, then execute 3 times"
            },
            {
                name = "Convert to assignment",
                startText = {
                    "name",
                    "age",
                    "city",
                    "country"
                },
                expectedText = {
                    "name = '';",
                    "age = '';",
                    "city = '';",
                    "country = '';"
                },
                cursorPos = { line = 1, col = 1 },
                task = "Convert words to empty string assignments",
                macroSteps = "qa + A = ''; + <Esc> + j + q",
                execution = "3@a",
                hint = "Add assignment syntax to first word, then apply to rest"
            },
            {
                name = "Format as array items",
                startText = {
                    "red",
                    "green",
                    "blue",
                    "yellow"
                },
                expectedText = {
                    "'red',",
                    "'green',",
                    "'blue',",
                    "'yellow'"
                },
                cursorPos = { line = 1, col = 1 },
                task = "Format as quoted array items",
                macroSteps = "qa + I' + <Esc> + A', + <Esc> + j + q",
                execution = "Apply to first 3, manually fix last",
                hint = "Add quotes and comma, but remember last item doesn't need comma"
            },
            {
                name = "Transform variable declarations",
                startText = {
                    "var userName = '';",
                    "var userAge = 0;",
                    "var userCity = '';",
                    "var userEmail = '';"
                },
                expectedText = {
                    "const userName = '';",
                    "const userAge = 0;",
                    "const userCity = '';",
                    "const userEmail = '';"
                },
                cursorPos = { line = 1, col = 1 },
                task = "Change var to const",
                macroSteps = "qa + ciw + const + <Esc> + j + q",
                execution = "3@a",
                hint = "Change 'var' word to 'const', then repeat for other lines"
            }
        }
    },

    medium = {
        challenges = {
            {
                name = "Create object properties",
                startText = {
                    "name:You",
                    "role:VIM",
                    "city:NYC",
                    "post:Dev"
                },
                expectedText = {
                    "name: 'You',",
                    "role: '25,",
                    "city: 'NYC',",
                    "post: 'Dev'"
                },
                cursorPos = { line = 1, col = 1 },
                task = "Format as object properties",
                macroSteps = "Complex macro with conditional quotes",
                execution = "Handle different data types",
                hint = "Add spaces after colon, quotes for strings, comma for most lines"
            },
            {
                name = "Extract function parameters",
                startText = {
                    "function getName(user) {",
                    "function getAge(user) {",
                    "function getCity(user) {",
                    "function getRole(user) {"
                },
                expectedText = {
                    "getName,",
                    "getAge,",
                    "getCity,",
                    "getRole"
                },
                cursorPos = { line = 1, col = 1 },
                task = "Extract function names as list",
                macroSteps = "qa + f + space + dw + f( + D + A, + <Esc> + j + q",
                execution = "Extract and format function names",
                hint = "Delete 'function ', delete from '(' to end, add comma"
            },
            {
                name = "Format data table",
                startText = {
                    "id|name|age",
                    "1|John|25",
                    "2|Jane|30",
                    "3|Bob|22"
                },
                expectedText = {
                    "{ id: 'id', name: 'name', age: 'age' },",
                    "{ id: '1', name: 'John', age: '25' },",
                    "{ id: '2', name: 'Jane', age: '30' },",
                    "{ id: '3', name: 'Bob', age: '22' }"
                },
                cursorPos = { line = 1, col = 1 },
                task = "Convert table to object array",
                macroSteps = "Complex transformation macro",
                execution = "Multi-step macro for structured data",
                hint = "Transform pipe-separated data into object notation"
            }
        }
    },

    hard = {
        challenges = {
            {
                name = "Complex code transformation",
                startText = {
                    "if (user.isActive && user.hasPermission) {",
                    "if (data.isValid && data.hasContent) {",
                    "if (item.isEnabled && item.hasValue) {"
                },
                expectedText = {
                    "if (validateUser(user)) {",
                    "if (validateData(data)) {",
                    "if (validateItem(item)) {"
                },
                cursorPos = { line = 1, col = 1 },
                task = "Refactor complex conditions",
                macroSteps = "Advanced find/replace in macro",
                execution = "Extract variable name and create function call",
                hint = "Replace complex condition with validation function call"
            },
            {
                name = "Generate test cases",
                startText = {
                    "getName",
                    "getAge",
                    "getEmail",
                    "getPhone"
                },
                expectedText = {
                    "test('getName should return user name', () => {",
                    "test('getAge should return user age', () => {",
                    "test('getEmail should return user email', () => {",
                    "test('getPhone should return user phone', () => {"
                },
                cursorPos = { line = 1, col = 1 },
                task = "Generate test function templates",
                macroSteps = "Complex macro with text extraction",
                execution = "Transform function names into test templates",
                hint = "Extract function name and create test description"
            }
        }
    },

    nightmare = {
        challenges = {
            {
                name = "Advanced data restructuring",
                startText = {
                    "user_name_john_doe_25_developer",
                    "user_name_jane_smith_30_designer",
                    "user_name_bob_wilson_35_manager"
                },
                expectedText = {
                    "{ name: 'john doe', age: 25, role: 'developer' },",
                    "{ name: 'jane smith', age: 30, role: 'designer' },",
                    "{ name: 'bob wilson', age: 35, role: 'manager' }"
                },
                cursorPos = { line = 1, col = 1 },
                task = "Parse structured strings into objects",
                macroSteps = "Multi-step parsing and formatting",
                execution = "Complex macro with multiple transformations",
                hint = "Extract name, age, role from underscore-separated string"
            }
        }
    },

    tpope = {
        challenges = {
            {
                name = "Master macro composition",
                startText = {
                    "CREATE TABLE users (id INT, name VARCHAR(50), email VARCHAR(100));",
                    "CREATE TABLE posts (id INT, title VARCHAR(200), content TEXT);",
                    "CREATE TABLE comments (id INT, post_id INT, author VARCHAR(50));"
                },
                expectedText = {
                    "interface User { id: number; name: string; email: string; }",
                    "interface Post { id: number; title: string; content: string; }",
                    "interface Comment { id: number; postId: number; author: string; }"
                },
                cursorPos = { line = 1, col = 1 },
                task = "Convert SQL to TypeScript interfaces",
                macroSteps = "Master-level macro programming",
                execution = "Complex SQL to TypeScript transformation",
                hint = "Transform CREATE TABLE statements into TypeScript interface definitions"
            }
        }
    }
}

local MacroRecorderRound = {}

function MacroRecorderRound:new(difficulty, window)
    log.info("MacroRecorderRound:new", difficulty, window)

    local round = {
        window = window,
        difficulty = difficulty or "easy",
        currentChallenge = nil,
        challengeIndex = 1,
    }

    self.__index = self
    return setmetatable(round, self)
end

function MacroRecorderRound:getInstructions()
    return instructions
end

function MacroRecorderRound:getConfig()
    log.info("MacroRecorderRound:getConfig", self.difficulty)

    vim.schedule(function()
        if self.window and self.window.bufh then
            vim.api.nvim_buf_set_option(self.window.bufh, 'modifiable', true)
        end
    end)

    self:generateChallenge()

    local timeConfig = {
        noob = 60000,
        easy = 70000,
        medium = 60000,
        hard = 50000,
        nightmare = 60000,
        tpope = 70000
    }

    return {
        roundTime = timeConfig[self.difficulty] or 45000,
        canEndRound = true,
    }
end

function MacroRecorderRound:generateChallenge()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy

    self.currentChallenge = config.challenges[math.random(#config.challenges)]
    log.info("MacroRecorderRound:generateChallenge", self.currentChallenge.name)
end

function MacroRecorderRound:checkForWin()
    if not self.currentChallenge then
        return false
    end

    local allLines = vim.api.nvim_buf_get_lines(self.window.bufh, 0, -1, false)

    local codeStartLine = 12
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

    log.info("MacroRecorderRound:checkForWin",
        "Expected lines:", #self.currentChallenge.expectedText,
        "Current lines:", #currentCodeLines,
        "Code start line:", codeStartLine,
        "Expected:", vim.inspect(self.currentChallenge.expectedText),
        "Current:", vim.inspect(currentCodeLines),
        "Match:", matches)

    if matches then
        log.info("MacroRecorderRound:checkForWin - SUCCESS! Macro transformation completed")
    end

    return matches
end

function MacroRecorderRound:render()
    if not self.currentChallenge then
        self:generateChallenge()
    end

    local lines = vim.deepcopy(self.currentChallenge.startText)
    local cursorLine = self.currentChallenge.cursorPos.line or 1
    local cursorCol = self.currentChallenge.cursorPos.col or 1

    table.insert(lines, "")
    table.insert(lines, "--- TASK ---")
    table.insert(lines, self.currentChallenge.task)
    table.insert(lines, "")
    table.insert(lines, "--- EXPECTED RESULT ---")

    for _, expectedLine in ipairs(self.currentChallenge.expectedText) do
        table.insert(lines, "| " .. expectedLine)
    end

    table.insert(lines, "")
    table.insert(lines, "--- HINT ---")
    table.insert(lines, self.currentChallenge.hint)

    if (self.difficulty == "noob" or self.difficulty == "easy") and self.currentChallenge.macroSteps then
        table.insert(lines, "")
        table.insert(lines, "Macro: " .. self.currentChallenge.macroSteps)
        table.insert(lines, "Execute: " .. self.currentChallenge.execution)
    end

    log.info("MacroRecorderRound:render",
        "challenge:", self.currentChallenge.name,
        "cursor:", cursorLine, cursorCol,
        "task:", self.currentChallenge.task)

    return lines, cursorLine, cursorCol
end

function MacroRecorderRound:name()
    return "macro-recorder"
end

function MacroRecorderRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
end

return MacroRecorderRound
