local GameUtils = require("vim-be-better.game-utils")
local log = require("vim-be-better.log")

local instructions = {
    "--- Bracket Jump Master ---",
    "",
    "Navigate between brackets, braces, and parentheses!",
    "Start from 'S' and jump to the target '^'.",
    "",
    "  %        - jump between matching brackets/braces/parentheses",
    "  [{, ]}   - jump to previous/next unmatched {",
    "  [(, ])   - jump to previous/next unmatched (",
    "  [[, ]]   - jump between sections",
    "",
    "Master the art of bracket navigation!",
}

local difficultyConfig = {
    noob = {
        motions = { "%" },
        codeTemplates = {
            {
                lines = {
                    "if (condition) {",
                    "    return true;",
                    "}"
                },
                brackets = { { line = 1, col = 4 }, { line = 1, col = 16 }, { line = 3, col = 1 } }
            },
            {
                lines = {
                    "function test() {",
                    "    print('hello');",
                    "}"
                },
                brackets = { { line = 1, col = 16 }, { line = 3, col = 1 } }
            },
            {
                lines = {
                    "const arr = [1, 2, 3];",
                    "print(arr[0]);"
                },
                brackets = { { line = 1, col = 13 }, { line = 1, col = 20 }, { line = 2, col = 6 }, { line = 2, col = 11 } }
            }
        }
    },

    easy = {
        motions = { "%", "[{", "]}" },
        codeTemplates = {
            {
                lines = {
                    "function calc(x, y) {",
                    "    if (x > 0) {",
                    "        return x + y;",
                    "    }",
                    "}"
                },
                brackets = { { line = 1, col = 15 }, { line = 1, col = 20 }, { line = 1, col = 22 }, { line = 2, col = 8 }, { line = 2, col = 14 }, { line = 4, col = 5 }, { line = 5, col = 1 } }
            },
            {
                lines = {
                    "const data = {",
                    "    name: 'test',",
                    "    values: [1, 2]",
                    "};"
                },
                brackets = { { line = 1, col = 14 }, { line = 3, col = 13 }, { line = 3, col = 18 }, { line = 4, col = 1 } }
            },
            {
                lines = {
                    "local opts = { debug = true }",
                    "if opts.debug then",
                    "    print(opts)",
                    "end"
                },
                brackets = { { line = 1, col = 14 }, { line = 1, col = 29 }, { line = 3, col = 11 }, { line = 3, col = 15 } }
            }
        }
    },

    medium = {
        motions = { "%", "[{", "]}", "[(", "])" },
        codeTemplates = {
            {
                lines = {
                    "function setup(opts) {",
                    "    local cfg = extend({",
                    "        enabled = true",
                    "    }, opts or {});",
                    "    return cfg;",
                    "}"
                },
                brackets = { { line = 1, col = 15 }, { line = 1, col = 20 }, { line = 1, col = 22 }, { line = 2, col = 24 }, { line = 4, col = 16 }, { line = 4, col = 17 }, { line = 6, col = 1 } }
            },
            {
                lines = {
                    "if cond then",
                    "    result = calc({",
                    "        x = 10, y = 20",
                    "    });",
                    "end"
                },
                brackets = { { line = 2, col = 19 }, { line = 4, col = 5 }, { line = 4, col = 6 } }
            },
            {
                lines = {
                    "const user = { name: getName() };",
                    "if (user.name) {",
                    "    console.log(user.name);",
                    "}"
                },
                brackets = { { line = 1, col = 14 }, { line = 1, col = 27 }, { line = 1, col = 33 }, { line = 1, col = 34 }, { line = 2, col = 4 }, { line = 2, col = 16 }, { line = 3, col = 17 }, { line = 3, col = 26 }, { line = 4, col = 1 } }
            }
        }
    },

    hard = {
        motions = { "%", "[{", "]}", "[(", "])", "[[", "]]" },
        codeTemplates = {
            {
                lines = {
                    "class Calc {",
                    "    calc(expr) {",
                    "        return eval(expr);",
                    "    }",
                    "}"
                },
                brackets = { { line = 1, col = 12 }, { line = 2, col = 11 }, { line = 2, col = 16 }, { line = 2, col = 17 }, { line = 4, col = 5 }, { line = 5, col = 1 } }
            },
            {
                lines = {
                    "vim.autocmd({'BufRead'}, {",
                    "    callback = function(args)",
                    "        vim.bo[args.buf].ft = 'lua';",
                    "    end",
                    "})"
                },
                brackets = { { line = 1, col = 14 }, { line = 1, col = 23 }, { line = 1, col = 26 }, { line = 2, col = 24 }, { line = 3, col = 15 }, { line = 3, col = 24 }, { line = 5, col = 1 } }
            },
            {
                lines = {
                    "const fn = async (p) => {",
                    "    const data = await get('/api');",
                    "    return data.map((x) => x.id);",
                    "};"
                },
                brackets = { { line = 1, col = 18 }, { line = 1, col = 19 }, { line = 1, col = 26 }, { line = 3, col = 21 }, { line = 3, col = 25 }, { line = 3, col = 31 } }
            }
        }
    },

    nightmare = {
        motions = { "%", "[{", "]}", "[(", "])", "[[", "]]" },
        codeTemplates = {
            {
                lines = {
                    "const fn = (a, b) => {",
                    "    try { return calc(a + b); }",
                    "    catch (e) { return null; }",
                    "};"
                },
                brackets = { { line = 1, col = 12 }, { line = 1, col = 17 }, { line = 1, col = 22 }, { line = 2, col = 9 }, { line = 2, col = 22 }, { line = 2, col = 28 }, { line = 3, col = 11 }, { line = 3, col = 15 }, { line = 3, col = 27 } }
            },
            {
                lines = {
                    "fetch('/api', { method: 'POST' })",
                    ".then((res) => res.json())",
                    ".catch((err) => { throw err; });"
                },
                brackets = { { line = 1, col = 15 }, { line = 1, col = 33 }, { line = 2, col = 7 }, { line = 2, col = 10 }, { line = 2, col = 21 }, { line = 3, col = 8 }, { line = 3, col = 12 }, { line = 3, col = 19 }, { line = 3, col = 28 } }
            },
            {
                lines = {
                    "local M = { setup = function(opts)",
                    "    opts = opts or {}",
                    "    return vim.extend({}, opts)",
                    "end }"
                },
                brackets = { { line = 1, col = 11 }, { line = 1, col = 29 }, { line = 2, col = 19 }, { line = 3, col = 23 }, { line = 3, col = 24 }, { line = 4, col = 5 } }
            }
        }
    },

    tpope = {
        motions = { "%", "[{", "]}", "[(", "])", "[[", "]]" },
        codeTemplates = {
            {
                lines = {
                    "vim.keymap.set('n', '<leader>f', function()",
                    "    vim.cmd('Files')",
                    "end, { desc = 'Find files' })"
                },
                brackets = { { line = 1, col = 42 }, { line = 3, col = 3 }, { line = 3, col = 5 }, { line = 3, col = 29 } }
            },
            {
                lines = {
                    "M.config = { enabled = true, maps = {",
                    "    ['<C-p>'] = function() vim.cmd('Files') end,",
                    "    ['<C-b>'] = function() vim.cmd('Buffers') end",
                    "} }"
                },
                brackets = { { line = 1, col = 12 }, { line = 1, col = 37 }, { line = 2, col = 4 }, { line = 2, col = 14 }, { line = 2, col = 24 }, { line = 2, col = 44 }, { line = 3, col = 4 }, { line = 3, col = 14 }, { line = 3, col = 24 }, { line = 3, col = 46 }, { line = 4, col = 1 }, { line = 4, col = 3 } }
            },
            {
                lines = {
                    "pcall(function() vim.cmd('silent! write') end)",
                    "local ok, err = pcall(vim.cmd, 'source %')",
                    "if not ok then print('Error:', err) end"
                },
                brackets = { { line = 1, col = 6 }, { line = 1, col = 46 }, { line = 2, col = 20 }, { line = 2, col = 41 }, { line = 3, col = 21 }, { line = 3, col = 37 } }
            }
        }
    }
}

local BracketJumpRound = {}

function BracketJumpRound:new(difficulty, window)
    local round = {
        window = window,
        difficulty = difficulty or "easy",
        codeLines = {},
        startPos = {},  -- {line, col}
        targetPos = {}, -- {line, col}
        motion = "",
        cursorCheckAugroup = nil,
    }
    self.__index = self
    return setmetatable(round, self)
end

function BracketJumpRound:getInstructions()
    return instructions
end

function BracketJumpRound:getConfig()
    self:generateRound()

    return {
        roundTime = GameUtils.difficultyToTime[self.difficulty] or 20000,
        canEndRound = true,
    }
end

function BracketJumpRound:generateRound()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy

    local template = config.codeTemplates[math.random(#config.codeTemplates)]
    self.codeLines = vim.deepcopy(template.lines)

    self.motion = config.motions[math.random(#config.motions)]

    local brackets = template.brackets
    local startBracket = brackets[math.random(#brackets)]
    self.startPos = { line = startBracket.line, col = startBracket.col }

    local success = false
    local attempts = 0

    while not success and attempts < 10 do
        attempts = attempts + 1

        local temp_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(temp_buf, 0, -1, false, self.codeLines)

        local win_config = {
            relative = 'editor',
            width = 1,
            height = 1,
            row = vim.o.lines,
            col = vim.o.columns,
            focusable = false,
            style = 'minimal'
        }
        local temp_win = vim.api.nvim_open_win(temp_buf, false, win_config)

        local ok, result = pcall(function()
            vim.api.nvim_win_set_cursor(temp_win, { self.startPos.line, self.startPos.col - 1 })

            vim.api.nvim_set_current_win(temp_win)
            vim.cmd("normal! " .. self.motion)

            local cursor = vim.api.nvim_win_get_cursor(temp_win)
            return { line = cursor[1], col = cursor[2] + 1 }
        end)

        if vim.api.nvim_win_is_valid(temp_win) then
            vim.api.nvim_win_close(temp_win, true)
        end
        if vim.api.nvim_buf_is_valid(temp_buf) then
            vim.api.nvim_buf_delete(temp_buf, { force = true })
        end

        if ok and result and
            (result.line ~= self.startPos.line or result.col ~= self.startPos.col) and
            result.line > 0 and result.line <= #self.codeLines then
            self.targetPos = result
            success = true
        else
            startBracket = brackets[math.random(#brackets)]
            self.startPos = { line = startBracket.line, col = startBracket.col }
        end
    end

    if not success then
        log.warn("BracketJumpRound:generateRound - Using fallback")
        self.codeLines = { "if (true) {", "    return false;", "}" }
        self.motion = "%"
        self.startPos = { line = 1, col = 4 }
        self.targetPos = { line = 3, col = 1 }
    end
end

function BracketJumpRound:render()
    local lines = {}

    for lineNum, codeLine in ipairs(self.codeLines) do
        table.insert(lines, codeLine)

        local indicator = ""
        for col = 1, #codeLine do
            if lineNum == self.startPos.line and col == self.startPos.col then
                indicator = indicator .. "S"
            elseif lineNum == self.targetPos.line and col == self.targetPos.col then
                indicator = indicator .. "^"
            else
                indicator = indicator .. " "
            end
        end
        table.insert(lines, indicator)
    end

    local targetLineCount = 12
    while #lines < targetLineCount do
        table.insert(lines, "")
    end

    vim.defer_fn(function()
        self:setupCursorMonitoring()
    end, 100)

    local cursorLine = self.startPos.line * 2 - 1
    local cursorCol = self.startPos.col - 1

    return lines, cursorLine, cursorCol
end

function BracketJumpRound:setupCursorMonitoring()
    local augroup_name = "BracketJumpCursorCheck_" .. vim.fn.localtime()
    self.cursorCheckAugroup = augroup_name

    vim.api.nvim_create_augroup(augroup_name, { clear = true })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = augroup_name,
        buffer = self.window.buffer.bufh,
        callback = function()
            self:onCursorMoved()
        end
    })
end

function BracketJumpRound:cleanupCursorMonitoring()
    if self.cursorCheckAugroup then
        pcall(vim.api.nvim_del_augroup_by_name, self.cursorCheckAugroup)
        self.cursorCheckAugroup = nil
    end
end

function BracketJumpRound:onCursorMoved()
    if self:checkForWin() then
        self:cleanupCursorMonitoring()

        if self.endRoundCallback then
            self.endRoundCallback(true)
        end
    end
end

function BracketJumpRound:checkForWin()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local current_line = cursor[1]
    local current_col = cursor[2] + 1

    local all_buffer_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local target_absolute_line = nil

    local target_code_line = self.codeLines[self.targetPos.line]
    for i, line in ipairs(all_buffer_lines) do
        if line == target_code_line then
            target_absolute_line = i
            break
        end
    end

    if target_absolute_line and
        current_line == target_absolute_line and
        current_col == self.targetPos.col then
        return true
    end

    return false
end

function BracketJumpRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
end

function BracketJumpRound:name()
    return "bracket-jump"
end

function BracketJumpRound:close()
    self:cleanupCursorMonitoring()
end

return BracketJumpRound
