local GameUtils = require("vim-be-better.game-utils")

local instructions = {
    "--- Block Edit Master ---",
    "",
    "Master Visual Block mode (Ctrl-V) for rectangular editing!",
    "Execute the required block operation from the cursor position.",
    "",
    "  Ctrl-V  - enter Visual Block mode",
    "  I       - insert at start of each line in block",
    "  A       - append at end of each line in block",
    "  r       - replace all characters in block",
    "  c/d     - change/delete block",
}

local difficultyConfig = {
    noob = {
        challenges = {
            {
                name = "Add prefix 'my_' to variables",
                startText = {
                    "var1 = 123",
                    "var2 = 456",
                    "var3 = 789"
                },
                expectedResult = {
                    "my_var1 = 123",
                    "my_var2 = 456",
                    "my_var3 = 789"
                },
                cursorPos = { line = 1, col = 1 },
                operation = "Ctrl-V + j + j + I + my_ + Esc"
            },
            {
                name = "Add semicolon (;) to end of lines",
                startText = {
                    "console.log('hello')",
                    "console.log('world')"
                },
                expectedResult = {
                    "console.log('hello');",
                    "console.log('world');"
                },
                cursorPos = { line = 1, col = 20 },
                operation = "Ctrl-V + j + A + ; + Esc"
            },
            {
                name = "Delete first character (\"x\")",
                startText = {
                    "xvar1",
                    "xvar2",
                    "xvar3"
                },
                expectedResult = {
                    "var1",
                    "var2",
                    "var3"
                },
                cursorPos = { line = 1, col = 1 },
                operation = "Ctrl-V + j + j + d"
            }
        }
    },
    easy = {
        challenges = {
            {
                name = "Add 4 spaces indentation",
                startText = {
                    "return x + y;",
                    "return a * b;",
                    "return p - q;"
                },
                expectedResult = {
                    "    return x + y;",
                    "    return a * b;",
                    "    return p - q;"
                },
                cursorPos = { line = 1, col = 1 },
                operation = "Ctrl-V + j + j + I + 4spaces + Esc"
            },
            {
                name = "Replace dots with dashes ('.' -> '-')",
                startText = {
                    "file.txt",
                    "data.json",
                    "conf.yaml"
                },
                expectedResult = {
                    "file-txt",
                    "data-json",
                    "conf-yaml"
                },
                cursorPos = { line = 1, col = 5 },
                operation = "Ctrl-V + j + j + r + -"
            },
            {
                name = "Delete 3 middle characters ('XXX')",
                startText = {
                    "testXXXdata",
                    "itemXXXinfo",
                    "codeXXXfile"
                },
                expectedResult = {
                    "testdata",
                    "iteminfo",
                    "codefile"
                },
                cursorPos = { line = 1, col = 5 },
                operation = "Ctrl-V + j + j + l + l + d"
            }
        }
    },
    medium = {
        challenges = {
            {
                name = "Remove 4-space indentation",
                startText = {
                    "    function test()",
                    "    function demo()",
                    "    function main()"
                },
                expectedResult = {
                    "function test()",
                    "function demo()",
                    "function main()"
                },
                cursorPos = { line = 1, col = 1 },
                operation = "Ctrl-V + j + j + l + l + l + l + d"
            },
            {
                name = "Replace pipes with colons ('|' -> ':')",
                startText = {
                    "name|age|city",
                    "john|25|paris",
                    "anna|30|berlin"
                },
                expectedResult = {
                    "name:age:city",
                    "john:25:paris",
                    "anna:30:berlin"
                },
                cursorPos = { line = 1, col = 5 },
                operation = "Ctrl-V + j + j + r + :"
            },
            {
                name = "Change file extensions ('.txt' -> '.vim')",
                startText = {
                    "doc.txt",
                    "img.jpg",
                    "fun.jsc"
                },
                expectedResult = {
                    "document.vim",
                    "image.vim",
                    "script.vim"
                },
                cursorPos = { line = 1, col = 10 },
                operation = "Ctrl-V + j + j + $ + c + vim + Esc"
            }
        }
    },
    hard = {
        challenges = {
            {
                name = "Add column to CSV (', col')",
                startText = {
                    "name,age,city",
                    "john,25,paris",
                    "anna,30,berlin"
                },
                expectedResult = {
                    "name,age,city,col",
                    "john,25,paris,col",
                    "anna,30,berlin,col"
                },
                cursorPos = { line = 1, col = 13 },
                operation = "Ctrl-V + j + j + A + ,col + Esc"
            },
            {
                name = "Replace variable names (old -> new)",
                startText = {
                    "let oldVar = getValue();",
                    "let oldVar = getFunc();",
                    "let oldVar = getConst();"
                },
                expectedResult = {
                    "let newVar = getValue();",
                    "let newVar = getFunc();",
                    "let newVar = getConst();"
                },
                cursorPos = { line = 1, col = 5 },
                operation = "Ctrl-V + j + j + w + c + newVar + Esc"
            },
            {
                name = "Add leading zeros (00)",
                startText = {
                    "value = 1;",
                    "value = 2;",
                    "value = 3;"
                },
                expectedResult = {
                    "value = 001;",
                    "value = 002;",
                    "value = 003;"
                },
                cursorPos = { line = 1, col = 9 },
                operation = "Ctrl-V + j + j + I + 00 + Esc"
            }
        }
    },
    nightmare = {
        challenges = {
            {
                name = "Refactor method names (old -> new)",
                startText = {
                    "    def oldMethod(self):",
                    "    def oldMethod(self):",
                    "    def oldMethod(self):",
                    "    def oldMethod(self):"
                },
                expectedResult = {
                    "    def newMethod(self):",
                    "    def newMethod(self):",
                    "    def newMethod(self):",
                    "    def newMethod(self):"
                },
                cursorPos = { line = 1, col = 9 },
                operation = "Ctrl-V + j + j + j + w + c + newMethod + Esc"
            },
            {
                name = "Replace table separators",
                startText = {
                    "name    | age | city",
                    "john    | 25  | paris",
                    "anna    | 30  | berlin"
                },
                expectedResult = {
                    "name    : age : city",
                    "john    : 25  : paris",
                    "anna    : 30  : berlin"
                },
                cursorPos = { line = 1, col = 9 },
                operation = "Ctrl-V + j + j + f + | + r + :"
            },
            {
                name = "Add API versioning ('/v2/')",
                startText = {
                    "GET /api/users",
                    "POST /api/data",
                    "PUT /api/config"
                },
                expectedResult = {
                    "GET /api/v2/users",
                    "POST /api/v2/data",
                    "PUT /api/v2/config"
                },
                cursorPos = { line = 1, col = 9 },
                operation = "Ctrl-V + j + j + I + v2/ + Esc"
            }
        }
    },
    tpope = {
        challenges = {
            {
                name = "Ultimate: Lua table key refactor (old -> new)",
                startText = {
                    "local config = { ['oldKey'] = value1,",
                    "                 ['oldKey'] = value2,",
                    "                 ['oldKey'] = value3 }"
                },
                expectedResult = {
                    "local config = { ['newKey'] = value1,",
                    "                 ['newKey'] = value2,",
                    "                 ['newKey'] = value3 }"
                },
                cursorPos = { line = 1, col = 19 },
                operation = "Ctrl-V + j + j + w + c + newKey + Esc"
            },
            {
                name = "Master: Interface alignment (UserData -> BaseEntity)",
                startText = {
                    "interface UserData { id: number;",
                    "interface UserData { id: string;",
                    "interface UserData { id: boolean;"
                },
                expectedResult = {
                    "interface BaseEntity { id: number;",
                    "interface BaseEntity { id: string;",
                    "interface BaseEntity { id: boolean;"
                },
                cursorPos = { line = 1, col = 11 },
                operation = "Ctrl-V + j + j + w + c + BaseEntity + Esc"
            },
            {
                name = "Zen: Variable name refactoring (userConfig -> appSettings)",
                startText = {
                    "const userConfig = settings;",
                    "const userConfig = options;",
                    "const userConfig = params;"
                },
                expectedResult = {
                    "const appSettings = settings;",
                    "const appSettings = options;",
                    "const appSettings = params;"
                },
                cursorPos = { line = 1, col = 7 },
                operation = "Ctrl-V + j + j + w + c + appSettings + Esc"
            }
        }
    }
}
local BlockEditRound = {}

function BlockEditRound:new(difficulty, window)
    local round = {
        window = window,
        difficulty = difficulty or "easy",
        challenge = {},
        startText = {},
        expectedResult = {},
        cursorCheckAugroup = nil,
        checkTimer = nil,
        operationExecuted = false,
    }
    self.__index = self
    return setmetatable(round, self)
end

function BlockEditRound:getInstructions()
    return instructions
end

function BlockEditRound:getConfig()
    self:generateRound()
    return {
        roundTime = GameUtils.difficultyToTime[self.difficulty] or 30000,
        canEndRound = true,
    }
end

function BlockEditRound:generateRound()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy

    self.challenge = config.challenges[math.random(#config.challenges)]
    self.startText = vim.deepcopy(self.challenge.startText)
    self.expectedResult = vim.deepcopy(self.challenge.expectedResult)
end

function BlockEditRound:render()
    local lines = {}

    for _, line in ipairs(self.startText) do
        table.insert(lines, line)
    end

    table.insert(lines, "")
    table.insert(lines, string.format("Task: %s", self.challenge.name))

    if self.difficulty == "noob" or self.difficulty == "easy" then
        table.insert(lines, string.format("Operation: %s", self.challenge.operation))
    end

    local cursorLine = self.challenge.cursorPos.line
    local cursorCol = self.challenge.cursorPos.col - 1

    vim.defer_fn(function()
        self:setupOperationMonitoring()
    end, 100)

    return lines, cursorLine, cursorCol
end

function BlockEditRound:setupOperationMonitoring()
    local augroup_name = "BlockEditCheck_" .. vim.fn.localtime()
    self.cursorCheckAugroup = augroup_name

    vim.api.nvim_create_augroup(augroup_name, { clear = true })

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        group = augroup_name,
        buffer = self.window.buffer.bufh,
        callback = function()
            self:onTextChanged()
        end
    })

    vim.api.nvim_create_autocmd({ "InsertLeave" }, {
        group = augroup_name,
        buffer = self.window.buffer.bufh,
        callback = function()
            self:onInsertLeave()
        end
    })
end

function BlockEditRound:onTextChanged()
    self.operationExecuted = true

    if self.checkTimer then
        vim.fn.timer_stop(self.checkTimer)
    end

    self.checkTimer = vim.fn.timer_start(300, function()
        if self:checkForWin() then
            self:cleanupOperationMonitoring()

            if self.endRoundCallback then
                self.endRoundCallback(true)
            end
        end
    end)
end

function BlockEditRound:onInsertLeave()
    if self.operationExecuted then
        vim.defer_fn(function()
            if self:checkForWin() then
                self:cleanupOperationMonitoring()

                if self.endRoundCallback then
                    self.endRoundCallback(true)
                end
            end
        end, 100)
    end
end

function BlockEditRound:checkForWin()
    if not self.operationExecuted then
        return false
    end

    local all_lines = self.window.buffer:getGameLines()
    local actual_text = {}
    local found_start = false
    local start_idx = 1

    for i, line in ipairs(all_lines) do
        if line == self.startText[1] or line == self.expectedResult[1] then
            start_idx = i
            found_start = true
            break
        end
    end

    if not found_start then
        return false
    end

    for i = 1, #self.expectedResult do
        actual_text[i] = all_lines[start_idx + i - 1] or ""
    end

    local matches = true
    if #actual_text == #self.expectedResult then
        for i = 1, #self.expectedResult do
            if actual_text[i] ~= self.expectedResult[i] then
                matches = false
                break
            end
        end
    else
        matches = false
    end

    if matches then
        return true
    end

    return false
end

function BlockEditRound:cleanupOperationMonitoring()
    if self.cursorCheckAugroup then
        pcall(vim.api.nvim_del_augroup_by_name, self.cursorCheckAugroup)
        self.cursorCheckAugroup = nil
    end

    if self.checkTimer then
        vim.fn.timer_stop(self.checkTimer)
        self.checkTimer = nil
    end
end

function BlockEditRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
end

function BlockEditRound:name()
    return "block-edit"
end

function BlockEditRound:close()
    self:cleanupOperationMonitoring()
end

return BlockEditRound
