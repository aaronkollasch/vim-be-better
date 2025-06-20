local GameUtils = require("vim-be-better.game-utils")

local instructions = {
    "--- Text Objects Basic ---",
    "",
    "Master basic text objects with operators!",
    "Execute the required operation from the cursor position.",
    "",
    "  iw/aw - inner/a word      i\"/a\" - inner/a quotes",
    "  is/as - inner/a sentence  i(/a( - inner/a parentheses",
    "  ip/ap - inner/a paragraph i{/a{ - inner/a braces",
    "",
    "Remember: operator + text-object (e.g., diw, ci\", vip)",
}

local difficultyConfig = {
    noob = {
        challenges = {
            {
                name = "Delete inner word",
                operation = "diw",
                startText = {
                    "The quick brown fox jumps over the lazy dog",
                    "This is a simple sentence for practice."
                },
                cursorPos = { line = 1, col = 5 },
                expectedResult = {
                    "The  brown fox jumps over the lazy dog",
                    "This is a simple sentence for practice."
                }
            },
            {
                name = "Delete a word (with space)",
                operation = "daw",
                startText = {
                    "hello world test example",
                    "another line here"
                },
                cursorPos = { line = 1, col = 7 },
                expectedResult = {
                    "hello test example",
                    "another line here"
                }
            },
            {
                name = "Change inner word",
                operation = "ciw",
                startText = {
                    "function calculate(x, y) {",
                    "    return x + y;",
                    "}"
                },
                cursorPos = { line = 1, col = 10 },
                expectedResult = {
                    "function (x, y) {",
                    "    return x + y;",
                    "}"
                },
                endsInInsertMode = true
            }
        }
    },

    easy = {
        challenges = {
            {
                name = "Delete content in quotes",
                operation = "di\"",
                startText = {
                    "const message = \"Hello, world!\";",
                    "console.log(message);"
                },
                cursorPos = { line = 1, col = 18 },
                expectedResult = {
                    "const message = \"\";",
                    "console.log(message);"
                }
            },
            {
                name = "Change content in parentheses",
                operation = "ci(",
                startText = {
                    "function test(param1, param2) {",
                    "    return true;",
                    "}"
                },
                cursorPos = { line = 1, col = 20 },
                expectedResult = {
                    "function test() {",
                    "    return true;",
                    "}"
                },
                endsInInsertMode = true
            },
            {
                name = "Delete inner word in code",
                operation = "diw",
                startText = {
                    "local my_variable = 123",
                    "print(my_variable)"
                },
                cursorPos = { line = 1, col = 8 },
                expectedResult = {
                    "local  = 123",
                    "print(my_variable)"
                }
            }
        }
    },

    medium = {
        challenges = {
            {
                name = "Change inner word in variable",
                operation = "ciw",
                startText = {
                    "local old_variable_name = 123",
                    "print(old_variable_name)"
                },
                cursorPos = { line = 1, col = 8 },
                expectedResult = {
                    "local  = 123",
                    "print(old_variable_name)"
                },
                endsInInsertMode = true
            },
            {
                name = "Delete around word",
                operation = "daw",
                startText = {
                    "function test_function() {",
                    "    return calculate(x, y);",
                    "}"
                },
                cursorPos = { line = 2, col = 12 },
                expectedResult = {
                    "function test_function() {",
                    "    return (x, y);",
                    "}"
                }
            },
            {
                name = "Change content in brackets",
                operation = "ci[",
                startText = {
                    "const items = [1, 2, 3, 4];",
                    "console.log(items.length);"
                },
                cursorPos = { line = 1, col = 18 },
                expectedResult = {
                    "const items = [];",
                    "console.log(items.length);"
                },
                endsInInsertMode = true
            }
        }
    },

    hard = {
        challenges = {
            {
                name = "Delete around parentheses (with parens)",
                operation = "da(",
                startText = {
                    "result = calculate(x + y, z * 2);",
                    "print(result);"
                },
                cursorPos = { line = 1, col = 22 },
                expectedResult = {
                    "result = calculate;",
                    "print(result);"
                }
            },
            {
                name = "Change in nested quotes",
                operation = "ci'",
                startText = {
                    "const path = '/usr/local/bin';",
                    "exec(path + '/script.sh');"
                },
                cursorPos = { line = 1, col = 20 },
                expectedResult = {
                    "const path = '';",
                    "exec(path + '/script.sh');"
                },
                endsInInsertMode = true
            },
            {
                name = "Delete around quotes (with quotes)",
                operation = "da\"",
                startText = {
                    "const message = \"Hello, world!\";",
                    "console.log(message);"
                },
                cursorPos = { line = 1, col = 20 },
                expectedResult = {
                    "const message = ;",
                    "console.log(message);"
                }
            }
        }
    },

    nightmare = {
        challenges = {
            {
                name = "Change in deeply nested braces",
                operation = "ci{",
                startText = {
                    "const config = { api: { url: 'localhost', port: 3000 } };",
                    "connect(config.api);"
                },
                cursorPos = { line = 1, col = 35 },
                expectedResult = {
                    "const config = { api: {} };",
                    "connect(config.api);"
                },
                endsInInsertMode = true
            },
            {
                name = "Delete around nested parentheses",
                operation = "da(",
                startText = {
                    "result = func(calc(x, y), process(z));",
                    "return result;"
                },
                cursorPos = { line = 1, col = 20 },
                expectedResult = {
                    "result = func(, process(z));",
                    "return result;"
                }
            },
            {
                name = "Change content in complex structure",
                operation = "ci\"",
                startText = {
                    "vim.cmd('set runtimepath+=~/.config/nvim');",
                    "source_config();"
                },
                cursorPos = { line = 1, col = 25 },
                expectedResult = {
                    "vim.cmd('');",
                    "source_config();"
                },
                endsInInsertMode = true
            }
        }
    },

    tpope = {
        challenges = {
            {
                name = "Master level: nested function calls",
                operation = "ci(",
                startText = {
                    "pcall(vim.schedule_wrap(function() vim.cmd('write') end))",
                    "cleanup_temp_files()"
                },
                cursorPos = { line = 1, col = 45 },
                expectedResult = {
                    "pcall(vim.schedule_wrap())",
                    "cleanup_temp_files()"
                },
                endsInInsertMode = true
            },
            {
                name = "Expert: complex data structure",
                operation = "da{",
                startText = {
                    "M.config = { maps = { ['<C-f>'] = 'Files', ['<C-b>'] = 'Bufs' } }",
                    "apply_config(M.config)"
                },
                cursorPos = { line = 1, col = 35 },
                expectedResult = {
                    "M.config = { maps =  }",
                    "apply_config(M.config)"
                }
            },
            {
                name = "Ultimate: multi-level nesting",
                operation = "ci'",
                startText = {
                    "exec(\"grep -r 'pattern' $(find . -name '*.lua')\");",
                    "process_results();"
                },
                cursorPos = { line = 1, col = 45 },
                expectedResult = {
                    "exec(\"grep -r 'pattern' $(find . -name '')\");",
                    "process_results();"
                },
                endsInInsertMode = true
            },
            {
                name = "Legendary: vim api nightmare",
                operation = "da(",
                startText = {
                    "vim.api.nvim_buf_set_keymap(0, 'n', '<leader>f', '<cmd>Files<CR>', {})",
                    "refresh_mappings()"
                },
                cursorPos = { line = 1, col = 70 },
                expectedResult = {
                    "vim.api.nvim_buf_set_keymap(0, 'n', '<leader>f', , {})",
                    "refresh_mappings()"
                }
            }
        }
    }
}

local TextObjectsBasicRound = {}

function TextObjectsBasicRound:new(difficulty, window)
    local round = {
        window = window,
        difficulty = difficulty or "easy",
        challenge = {},
        startText = {},
        expectedResult = {},
        currentText = {},
        cursorCheckAugroup = nil,
        checkTimer = nil,
        operationExecuted = false,
    }
    self.__index = self
    return setmetatable(round, self)
end

function TextObjectsBasicRound:getInstructions()
    return instructions
end

function TextObjectsBasicRound:getConfig()
    self:generateRound()

    return {
        roundTime = GameUtils.difficultyToTime[self.difficulty] or 25000,
        canEndRound = true,
    }
end

function TextObjectsBasicRound:generateRound()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy

    self.challenge = config.challenges[math.random(#config.challenges)]

    self.startText = vim.deepcopy(self.challenge.startText)
    self.expectedResult = vim.deepcopy(self.challenge.expectedResult)
    self.currentText = vim.deepcopy(self.startText)
end

function TextObjectsBasicRound:render()
    local lines = {}

    for _, line in ipairs(self.currentText) do
        table.insert(lines, line)
    end

    table.insert(lines, "")
    table.insert(lines, string.format("Task: %s", self.challenge.name))
    if self.difficulty == "noob" or self.difficulty == "easy" or self.difficulty == "medium" then
        table.insert(lines, string.format("Operation: %s", self.challenge.operation))
    end

    local targetLineCount = 12
    while #lines < targetLineCount do
        table.insert(lines, "")
    end

    vim.defer_fn(function()
        self:setupOperationMonitoring()
    end, 100)

    local cursorLine = self.challenge.cursorPos.line
    local cursorCol = self.challenge.cursorPos.col - 1

    return lines, cursorLine, cursorCol
end

function TextObjectsBasicRound:setupOperationMonitoring()
    local augroup_name = "TextObjectsBasicCheck_" .. vim.fn.localtime()
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

function TextObjectsBasicRound:cleanupOperationMonitoring()
    if self.cursorCheckAugroup then
        pcall(vim.api.nvim_del_augroup_by_name, self.cursorCheckAugroup)
        self.cursorCheckAugroup = nil
    end

    if self.checkTimer then
        vim.fn.timer_stop(self.checkTimer)
        self.checkTimer = nil
    end
end

function TextObjectsBasicRound:onTextChanged()
    self.operationExecuted = true

    if self.checkTimer then
        vim.fn.timer_stop(self.checkTimer)
    end

    self.checkTimer = vim.fn.timer_start(100, function()
        self:checkForWin()
    end)
end

function TextObjectsBasicRound:onInsertLeave()
    if self.challenge.endsInInsertMode and self.operationExecuted then
        vim.defer_fn(function()
            self:checkForWin()
        end, 50)
    end
end

function TextObjectsBasicRound:checkForWin()
    if not self.operationExecuted then
        return false
    end

    local all_lines = vim.api.nvim_buf_get_lines(self.window.buffer.bufh, 0, -1, false)
    local actual_text = {}

    local start_line = nil
    for i, line in ipairs(all_lines) do
        for j, start_line_text in ipairs(self.startText) do
            if line == start_line_text or line == self.expectedResult[j] then
                start_line = i
                break
            end
        end
        if start_line then break end
    end

    if start_line then
        for i = 1, #self.expectedResult do
            actual_text[i] = all_lines[start_line + i - 1] or ""
        end
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
        self:cleanupOperationMonitoring()

        if self.endRoundCallback then
            self.endRoundCallback(true)
        end
        return true
    end

    return false
end

function TextObjectsBasicRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
end

function TextObjectsBasicRound:name()
    return "text-objects-basic"
end

function TextObjectsBasicRound:close()
    self:cleanupOperationMonitoring()
end

return TextObjectsBasicRound
