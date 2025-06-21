local instructions = {
    "--- Dot Repeat Master ---",
    "",
    "Master the . (dot) command - vim's most powerful repetition tool!",
    "Make one change, then repeat it efficiently across similar contexts.",
    "",
    "  .        - repeat last change",
    "  ciw      - change inner word (repeatable)",
    "  A;       - append semicolon (repeatable)",
    "  r        - replace character (repeatable)",
    "  s        - substitute character (repeatable)",
    "",
    "Goal: Make minimal changes using . to repeat efficiently.",
}

local difficultyConfig = {
    noob = {
        challenges = {
            {
                name = "Replace characters",
                startText = {
                    "vim xs awesome",
                    "practxce makes perfect"
                },
                expectedText = {
                    "vim is awesome",
                    "practice makes perfect"
                },
                cursorPos = { line = 1, col = 7 },
                task = "Replace all 'x' with correct letters",
                operation = "r + correct letter, then . on other x's",
                hint = "Use 'r' to replace first 'x' with 'i', then navigate and use . for others"
            },
            {
                name = "Add missing semicolons",
                startText = {
                    "let a = 1",
                    "let b = 2;",
                    "let c = 3",
                    "let d = 4"
                },
                expectedText = {
                    "let a = 1;",
                    "let b = 2;",
                    "let c = 3;",
                    "let d = 4;"
                },
                cursorPos = { line = 1, col = 9 },
                task = "Add semicolons to lines that need them",
                operation = "A; + <Esc>, then navigate + .",
                hint = "Use A; to add semicolon to first line, then navigate and . for others"
            },
            {
                name = "Change word consistently",
                startText = {
                    "var name = 'John';",
                    "var age = 25;",
                    "var city = 'NYC';"
                },
                expectedText = {
                    "let name = 'John';",
                    "let age = 25;",
                    "let city = 'NYC';"
                },
                cursorPos = { line = 1, col = 1 },
                task = "Change all 'var' to 'let'",
                operation = "ciw + let + <Esc>, then navigate + .",
                hint = "Change first 'var' with ciw, type 'let', then use . on other lines"
            }
        }
    },

    easy = {
        challenges = {
            {
                name = "Surround with quotes",
                startText = {
                    "name: John",
                    "city: NYC",
                    "role: Dev",
                    "team: Frontend"
                },
                expectedText = {
                    "name: 'John'",
                    "city: 'NYC'",
                    "role: 'Dev'",
                    "team: 'Frontend'"
                },
                cursorPos = { line = 1, col = 7 },
                task = "Add quotes around values",
                operation = "ciw + 'word' + <Esc>, then navigate + .",
                hint = "Change first value to quoted version, then repeat with . command"
            },
            {
                name = "Fix inconsistent spacing",
                startText = {
                    "if(condition){",
                    "for(item in list){",
                    "while(running){",
                    "switch(value){"
                },
                expectedText = {
                    "if (condition) {",
                    "for (item in list) {",
                    "while (running) {",
                    "switch (value) {"
                },
                cursorPos = { line = 1, col = 3 },
                task = "Add proper spacing in control structures",
                operation = "Multiple . operations for spacing",
                hint = "Add space after keyword, then space before brace, repeat pattern"
            },
            {
                name = "Convert to constants",
                startText = {
                    "const API_URL = 'https://api.example.com';",
                    "const api_key = 'secret123';",
                    "const max_retries = 3;",
                    "const default_timeout = 5000;"
                },
                expectedText = {
                    "const API_URL = 'https://api.example.com';",
                    "const API_KEY = 'secret123';",
                    "const MAX_RETRIES = 3;",
                    "const DEFAULT_TIMEOUT = 5000;"
                },
                cursorPos = { line = 2, col = 7 },
                task = "Convert snake_case to UPPER_CASE",
                operation = "gUiw for word case conversion + .",
                hint = "Use gUiw to uppercase word, then navigate and repeat with ."
            },
            {
                name = "Add array brackets",
                startText = {
                    "apple",
                    "banana",
                    "cherry",
                    "orange"
                },
                expectedText = {
                    "['apple']",
                    "['banana']",
                    "['cherry']",
                    "['orange']"
                },
                cursorPos = { line = 1, col = 1 },
                task = "Surround each word with array notation",
                operation = "I[' + <Esc> + A'] + <Esc>, then j + .",
                hint = "Add ['  at start and '] at end of first line, then repeat"
            }
        }
    },

    medium = {
        challenges = {
            {
                name = "Refactor function calls",
                startText = {
                    "user.getName()",
                    "user.getAge()",
                    "user.getEmail()",
                    "user.getPhone()"
                },
                expectedText = {
                    "getName(user)",
                    "getAge(user)",
                    "getEmail(user)",
                    "getPhone(user)"
                },
                cursorPos = { line = 1, col = 1 },
                task = "Convert method calls to function calls",
                operation = "Complex change + . repetition",
                hint = "Transform user.getName() to getName(user), then repeat pattern"
            },
            {
                name = "Add error handling",
                startText = {
                    "const data = getData();",
                    "const users = getUsers();",
                    "const posts = getPosts();",
                    "const config = getConfig();"
                },
                expectedText = {
                    "const data = getData() || [];",
                    "const users = getUsers() || [];",
                    "const posts = getPosts() || [];",
                    "const config = getConfig() || {};"
                },
                cursorPos = { line = 1, col = 20 },
                task = "Add fallback values",
                operation = "Add || default, with different defaults",
                hint = "Add || [] for arrays, || {} for objects, use . when possible"
            },
            {
                name = "Format object properties",
                startText = {
                    "name:value",
                    "age:25",
                    "active:true",
                    "role:admin"
                },
                expectedText = {
                    "name: 'value',",
                    "age: 25,",
                    "active: true,",
                    "role: 'admin'"
                },
                cursorPos = { line = 1, col = 5 },
                task = "Format as proper object properties",
                operation = "Multi-step formatting with selective . usage",
                hint = "Add space after colon, quotes for strings, comma at end"
            }
        }
    },

    hard = {
        challenges = {
            {
                name = "Complex code transformation",
                startText = {
                    "if (user && user.isActive) return user.name;",
                    "if (post && post.isPublished) return post.title;",
                    "if (item && item.isAvailable) return item.label;",
                    "if (task && task.isCompleted) return task.description;"
                },
                expectedText = {
                    "return user?.isActive ? user.name : null;",
                    "return post?.isPublished ? post.title : null;",
                    "return item?.isAvailable ? item.label : null;",
                    "return task?.isCompleted ? task.description : null;"
                },
                cursorPos = { line = 1, col = 1 },
                task = "Convert to optional chaining and ternary",
                operation = "Complex refactoring with . repetition",
                hint = "Transform if statement to ternary with optional chaining"
            },
            {
                name = "API endpoint normalization",
                startText = {
                    "GET /api/users/{id}",
                    "POST /api/users",
                    "PUT /api/users/{id}",
                    "DELETE /api/users/{id}"
                },
                expectedText = {
                    "router.get('/api/users/:id', handleGetUser);",
                    "router.post('/api/users', handleCreateUser);",
                    "router.put('/api/users/:id', handleUpdateUser);",
                    "router.delete('/api/users/:id', handleDeleteUser);"
                },
                cursorPos = { line = 1, col = 1 },
                task = "Convert REST endpoints to router definitions",
                operation = "Complex pattern transformation",
                hint = "Transform HTTP method and path to router.method() calls"
            }
        }
    },

    nightmare = {
        challenges = {
            {
                name = "Database query transformation",
                startText = {
                    "SELECT name FROM users WHERE active = 1;",
                    "SELECT title FROM posts WHERE published = 1;",
                    "SELECT label FROM items WHERE available = 1;",
                    "SELECT description FROM tasks WHERE completed = 1;"
                },
                expectedText = {
                    "db.users.find({ active: true }).select('name');",
                    "db.posts.find({ published: true }).select('title');",
                    "db.items.find({ available: true }).select('label');",
                    "db.tasks.find({ completed: true }).select('description');"
                },
                cursorPos = { line = 1, col = 1 },
                task = "Convert SQL to MongoDB queries",
                operation = "Advanced pattern recognition and transformation",
                hint = "Transform SQL SELECT to MongoDB find() with select()"
            }
        }
    },

    tpope = {
        challenges = {
            {
                name = "Master dot command efficiency",
                startText = {
                    "const userValidationSchema = Joi.object({",
                    "  name: Joi.string().required(),",
                    "  email: Joi.string().email().required(),",
                    "  age: Joi.number().min(18).required(),",
                    "  role: Joi.string().valid('user', 'admin').required()",
                    "});"
                },
                expectedText = {
                    "const userValidationSchema = Joi.object({",
                    "  name: Joi.string().required().messages(getErrorMessages('name')),",
                    "  email: Joi.string().email().required().messages(getErrorMessages('email')),",
                    "  age: Joi.number().min(18).required().messages(getErrorMessages('age')),",
                    "  role: Joi.string().valid('user', 'admin').required().messages(getErrorMessages('role'))",
                    "});"
                },
                cursorPos = { line = 2, col = 35 },
                task = "Add error message handlers to schema",
                operation = "Surgical dot command precision",
                hint = "Add .messages(getErrorMessages('field')) to each field efficiently"
            }
        }
    }
}

local DotRepeatRound = {}

function DotRepeatRound:new(difficulty, window)
    local round = {
        window = window,
        difficulty = difficulty or "easy",
        currentChallenge = nil,
        challengeIndex = 1,
    }

    self.__index = self
    return setmetatable(round, self)
end

function DotRepeatRound:getInstructions()
    return instructions
end

function DotRepeatRound:getConfig()
    vim.schedule(function()
        if self.window and self.window.bufh then
            vim.bo[self.window.bufh].modifiable = true
        end
    end)

    self:generateChallenge()

    local timeConfig = {
        noob = 45000,
        easy = 35000,
        medium = 40000,
        hard = 50000,
        nightmare = 60000,
        tpope = 45000
    }

    return {
        roundTime = timeConfig[self.difficulty] or 40000,
        canEndRound = true,
    }
end

function DotRepeatRound:generateChallenge()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy

    self.currentChallenge = config.challenges[math.random(#config.challenges)]
end

function DotRepeatRound:checkForWin()
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
    return matches
end

function DotRepeatRound:render()
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

    if (self.difficulty == "noob" or self.difficulty == "easy") and self.currentChallenge.operation then
        table.insert(lines, "")
        table.insert(lines, "Strategy: " .. self.currentChallenge.operation)
    end

    return lines, cursorLine, cursorCol
end

function DotRepeatRound:name()
    return "dot-repeat"
end

function DotRepeatRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
end

return DotRepeatRound
