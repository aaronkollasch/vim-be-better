local GameUtils = require("vim-be-better.game-utils")
local log = require("vim-be-better.log")

local instructions = {
    "--- Refactor Race ---",
    "",
    "Refactor code to make it better as fast as possible!",
    "Apply real-world refactoring techniques efficiently.",
    "",
    "  🥇 Gold:    ≤ target time (excellent!)",
    "  🥈 Silver:  110-130% target (good!)",
    "  🥉 Bronze:  130-150% target (okay)",
    "  ⏱️  Slow:    > 150% target (practice more)",
    "",
    "Goal: Transform code using vim commands quickly and accurately.",
}

local timeTargets = {
    noob = { base = 12, multiplier = 1.0 },     -- 12s base, easier targets
    easy = { base = 10, multiplier = 1.2 },     -- 12s base
    medium = { base = 8, multiplier = 1.5 },    -- 12s base
    hard = { base = 6, multiplier = 2.0 },      -- 12s base but more complex
    nightmare = { base = 5, multiplier = 2.5 }, -- 12.5s base
    tpope = { base = 4, multiplier = 3.0 }      -- 12s base, ultimate challenge
}

local difficultyConfig = {
    noob = {
        challenges = {
            {
                name = "Extract magic number",
                startText = {
                    "function validateAge(age) {",
                    "  return age >= 18;",
                    "}"
                },
                expectedResult = {
                    "const MIN_AGE = 18;",
                    "",
                    "function validateAge(age) {",
                    "  return age >= MIN_AGE;",
                    "}"
                },
                cursorPos = { line = 1, col = 1 },
                timeMultiplier = 1.0,
                description = "Extract magic number 18 to a named constant",
                hint = "Add const declaration above, then change 18 to MIN_AGE"
            },
            {
                name = "Rename unclear variable",
                startText = {
                    "function process(d) {",
                    "  const result = d * 86400;",
                    "  return result;",
                    "}"
                },
                expectedResult = {
                    "function process(days) {",
                    "  const result = days * 86400;",
                    "  return result;",
                    "}"
                },
                cursorPos = { line = 1, col = 17 },
                timeMultiplier = 0.8,
                description = "Rename variable 'd' to descriptive 'days'",
                hint = "Use ciw to change 'd' to 'days', then repeat for second occurrence"
            },
            {
                name = "Remove duplicate condition",
                startText = {
                    "if (user.isActive && user.isActive) {",
                    "  console.log('User is active');",
                    "}"
                },
                expectedResult = {
                    "if (user.isActive) {",
                    "  console.log('User is active');",
                    "}"
                },
                cursorPos = { line = 1, col = 18 },
                timeMultiplier = 0.6,
                description = "Remove duplicated condition",
                hint = "Delete ' && user.isActive' part"
            }
        }
    },

    easy = {
        challenges = {
            {
                name = "Extract function",
                startText = {
                    "function handleUser() {",
                    "  console.log('Processing user...');",
                    "  console.log('User processed');",
                    "  console.log('Processing user...');",
                    "  console.log('User processed');",
                    "}"
                },
                expectedResult = {
                    "function processUser() {",
                    "  console.log('Processing user...');",
                    "  console.log('User processed');",
                    "}",
                    "",
                    "function handleUser() {",
                    "  processUser();",
                    "  processUser();",
                    "}"
                },
                cursorPos = { line = 1, col = 1 },
                timeMultiplier = 1.5,
                description = "Extract duplicate code into processUser function",
                hint = "Create new function above, then replace duplicated blocks with calls"
            },
            {
                name = "Simplify boolean return",
                startText = {
                    "function isValidEmail(email) {",
                    "  if (email.includes('@')) {",
                    "    return true;",
                    "  } else {",
                    "    return false;",
                    "  }",
                    "}"
                },
                expectedResult = {
                    "function isValidEmail(email) {",
                    "  return email.includes('@');",
                    "}"
                },
                cursorPos = { line = 2, col = 1 },
                timeMultiplier = 1.2,
                description = "Simplify boolean function to direct return",
                hint = "Replace if/else with direct return statement"
            },
            {
                name = "Combine variable declarations",
                startText = {
                    "const name = user.name;",
                    "const email = user.email;",
                    "const age = user.age;"
                },
                expectedResult = {
                    "const { name, email, age } = user;"
                },
                cursorPos = { line = 1, col = 1 },
                timeMultiplier = 1.0,
                description = "Use destructuring instead of multiple assignments",
                hint = "Replace with destructuring assignment"
            }
        }
    },

    medium = {
        challenges = {
            {
                name = "Replace nested conditions with guard",
                startText = {
                    "function updateUser(user) {",
                    "  if (user) {",
                    "    if (user.isActive) {",
                    "      user.lastUpdated = Date.now();",
                    "      return user;",
                    "    }",
                    "  }",
                    "  return null;",
                    "}"
                },
                expectedResult = {
                    "function updateUser(user) {",
                    "  if (!user || !user.isActive) {",
                    "    return null;",
                    "  }",
                    "",
                    "  user.lastUpdated = Date.now();",
                    "  return user;",
                    "}"
                },
                cursorPos = { line = 2, col = 1 },
                timeMultiplier = 1.8,
                description = "Replace nested ifs with guard clause",
                hint = "Add early return with combined conditions, then simplify main logic"
            },
            {
                name = "Extract configuration object",
                startText = {
                    "function connect() {",
                    "  const url = 'https://api.example.com';",
                    "  const timeout = 5000;",
                    "  const retries = 3;",
                    "  return fetch(url, { timeout, retries });",
                    "}"
                },
                expectedResult = {
                    "const API_CONFIG = {",
                    "  url: 'https://api.example.com',",
                    "  timeout: 5000,",
                    "  retries: 3",
                    "};",
                    "",
                    "function connect() {",
                    "  return fetch(API_CONFIG.url, {",
                    "    timeout: API_CONFIG.timeout,",
                    "    retries: API_CONFIG.retries",
                    "  });",
                    "}"
                },
                cursorPos = { line = 1, col = 1 },
                timeMultiplier = 2.0,
                description = "Extract configuration to external object",
                hint = "Create config object above, then reference its properties"
            },
            {
                name = "Simplify array operation",
                startText = {
                    "const activeUsers = [];",
                    "for (let i = 0; i < users.length; i++) {",
                    "  if (users[i].isActive) {",
                    "    activeUsers.push(users[i]);",
                    "  }",
                    "}"
                },
                expectedResult = {
                    "const activeUsers = users.filter(user => user.isActive);"
                },
                cursorPos = { line = 1, col = 1 },
                timeMultiplier = 1.5,
                description = "Replace loop with filter method",
                hint = "Replace entire loop with users.filter() call"
            }
        }
    },

    hard = {
        challenges = {
            {
                name = "Extract error handling",
                startText = {
                    "async function saveUser(user) {",
                    "  try {",
                    "    const result = await api.save(user);",
                    "    console.log('User saved');",
                    "    return result;",
                    "  } catch (error) {",
                    "    console.error('Failed to save user:', error);",
                    "    throw error;",
                    "  }",
                    "}",
                    "",
                    "async function deleteUser(id) {",
                    "  try {",
                    "    await api.delete(id);",
                    "    console.log('User deleted');",
                    "  } catch (error) {",
                    "    console.error('Failed to delete user:', error);",
                    "    throw error;",
                    "  }",
                    "}"
                },
                expectedResult = {
                    "async function withErrorHandling(operation, successMessage) {",
                    "  try {",
                    "    const result = await operation();",
                    "    console.log(successMessage);",
                    "    return result;",
                    "  } catch (error) {",
                    "    console.error(`Failed: ${error.message}`);",
                    "    throw error;",
                    "  }",
                    "}",
                    "",
                    "async function saveUser(user) {",
                    "  return withErrorHandling(",
                    "    () => api.save(user),",
                    "    'User saved'",
                    "  );",
                    "}",
                    "",
                    "async function deleteUser(id) {",
                    "  return withErrorHandling(",
                    "    () => api.delete(id),",
                    "    'User deleted'",
                    "  );",
                    "}"
                },
                cursorPos = { line = 1, col = 1 },
                timeMultiplier = 2.5,
                description = "Extract common error handling pattern",
                hint = "Create higher-order function for error handling, then refactor both functions"
            },
            {
                name = "Replace string concatenation with template",
                startText = {
                    "function buildQuery(table, where, orderBy) {",
                    "  let query = 'SELECT * FROM ' + table;",
                    "  if (where) {",
                    "    query += ' WHERE ' + where;",
                    "  }",
                    "  if (orderBy) {",
                    "    query += ' ORDER BY ' + orderBy;",
                    "  }",
                    "  return query;",
                    "}"
                },
                expectedResult = {
                    "function buildQuery(table, where, orderBy) {",
                    "  const whereClause = where ? ` WHERE ${where}` : '';",
                    "  const orderClause = orderBy ? ` ORDER BY ${orderBy}` : '';",
                    "  return `SELECT * FROM ${table}${whereClause}${orderClause}`;",
                    "}"
                },
                cursorPos = { line = 2, col = 1 },
                timeMultiplier = 2.0,
                description = "Use template literals instead of concatenation",
                hint = "Replace string concatenation with template literal and conditional clauses"
            }
        }
    },

    nightmare = {
        challenges = {
            {
                name = "Replace callback with async/await",
                startText = {
                    "function processData(data, callback) {",
                    "  validateData(data, (err, isValid) => {",
                    "    if (err) return callback(err);",
                    "    if (!isValid) return callback(new Error('Invalid'));",
                    "    ",
                    "    transformData(data, (err, result) => {",
                    "      if (err) return callback(err);",
                    "      callback(null, result);",
                    "    });",
                    "  });",
                    "}"
                },
                expectedResult = {
                    "async function processData(data) {",
                    "  const isValid = await validateData(data);",
                    "  if (!isValid) {",
                    "    throw new Error('Invalid');",
                    "  }",
                    "  ",
                    "  return await transformData(data);",
                    "}"
                },
                cursorPos = { line = 1, col = 1 },
                timeMultiplier = 2.8,
                description = "Convert callback hell to async/await",
                hint = "Replace nested callbacks with async/await pattern and proper error handling"
            },
            {
                name = "Replace class with composition",
                startText = {
                    "class UserValidator {",
                    "  validateEmail(email) {",
                    "    return email.includes('@');",
                    "  }",
                    "  ",
                    "  validateAge(age) {",
                    "    return age >= 18;",
                    "  }",
                    "}",
                    "",
                    "class UserService extends UserValidator {",
                    "  create(user) {",
                    "    if (!this.validateEmail(user.email)) return false;",
                    "    if (!this.validateAge(user.age)) return false;",
                    "    return this.save(user);",
                    "  }",
                    "}"
                },
                expectedResult = {
                    "const validators = {",
                    "  email: (email) => email.includes('@'),",
                    "  age: (age) => age >= 18",
                    "};",
                    "",
                    "function createUser(user) {",
                    "  if (!validators.email(user.email)) return false;",
                    "  if (!validators.age(user.age)) return false;",
                    "  return save(user);",
                    "}"
                },
                cursorPos = { line = 1, col = 1 },
                timeMultiplier = 3.0,
                description = "Replace inheritance with composition",
                hint = "Create validators object and standalone function instead of classes"
            }
        }
    },

    tpope = {
        challenges = {
            {
                name = "Refactor to functional pipeline",
                startText = {
                    "function processUsers(users) {",
                    "  const results = [];",
                    "  for (const user of users) {",
                    "    if (user.isActive) {",
                    "      const transformed = {",
                    "        id: user.id,",
                    "        name: user.name.toUpperCase(),",
                    "        email: user.email.toLowerCase()",
                    "      };",
                    "      if (transformed.email.includes('@')) {",
                    "        results.push(transformed);",
                    "      }",
                    "    }",
                    "  }",
                    "  return results.sort((a, b) => a.name.localeCompare(b.name));",
                    "}"
                },
                expectedResult = {
                    "const processUsers = (users) =>",
                    "  users",
                    "    .filter(user => user.isActive)",
                    "    .map(user => ({",
                    "      id: user.id,",
                    "      name: user.name.toUpperCase(),",
                    "      email: user.email.toLowerCase()",
                    "    }))",
                    "    .filter(user => user.email.includes('@'))",
                    "    .sort((a, b) => a.name.localeCompare(b.name));"
                },
                cursorPos = { line = 1, col = 1 },
                timeMultiplier = 3.5,
                description = "Transform imperative loop to functional pipeline",
                hint = "Chain filter, map, filter, sort methods to replace the entire loop"
            }
        }
    }
}

local RefactorRaceRound = {}

function RefactorRaceRound:new(difficulty, window)
    log.info("RefactorRaceRound:new", difficulty, window)

    local round = {
        window = window,
        difficulty = difficulty or "easy",
        currentChallenge = nil,
        startTime = nil,
        endTime = nil,
        targetTime = nil,
        endRoundCallback = nil,
        hasWon = false,
        timerRunning = false
    }

    self.__index = self
    return setmetatable(round, self)
end

function RefactorRaceRound:getInstructions()
    return instructions
end

function RefactorRaceRound:getConfig()
    log.info("RefactorRaceRound:getConfig", self.difficulty)

    vim.schedule(function()
        if self.window and self.window.bufh then
            vim.api.nvim_buf_set_option(self.window.bufh, 'modifiable', true)
        end
    end)

    self:generateChallenge()
    self.hasWon = false
    self.timerRunning = false

    return {
        roundTime = GameUtils.difficultyToTime[self.difficulty] or 60000,
        canEndRound = true,
    }
end

function RefactorRaceRound:generateChallenge()
    local difficultyKey = self.difficulty or "easy"
    local config = difficultyConfig[difficultyKey] or difficultyConfig.easy
    local timeConfig = timeTargets[difficultyKey] or timeTargets.easy

    self.currentChallenge = vim.deepcopy(config.challenges[math.random(#config.challenges)])

    local baseTime = timeConfig.base
    local multiplier = timeConfig.multiplier * (self.currentChallenge.timeMultiplier or 1.0)
    self.targetTime = baseTime * multiplier

    log.info("RefactorRaceRound:generateChallenge",
        self.currentChallenge.name,
        "target time:", self.targetTime)
end

function RefactorRaceRound:startTimer()
    if not self.timerRunning then
        self.startTime = vim.fn.reltimefloat(vim.fn.reltime())
        self.timerRunning = true
        log.info("RefactorRaceRound:startTimer - Timer started")
    end
end

function RefactorRaceRound:getCurrentTime()
    if not self.startTime then return 0 end
    return vim.fn.reltimefloat(vim.fn.reltime()) - self.startTime
end

function RefactorRaceRound:getTimeStatus(currentTime)
    if not self.targetTime then return "⏱️" end

    local percentage = (currentTime / self.targetTime) * 100

    if percentage <= 100 then
        return "🥇 Gold"
    elseif percentage <= 130 then
        return "🥈 Silver"
    elseif percentage <= 150 then
        return "🥉 Bronze"
    else
        return "⏱️ Slow"
    end
end

function RefactorRaceRound:setupChangeMonitoring()
    local augroup_name = "RefactorRaceCheck_" .. vim.fn.localtime()
    self.changeAugroup = augroup_name

    vim.api.nvim_create_augroup(augroup_name, { clear = true })

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        group = augroup_name,
        buffer = self.window.buffer.bufh,
        callback = function()
            self:startTimer()
            if not self.hasWon then
                self:checkForWin()
            end
        end
    })

    log.info("RefactorRaceRound:setupChangeMonitoring - Created augroup:", augroup_name)
end

function RefactorRaceRound:checkForWin()
    if not self.currentChallenge or self.hasWon then
        return false
    end

    local all_lines = vim.api.nvim_buf_get_lines(self.window.buffer.bufh, 0, -1, false)
    local actual_text = {}

    local start_line = nil
    for i, line in ipairs(all_lines) do
        if line:match("^=== YOUR CODE %(edit below%) ===$") then
            start_line = i + 1
            break
        end
    end

    if start_line then
        for i = 1, #self.currentChallenge.expectedResult do
            actual_text[i] = all_lines[start_line + i - 1] or ""
        end
    end

    log.info("RefactorRaceRound:checkForWin",
        "start_line:", start_line,
        "Expected:", vim.inspect(self.currentChallenge.expectedResult),
        "Actual:", vim.inspect(actual_text))

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

    if matches then
        self.hasWon = true
        self.endTime = self:getCurrentTime()
        local status = self:getTimeStatus(self.endTime)

        log.info("RefactorRaceRound:checkForWin - REFACTORING MASTER!",
            "time:", string.format("%.2f", self.endTime),
            "target:", self.targetTime,
            "status:", status)

        if self.endRoundCallback then
            vim.defer_fn(function()
                self.endRoundCallback(true)
            end, 100)
        end
        return true
    end

    return false
end

function RefactorRaceRound:render()
    if not self.currentChallenge then
        log.error("RefactorRaceRound:render - No current challenge")
        return {}, 1, 0
    end

    local lines = {}

    table.insert(lines, "Challenge: " .. self.currentChallenge.name)
    table.insert(lines, "Description: " .. self.currentChallenge.description)
    table.insert(lines, "Target: < " .. string.format("%.1f", self.targetTime) .. " seconds")

    if self.timerRunning and not self.hasWon then
        local currentTime = self:getCurrentTime()
        local status = self:getTimeStatus(currentTime)
        table.insert(lines, "Time: " .. string.format("%.1f", currentTime) .. "s (" .. status .. ")")
    elseif self.hasWon then
        local status = self:getTimeStatus(self.endTime)
        table.insert(lines, "Finished: " .. string.format("%.1f", self.endTime) .. "s (" .. status .. ")")
    else
        table.insert(lines, "Time: Ready to start!")
    end

    if self.difficulty == "noob" or self.difficulty == "easy" then
        table.insert(lines, "Hint: " .. self.currentChallenge.hint)
    end

    table.insert(lines, "")
    table.insert(lines, "=== EXPECTED RESULT ===")

    for _, line in ipairs(self.currentChallenge.expectedResult) do
        table.insert(lines, line)
    end

    table.insert(lines, "")
    table.insert(lines, "=== YOUR CODE (edit below) ===")

    for _, line in ipairs(self.currentChallenge.startText) do
        table.insert(lines, line)
    end

    local editableSectionStart = #lines - #self.currentChallenge.startText + 1
    local cursorLine = editableSectionStart + (self.currentChallenge.cursorPos.line or 1) - 1
    local cursorCol = (self.currentChallenge.cursorPos.col or 1) - 1

    vim.defer_fn(function()
        self:setupChangeMonitoring()
    end, 100)

    log.info("RefactorRaceRound:render",
        "challenge:", self.currentChallenge.name,
        "target:", self.targetTime,
        "cursor:", cursorLine, cursorCol,
        "editable_start:", editableSectionStart)

    return lines, cursorLine, cursorCol
end

function RefactorRaceRound:cleanup()
    if self.changeAugroup then
        pcall(vim.api.nvim_del_augroup_by_name, self.changeAugroup)
        self.changeAugroup = nil
    end
end

function RefactorRaceRound:name()
    return "refactor-race"
end

function RefactorRaceRound:setEndRoundCallback(callback)
    self.endRoundCallback = callback
end

return RefactorRaceRound
