local GameUtils = require("vim-be-better.game-utils")

local instructions = {
    "--- Indent Master ---",
    "",
    "Fix the indentation using vim indent commands!",
    "Make the code properly formatted.",
    "",
    "  >>  - indent line right      <</  - indent line left",
    "  >j  - indent down one line   <ap - unindent paragraph",
    "  =ap - auto-format paragraph  =i{ - auto-format in braces",
    "",
    "Goal: Make all indentation consistent and correct.",
    "",
}

local difficultyConfig = {
    noob = {
        challenges = {
            {
                name = "Simple line indentation",
                startText = {
                    "function test()",
                    "local x = 1",
                    "return x",
                    "end"
                },
                expectedResult = {
                    "function test()",
                    "    local x = 1",
                    "    return x",
                    "end"
                },
                cursorPos = { line = 2, col = 1 },
                hint = "Use >> to indent the lines inside function"
            },
            {
                name = "Fix over-indented line",
                startText = {
                    "if true then",
                    "        print('hello')",
                    "end"
                },
                expectedResult = {
                    "if true then",
                    "    print('hello')",
                    "end"
                },
                cursorPos = { line = 2, col = 1 },
                hint = "Use << to reduce indentation"
            }
        }
    },

    easy = {
        challenges = {
            {
                name = "Indent multiple lines",
                startText = {
                    "function calculate(a, b)",
                    "local sum = a + b",
                    "local product = a * b",
                    "return sum, product",
                    "end"
                },
                expectedResult = {
                    "function calculate(a, b)",
                    "    local sum = a + b",
                    "    local product = a * b",
                    "    return sum, product",
                    "end"
                },
                cursorPos = { line = 2, col = 1 },
                hint = "Use >3j to indent 3 lines down"
            },
            {
                name = "Mixed indentation fix",
                startText = {
                    "if condition then",
                    "print('true')",
                    "        local x = 1",
                    "    return x",
                    "end"
                },
                expectedResult = {
                    "if condition then",
                    "    print('true')",
                    "    local x = 1",
                    "    return x",
                    "end"
                },
                cursorPos = { line = 2, col = 1 },
                hint = "Fix each line individually with >> and <<"
            }
        }
    },

    medium = {
        challenges = {
            {
                name = "Indent code block",
                startText = {
                    "function process_data()",
                    "for i = 1, 10 do",
                    "if i % 2 == 0 then",
                    "print(i)",
                    "end",
                    "end",
                    "end"
                },
                expectedResult = {
                    "function process_data()",
                    "    for i = 1, 10 do",
                    "        if i % 2 == 0 then",
                    "            print(i)",
                    "        end",
                    "    end",
                    "end"
                },
                cursorPos = { line = 2, col = 1 },
                hint = "Use >i{ to indent inside function braces"
            },
            {
                name = "Auto-format paragraph",
                startText = {
                    "local config = {",
                    "width = 80,",
                    "height = 24,",
                    "title = 'window'",
                    "}"
                },
                expectedResult = {
                    "local config = {",
                    "    width = 80,",
                    "    height = 24,",
                    "    title = 'window'",
                    "}"
                },
                cursorPos = { line = 2, col = 1 },
                hint = "Use =ap to auto-format the paragraph"
            }
        }
    },

    hard = {
        challenges = {
            {
                name = "Complex nested structure",
                startText = {
                    "local function complex()",
                    "if condition then",
                    "for i, v in pairs(table) do",
                    "if v.active then",
                    "process(v)",
                    "end",
                    "end",
                    "end",
                    "end"
                },
                expectedResult = {
                    "local function complex()",
                    "    if condition then",
                    "        for i, v in pairs(table) do",
                    "            if v.active then",
                    "                process(v)",
                    "            end",
                    "        end",
                    "    end",
                    "end"
                },
                cursorPos = { line = 1, col = 1 },
                hint = "Use =G to auto-format from cursor to end"
            }
        }
    },

    nightmare = {
        challenges = {
            {
                name = "JavaScript mixed indentation",
                startText = {
                    "function handleData(data) {",
                    "if (data) {",
                    "const result = data.map(item => {",
                    "return {",
                    "id: item.id,",
                    "name: item.name.trim()",
                    "};",
                    "});",
                    "return result;",
                    "}",
                    "return null;",
                    "}"
                },
                expectedResult = {
                    "function handleData(data) {",
                    "    if (data) {",
                    "        const result = data.map(item => {",
                    "            return {",
                    "                id: item.id,",
                    "                name: item.name.trim()",
                    "            };",
                    "        });",
                    "        return result;",
                    "    }",
                    "    return null;",
                    "}"
                },
                cursorPos = { line = 1, col = 1 },
                hint = "Use gg=G to format entire buffer"
            }
        }
    },

    tpope = {
        challenges = {
            {
                name = "Python complex indentation",
                startText = {
                    "def complex_algorithm(data):",
                    "try:",
                    "for item in data:",
                    "if item.is_valid():",
                    "result = process_item(item)",
                    "if result:",
                    "yield result",
                    "except Exception as e:",
                    "log.error(f'Error: {e}')",
                    "raise",
                    "finally:",
                    "cleanup()"
                },
                expectedResult = {
                    "def complex_algorithm(data):",
                    "    try:",
                    "        for item in data:",
                    "            if item.is_valid():",
                    "                result = process_item(item)",
                    "                if result:",
                    "                    yield result",
                    "    except Exception as e:",
                    "        log.error(f'Error: {e}')",
                    "        raise",
                    "    finally:",
                    "        cleanup()"
                },
                cursorPos = { line = 1, col = 1 },
                hint = "Auto-format the entire function structure"
            }
        }
    }
}

local IndentMasterRound = {}

function IndentMasterRound:new(difficulty, window)
    local round = {
        window = window,
        difficulty = difficulty or "easy",
        currentChallenge = nil,
        challengeIndex = 1,
    }

    self.__index = self
    return setmetatable(round, self)
end

function IndentMasterRound:getInstructions()
    return instructions
end

function IndentMasterRound:getConfig()
    vim.opt.shiftwidth = 4
    vim.opt.tabstop = 4
    vim.opt.expandtab = true

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

function IndentMasterRound:generateChallenge()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy

    self.currentChallenge = config.challenges[math.random(#config.challenges)]
end

function IndentMasterRound:checkForWin()
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

function IndentMasterRound:render()
    if not self.currentChallenge then
        self:generateChallenge()
    end

    local lines = vim.deepcopy(self.currentChallenge.startText)
    local cursorLine = self.currentChallenge.cursorPos.line or 1
    local cursorCol = self.currentChallenge.cursorPos.col or 1

    table.insert(lines, "")
    table.insert(lines, "--- HINT ---")
    table.insert(lines, self.currentChallenge.hint)

    return lines, cursorLine, cursorCol
end

function IndentMasterRound:name()
    return "indent-master"
end

function IndentMasterRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
end

return IndentMasterRound
