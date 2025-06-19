local GameUtils = require("vim-be-better.game-utils")
local log = require("vim-be-better.log")

local instructions = {
    "--- Substitution Master ---",
    "",
    "Learn Vim's powerful search and replace!",
    "Execute the required substitution command.",
    "",
    "  :%s/old/new/g    - replace all occurrences",
    "  :s/old/new/      - replace first in current line",
    "  :%s/old/new/gc   - replace with confirmation",
    "  :%s/pattern//g   - delete all matches",
}

local difficultyConfig = {
    noob = {
        challenges = {
            {
                name = "Replace 'old' with 'new'",
                startText = {
                    "This is old text with old values",
                    "The old system needs old updates"
                },
                expectedResult = {
                    "This is new text with new values",
                    "The new system needs new updates"
                },
                command = ":%s/old/new/g"
            },
            {
                name = "Delete all 'TODO' comments",
                startText = {
                    "function test() {",
                    "    // TODO: implement this",
                    "    // TODO: fix bug here",
                    "    return true;",
                    "}"
                },
                expectedResult = {
                    "function test() {",
                    "    // : implement this",
                    "    // : fix bug here",
                    "    return true;",
                    "}"
                },
                command = ":%s/TODO//g"
            },
            {
                name = "Replace dots with dashes",
                startText = {
                    "file.name.txt",
                    "my.config.json",
                    "app.settings.yaml"
                },
                expectedResult = {
                    "file-name-txt",
                    "my-config-json",
                    "app-settings-yaml"
                },
                command = ":%s/\\./\\-/g"
            }
        }
    },
    easy = {
        challenges = {
            {
                name = "Replace 'var' with 'let' (case sensitive)",
                startText = {
                    "var name = 'John';",
                    "var age = 25;",
                    "Variable = 'test';"
                },
                expectedResult = {
                    "let name = 'John';",
                    "let age = 25;",
                    "Variable = 'test';"
                },
                command = ":%s/var/let/g"
            },
            {
                name = "Remove all numbers",
                startText = {
                    "version 1.2.3 released",
                    "port 8080 is open",
                    "count = 42 items"
                },
                expectedResult = {
                    "version .. released",
                    "port  is open",
                    "count =  items"
                },
                command = ":%s/[0-9]//g"
            },
            {
                name = "Replace underscores with spaces",
                startText = {
                    "user_name = get_user_data()",
                    "file_path = '/tmp/test_file'"
                },
                expectedResult = {
                    "user name = get user data()",
                    "file path = '/tmp/test file'"
                },
                command = ":%s/_/ /g"
            }
        }
    },
    medium = {
        challenges = {
            {
                name = "Replace whole words only",
                startText = {
                    "The cat catches cats in the category",
                    "concatenate and catch the cat"
                },
                expectedResult = {
                    "The dog catches cats in the category",
                    "concatenate and catch the dog"
                },
                command = ":%s/\\<cat\\>/dog/g"
            },
            {
                name = "Change email domains",
                startText = {
                    "Contact: john@old.com",
                    "Email: mary@old.com",
                    "Info: info@old.com"
                },
                expectedResult = {
                    "Contact: john@new.com",
                    "Email: mary@new.com",
                    "Info: info@new.com"
                },
                command = ":%s/@old\\.com/@new.com/g"
            },
            {
                name = "Remove trailing spaces",
                startText = {
                    "line with spaces   ",
                    "another line  ",
                    "clean line"
                },
                expectedResult = {
                    "line with spaces",
                    "another line",
                    "clean line"
                },
                command = ":%s/\\s\\+$//g"
            }
        }
    },
    hard = {
        challenges = {
            {
                name = "Add quotes around words",
                startText = {
                    "name age city",
                    "john mary alice"
                },
                expectedResult = {
                    "'name' 'age' 'city'",
                    "'john' 'mary' 'alice'"
                },
                command = ":%s/\\w\\+/'&'/g"
            },
            {
                name = "Swap two words",
                startText = {
                    "hello world test",
                    "world hello again"
                },
                expectedResult = {
                    "world hello test",
                    "hello world again"
                },
                command = ":%s/\\(hello\\)\\s\\+\\(world\\)/\\2 \\1/g"
            },
            {
                name = "Convert snake_case to camelCase",
                startText = {
                    "user_name = get_user_data()",
                    "file_path = read_config_file()"
                },
                expectedResult = {
                    "userName = getUserData()",
                    "filePath = readConfigFile()"
                },
                command = ":%s/_\\([a-z]\\)/\\u\\1/g"
            }
        }
    },
    nightmare = {
        challenges = {
            {
                name = "Complex regex replacement",
                startText = {
                    "function getUserData() {",
                    "function getFileInfo() {",
                    "function getApiResponse() {"
                },
                expectedResult = {
                    "async function getUserData() {",
                    "async function getFileInfo() {",
                    "async function getApiResponse() {"
                },
                command = ":%s/function \\(get\\w\\+\\)/async function \\1/g"
            },
            {
                name = "Format phone numbers",
                startText = {
                    "Phone: 1234567890",
                    "Mobile: 9876543210",
                    "Work: 5555551234"
                },
                expectedResult = {
                    "Phone: (123) 456-7890",
                    "Mobile: (987) 654-3210",
                    "Work: (555) 555-1234"
                },
                command = ":%s/\\([0-9]\\{3\\}\\)\\([0-9]\\{3\\}\\)\\([0-9]\\{4\\}\\)/(\\1) \\2-\\3/g"
            },
            {
                name = "Restructure object notation",
                startText = {
                    "obj.property.value",
                    "user.name.first",
                    "config.api.url"
                },
                expectedResult = {
                    "obj['property']['value']",
                    "user['name']['first']",
                    "config['api']['url']"
                },
                command = ":%s/\\.\\([a-zA-Z_]\\w*\\)/['\\1']/g"
            }
        }
    },
    tpope = {
        challenges = {
            {
                name = "Ultimate: Multi-pattern replacement",
                startText = {
                    "const oldVar = require('old-module');",
                    "const oldFunc = require('old-utils');",
                    "const oldConst = require('old-config');"
                },
                expectedResult = {
                    "import oldVar from 'new-module';",
                    "import oldFunc from 'new-utils';",
                    "import oldConst from 'new-config';"
                },
                command = ":%s/const \\(\\w\\+\\) = require('\\([^']*\\)')/import \\1 from '\\2'/g | %s/old-/new-/g"
            },
            {
                name = "Master: Complex data transformation",
                startText = {
                    "users: [{id: 1, name: 'John'}, {id: 2, name: 'Jane'}]",
                    "items: [{id: 3, title: 'Book'}, {id: 4, title: 'Pen'}]"
                },
                expectedResult = {
                    "users: [{'id': 1, 'name': 'John'}, {'id': 2, 'name': 'Jane'}]",
                    "items: [{'id': 3, 'title': 'Book'}, {'id': 4, 'title': 'Pen'}]"
                },
                command = ":%s/\\([a-zA-Z_]\\w*\\):/'\1':/g"
            },
            {
                name = "Zen: Advanced function signature",
                startText = {
                    "function processData(input, options, callback) {",
                    "function validateInput(data, rules, strict) {",
                    "function formatOutput(result, format, encoding) {"
                },
                expectedResult = {
                    "function processData(input: any, options: object, callback: Function) {",
                    "function validateInput(data: any, rules: object, strict: boolean) {",
                    "function formatOutput(result: any, format: string, encoding: string) {"
                },
                command =
                ":%s/\\(\\w\\+\\)\\([,)]\\)/\\1: any\\2/g | %s/options: any/options: object/g | %s/callback: any/callback: Function/g"
            }
        }
    }
}

local SubstitutionBasicRound = {}

function SubstitutionBasicRound:new(difficulty, window)
    log.info("SubstitutionBasicRound:new", difficulty, window)

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

function SubstitutionBasicRound:getInstructions()
    return instructions
end

function SubstitutionBasicRound:getConfig()
    log.info("SubstitutionBasicRound:getConfig", self.difficulty)
    self:generateRound()
    return {
        roundTime = GameUtils.difficultyToTime[self.difficulty] or 30000,
        canEndRound = true,
    }
end

function SubstitutionBasicRound:generateRound()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy

    self.challenge = config.challenges[math.random(#config.challenges)]
    self.startText = vim.deepcopy(self.challenge.startText)
    self.expectedResult = vim.deepcopy(self.challenge.expectedResult)

    log.info("SubstitutionBasicRound:generateRound",
        "DIFFICULTY:", difficultyKey,
        "CHALLENGE:", self.challenge.name,
        "START TEXT:", vim.inspect(self.startText),
        "EXPECTED:", vim.inspect(self.expectedResult),
        "COMMAND:", self.challenge.command)
end

function SubstitutionBasicRound:render()
    local lines = {}

    for _, line in ipairs(self.startText) do
        table.insert(lines, line)
    end

    table.insert(lines, "")
    table.insert(lines, string.format("Task: %s", self.challenge.name))

    if self.difficulty == "noob" or self.difficulty == "easy" then
        table.insert(lines, string.format("Command: %s", self.challenge.command))
    end

    log.info("SubstitutionBasicRound:render",
        "RENDERED_LINES:", vim.inspect(lines))

    vim.defer_fn(function()
        self:setupOperationMonitoring()
    end, 100)

    return lines, 1, 0
end

function SubstitutionBasicRound:setupOperationMonitoring()
    local augroup_name = "SubstitutionBasicCheck_" .. vim.fn.localtime()
    self.cursorCheckAugroup = augroup_name

    vim.api.nvim_create_augroup(augroup_name, { clear = true })

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        group = augroup_name,
        buffer = self.window.buffer.bufh,
        callback = function()
            self:onTextChanged()
        end
    })

    vim.api.nvim_create_autocmd({ "CmdlineLeave" }, {
        group = augroup_name,
        callback = function()
            self:onCommandExecuted()
        end
    })

    log.info("SubstitutionBasicRound:setupOperationMonitoring - Created augroup:", augroup_name)
end

function SubstitutionBasicRound:onTextChanged()
    log.info("SubstitutionBasicRound:onTextChanged - Text changed!")
    self.operationExecuted = true

    if self.checkTimer then
        vim.fn.timer_stop(self.checkTimer)
    end

    self.checkTimer = vim.fn.timer_start(300, function()
        if self:checkForWin() then
            log.info("SubstitutionBasicRound:onTextChanged - PLAYER WON!")
            self:cleanupOperationMonitoring()

            if self.endRoundCallback then
                self.endRoundCallback(true)
            end
        end
    end)
end

function SubstitutionBasicRound:onCommandExecuted()
    log.info("SubstitutionBasicRound:onCommandExecuted - Command executed!")
    self.operationExecuted = true

    vim.defer_fn(function()
        if self:checkForWin() then
            log.info("SubstitutionBasicRound:onCommandExecuted - PLAYER WON!")
            self:cleanupOperationMonitoring()

            if self.endRoundCallback then
                self.endRoundCallback(true)
            end
        end
    end, 100)
end

function SubstitutionBasicRound:checkForWin()
    if not self.operationExecuted then
        log.info("SubstitutionBasicRound:checkForWin - No operation executed yet")
        return false
    end

    local all_lines = self.window.buffer:getGameLines()

    log.info("SubstitutionBasicRound:checkForWin",
        "ALL_GAME_LINES:", vim.inspect(all_lines),
        "EXPECTED_RESULT:", vim.inspect(self.expectedResult))

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
        log.info("SubstitutionBasicRound:checkForWin - Could not find start of text")
        return false
    end

    for i = 1, #self.expectedResult do
        actual_text[i] = all_lines[start_idx + i - 1] or ""
    end

    log.info("SubstitutionBasicRound:checkForWin",
        "START_IDX:", start_idx,
        "ACTUAL_TEXT:", vim.inspect(actual_text),
        "EXPECTED_TEXT:", vim.inspect(self.expectedResult))

    local matches = true
    if #actual_text == #self.expectedResult then
        for i = 1, #self.expectedResult do
            if actual_text[i] ~= self.expectedResult[i] then
                log.info("SubstitutionBasicRound:checkForWin - Mismatch at line", i,
                    "Expected:", self.expectedResult[i],
                    "Actual:", actual_text[i])
                matches = false
                break
            end
        end
    else
        log.info("SubstitutionBasicRound:checkForWin - Length mismatch",
            "Expected length:", #self.expectedResult,
            "Actual length:", #actual_text)
        matches = false
    end

    if matches then
        log.info("*** SUBSTITUTION BASIC LEVEL COMPLETED! ***")
        return true
    end

    return false
end

function SubstitutionBasicRound:cleanupOperationMonitoring()
    if self.cursorCheckAugroup then
        pcall(vim.api.nvim_del_augroup_by_name, self.cursorCheckAugroup)
        log.info("SubstitutionBasicRound:cleanupOperationMonitoring - Removed augroup:", self.cursorCheckAugroup)
        self.cursorCheckAugroup = nil
    end

    if self.checkTimer then
        vim.fn.timer_stop(self.checkTimer)
        self.checkTimer = nil
    end
end

function SubstitutionBasicRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
end

function SubstitutionBasicRound:name()
    return "substitution-basic"
end

function SubstitutionBasicRound:close()
    self:cleanupOperationMonitoring()
end

return SubstitutionBasicRound
