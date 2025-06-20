local instructions = {
    "--- Regex Master ---",
    "",
    "Master Vim's powerful regex patterns!",
    "Use search commands to find the target pattern.",
    "",
    "  /pattern     - search forward for pattern",
    "  ?pattern     - search backward for pattern",
    "  n/N          - next/previous match",
    "",
    "Find the match marked with '^', ignore others marked with '·'",
}

local difficultyConfig = {
    noob = {
        challenges = {
            {
                name = "Find any digit",
                pattern = "\\d",
                description = "Find any single digit (0-9)",
                textLines = {
                    "The year 2023 was great",
                    "I have 5 apples"
                }
            },
            {
                name = "Find any letter",
                pattern = "[a-z]",
                description = "Find any lowercase letter",
                textLines = {
                    "Hello World 123",
                    "TEST example"
                }
            },
            {
                name = "Find word start",
                pattern = "\\<the",
                description = "Find word 'the' at word boundary",
                textLines = {
                    "the quick brown fox",
                    "in the house"
                }
            }
        }
    },
    easy = {
        challenges = {
            {
                name = "Find whole words",
                pattern = "\\<cat\\>",
                description = "Find whole word 'cat' only",
                textLines = {
                    "The cat sat on mat",
                    "Category has cats"
                }
            },
            {
                name = "Find line endings",
                pattern = ";$",
                description = "Find semicolon at end of line",
                textLines = {
                    "let x = 5;",
                    "let y = 10",
                    "return x + y;"
                }
            },
            {
                name = "Find simple emails",
                pattern = "\\w\\+@\\w\\+",
                description = "Find simple email pattern",
                textLines = {
                    "Contact: john@company",
                    "Email me at test@example"
                }
            }
        }
    },
    medium = {
        challenges = {
            {
                name = "Find function names",
                pattern = "function \\w\\+",
                description = "Find function declarations",
                textLines = {
                    "function getData() {",
                    "const func = () => {};",
                    "function processItem(x) {"
                }
            },
            {
                name = "Find hex colors",
                pattern = "#[0-9a-f]\\{3,6\\}",
                description = "Find 3-6 digit hex colors",
                textLines = {
                    "color: #fff;",
                    "background: #ff0000;",
                    "border: #123abc;"
                }
            },
            {
                name = "Find quoted strings",
                pattern = "'[^']*'",
                description = "Find single-quoted strings",
                textLines = {
                    "name = 'John Doe';",
                    "title = 'Engineer';",
                    "const msg = 'Hello';"
                }
            }
        }
    },
    hard = {
        challenges = {
            {
                name = "Find email addresses",
                pattern = "[a-zA-Z0-9._%+-]\\+@[a-zA-Z0-9.-]\\+\\.[a-zA-Z]\\{2,\\}",
                description = "Find complete email addresses",
                textLines = {
                    "Contact: user.name@example.com",
                    "Send to: test123@sub.domain.org",
                    "Invalid: @badmail"
                }
            },
            {
                name = "Find URLs",
                pattern = "https\\?://[a-zA-Z0-9.-]\\+",
                description = "Find HTTP/HTTPS URLs",
                textLines = {
                    "Visit https://www.example.com",
                    "API: http://api.service.org",
                    "Link: https://docs.github.com"
                }
            },
            {
                name = "Find IP addresses",
                pattern = "\\([0-9]\\{1,3\\}\\.\\)\\{3\\}[0-9]\\{1,3\\}",
                description = "Find IPv4 addresses",
                textLines = {
                    "Server: 192.168.1.100",
                    "DNS: 8.8.8.8",
                    "Gateway: 10.0.0.1"
                }
            }
        }
    },
    nightmare = {
        challenges = {
            {
                name = "Find function calls with params",
                pattern = "\\w\\+(.*)",
                description = "Find function calls with parameters",
                textLines = {
                    "result = calculate(x, y);",
                    "console.log('message');",
                    "fetch(url, options);"
                }
            },
            {
                name = "Find complex URLs with query",
                pattern = "https\\?://[^\\s]\\+\\?[a-zA-Z0-9=&_-]\\+",
                description = "Find URLs with query parameters",
                textLines = {
                    "API: https://api.example.com/users?id=123",
                    "Search: http://site.org/search?q=vim&type=help",
                    "Data: https://service.com/data?limit=10"
                }
            },
            {
                name = "Find nested brackets",
                pattern = "\\[[^\\]]*\\[[^\\]]*\\]",
                description = "Find nested square brackets",
                textLines = {
                    "arr[items[0]] = value;",
                    "matrix[row[i]][col] = data;",
                    "config[settings[key]] = result;"
                }
            }
        }
    },
    tpope = {
        challenges = {
            {
                name = "Find Vim modeline",
                pattern = "vim:\\s*set\\s\\+\\w\\+",
                description = "Find Vim modeline settings",
                textLines = {
                    "// vim: set expandtab:",
                    "/* vim: set tabstop=4: */",
                    "# vim: set noexpandtab:"
                }
            },
            {
                name = "Find complex function declarations",
                pattern = "\\v(function|const|let)\\s+\\w+\\s*[=(]",
                description = "Find various function declarations",
                textLines = {
                    "function myFunc() {",
                    "const arrow = () => {};",
                    "let callback = function() {};"
                }
            },
            {
                name = "Find advanced email validation",
                pattern = "\\v[a-zA-Z0-9._%+-]+\\@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}",
                description = "Find RFC-compliant email addresses",
                textLines = {
                    "Valid: user.name+tag@sub.example.co.uk",
                    "Invalid: user@.com",
                    "Good: test_123@domain.org"
                }
            }
        }
    }
}
local RegexMasterRound = {}

function RegexMasterRound:new(difficulty, window)
    local round = {
        window = window,
        difficulty = difficulty or "easy",
        challenge = {},
        textLines = {},
        correctTarget = {},
        cursorCheckAugroup = nil,
    }
    self.__index = self
    return setmetatable(round, self)
end

function RegexMasterRound:getInstructions()
    return instructions
end

function RegexMasterRound:getConfig()
    self:generateRound()

    -- longer time for regex challenges than any other rounds
    local timeConfig = {
        noob = 120000,
        easy = 45000,
        medium = 50000,
        hard = 60000,
        nightmare = 60000,
        tpope = 60000
    }

    return {
        roundTime = timeConfig[self.difficulty] or 30000,
        canEndRound = true,
    }
end

function RegexMasterRound:generateRound()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy

    self.challenge = config.challenges[math.random(#config.challenges)]
    self.textLines = vim.deepcopy(self.challenge.textLines)

    local allMatches = {}
    for lineNum, line in ipairs(self.textLines) do
        local matches = self:findPatternMatches(line, self.challenge.pattern, lineNum)
        for _, match in ipairs(matches) do
            table.insert(allMatches, match)
        end
    end

    if #allMatches > 0 then
        self.correctTarget = allMatches[math.random(#allMatches)]
    else
        self.correctTarget = { line = 1, startCol = 1, endCol = 1 }
    end
end

function RegexMasterRound:findPatternMatches(line, pattern, lineNum)
    local matches = {}

    if pattern == "\\d" then
        for i = 1, #line do
            local char = string.sub(line, i, i)
            if char:match("%d") then
                table.insert(matches, { line = lineNum, startCol = i, endCol = i, text = char })
            end
        end
    elseif pattern == "[a-z]" then
        for i = 1, #line do
            local char = string.sub(line, i, i)
            if char:match("%l") then
                table.insert(matches, { line = lineNum, startCol = i, endCol = i, text = char })
            end
        end
    elseif pattern == "\\<the" or pattern == "\\<cat\\>" then
        local word = pattern:gsub("\\<", ""):gsub("\\>", "")
        local start = 1
        while true do
            local match_start, match_end = line:find("%f[%w]" .. word .. "%f[%W]", start)
            if not match_start then break end
            table.insert(matches, {
                line = lineNum,
                startCol = match_start,
                endCol = match_end,
                text = line:sub(match_start, match_end)
            })
            start = match_end + 1
        end
    elseif pattern == ";$" then
        if line:match(";%s*$") then
            local pos = line:find(";[%s]*$")
            if pos then
                table.insert(matches, { line = lineNum, startCol = pos, endCol = pos, text = ";" })
            end
        end
    elseif pattern == "\\w\\+@\\w\\+" then
        local start = 1
        while true do
            local match_start, match_end = line:find("%w+@%w+", start)
            if not match_start then break end
            table.insert(matches, {
                line = lineNum,
                startCol = match_start,
                endCol = match_end,
                text = line:sub(match_start, match_end)
            })
            start = match_end + 1
        end
    elseif pattern == "function \\w\\+" then
        local start = 1
        while true do
            local match_start, match_end = line:find("function%s+%w+", start)
            if not match_start then break end
            table.insert(matches, {
                line = lineNum,
                startCol = match_start,
                endCol = match_end,
                text = line:sub(match_start, match_end)
            })
            start = match_end + 1
        end
    elseif pattern == "#[0-9a-f]\\{3,6\\}" then
        local start = 1
        while true do
            local match_start, match_end = line:find(
                "#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]?[0-9a-fA-F]?[0-9a-fA-F]?", start)
            if not match_start then break end
            table.insert(matches, {
                line = lineNum,
                startCol = match_start,
                endCol = match_end,
                text = line:sub(match_start, match_end)
            })
            start = match_end + 1
        end
    elseif pattern == "'[^']*'" then
        local start = 1
        while true do
            local match_start, match_end = line:find("'[^']*'", start)
            if not match_start then break end
            table.insert(matches, {
                line = lineNum,
                startCol = match_start,
                endCol = match_end,
                text = line:sub(match_start, match_end)
            })
            start = match_end + 1
        end
    elseif pattern:find("@.*%.") then
        local start = 1
        while true do
            local match_start, match_end = line:find("[%w%.%_%+%-]+@[%w%.%-]+%.[%a][%a]+", start)
            if not match_start then break end
            table.insert(matches, {
                line = lineNum,
                startCol = match_start,
                endCol = match_end,
                text = line:sub(match_start, match_end)
            })
            start = match_end + 1
        end
    else
        local start = 1
        while true do
            local match_start, match_end = line:find("%w+", start)
            if not match_start then break end
            table.insert(matches, {
                line = lineNum,
                startCol = match_start,
                endCol = match_end,
                text = line:sub(match_start, match_end)
            })
            start = match_end + 1
        end
    end

    return matches
end

function RegexMasterRound:findAllMatches()
    local allMatches = {}
    for lineNum, line in ipairs(self.textLines) do
        local matches = self:findPatternMatches(line, self.challenge.pattern, lineNum)
        for _, match in ipairs(matches) do
            table.insert(allMatches, match)
        end
    end
    return allMatches
end

function RegexMasterRound:addExampleMatch()
    table.insert(self.textLines, "example123@test.com")
end

function RegexMasterRound:render()
    local lines = {}

    local allMatches = {}
    for lineNum, textLine in ipairs(self.textLines) do
        table.insert(lines, textLine)

        local matches = self:findPatternMatches(textLine, self.challenge.pattern, lineNum)
        for _, match in ipairs(matches) do
            table.insert(allMatches, match)
        end

        local indicator = string.rep(" ", #textLine)

        for _, match in ipairs(matches) do
            local isTarget = (lineNum == self.correctTarget.line and
                match.startCol == self.correctTarget.startCol)

            for col = match.startCol, match.endCol do
                if col <= #indicator then
                    if isTarget then
                        indicator = indicator:sub(1, col - 1) .. "^" .. indicator:sub(col + 1)
                    else
                        indicator = indicator:sub(1, col - 1) .. "·" .. indicator:sub(col + 1)
                    end
                end
            end
        end

        table.insert(lines, indicator)
    end

    table.insert(lines, "")
    table.insert(lines, string.format("Task: %s", self.challenge.name))
    table.insert(lines, string.format("Pattern: /%s/", self.challenge.pattern))

    if self.difficulty == "noob" or self.difficulty == "easy" then
        table.insert(lines, string.format("Hint: %s", self.challenge.description))
    end

    vim.defer_fn(function()
        self:setupCursorMonitoring()
    end, 100)

    return lines, 1, 0
end

function RegexMasterRound:setupCursorMonitoring()
    local augroup_name = "RegexMasterCursorCheck_" .. vim.fn.localtime()
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

function RegexMasterRound:cleanupCursorMonitoring()
    if self.cursorCheckAugroup then
        pcall(vim.api.nvim_del_augroup_by_name, self.cursorCheckAugroup)
        self.cursorCheckAugroup = nil
    end
end

function RegexMasterRound:onCursorMoved()
    if self:checkForWin() then
        self:cleanupCursorMonitoring()

        if self.endRoundCallback then
            self.endRoundCallback(true)
        end
    end
end

function RegexMasterRound:checkForWin()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local currentLineNum = cursor[1]
    local currentCol = cursor[2] + 1

    local allBufferLines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local targetLineText = self.textLines[self.correctTarget.line]
    local targetAbsoluteLineNum = nil

    for i, line in ipairs(allBufferLines) do
        if line == targetLineText then
            targetAbsoluteLineNum = i
            break
        end
    end

    if targetAbsoluteLineNum and
        currentLineNum == targetAbsoluteLineNum and
        currentCol >= self.correctTarget.startCol and
        currentCol <= (self.correctTarget.endCol or self.correctTarget.startCol) then
        return true
    end

    return false
end

function RegexMasterRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
end

function RegexMasterRound:name()
    return "regex-master"
end

function RegexMasterRound:close()
    self:cleanupCursorMonitoring()
end

return RegexMasterRound
