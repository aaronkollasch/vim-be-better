-- log.lua
--
-- Inspired by rxi/log.lua
-- Modified by tjdevries and can be found at github.com/tjdevries/vlog.nvim
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.

local default_config = {
  should_inspect = false,

  plugin = 'VimBeBetter',

  use_console = vim.g["vim_be_better_log_console"] or false,

  highlights = true,

  use_file = vim.g["vim_be_better_log_file"] or true,

  level = "trace",

  modes = {
    { name = "trace", hl = "Comment", },
    { name = "debug", hl = "Comment", },
    { name = "info",  hl = "None", },
    { name = "warn",  hl = "WarningMsg", },
    { name = "error", hl = "ErrorMsg", },
    { name = "fatal", hl = "ErrorMsg", },
  },

  float_precision = 0.01,
}

local log = {}

local unpack = unpack or table.unpack

log.new = function(config, standalone)
  config = vim.tbl_deep_extend("force", default_config, config)

  local outfile = string.format('%s/%s.log', vim.api.nvim_call_function('stdpath', {'data'}), config.plugin)

  local obj
  if standalone then
    obj = log
  else
    obj = {}
  end

  local levels = {}
  for i, v in ipairs(config.modes) do
    levels[v.name] = i
  end

  local round = function(x, increment)
    increment = increment or 1
    x = x / increment
    return (x > 0 and math.floor(x + .5) or math.ceil(x - .5)) * increment
  end

  local make_string = function(...)
    local t = {}
    for i = 1, select('#', ...) do
      local x = select(i, ...)
      if type(x) == "number" and config.float_precision then
        x = round(x, config.float_precision)
      elseif type(x) == "table" then
        x = vim.inspect(x)
      else
        x = tostring(x)
      end
      t[#t + 1] = x
    end
    return table.concat(t, " ")
  end

  local log_at_level = function(level, level_config, message_maker, ...)
    if level < levels[config.level] then
      return
    end
    local nameupper = level_config.name:upper()

    local msg = message_maker(...)
    local info = debug.getinfo(2, "Sl")
    local lineinfo = info.short_src .. ":" .. info.currentline

    if config.use_console then
      local log_string = string.format("[%-6s%s] %s: %s", nameupper, os.date("%H:%M:%S"), lineinfo, msg)

      if config.highlights and level_config.hl then
        vim.cmd(string.format("echohl %s", level_config.hl))
      end

      local split_console = vim.split(log_string, "\n")
      for _, v in ipairs(split_console) do
        vim.cmd(string.format([[echom "[%s] %s"]], config.plugin, vim.fn.escape(v, '"')))
      end

      if config.highlights and level_config.hl then
        vim.cmd("echohl NONE")
      end
    end

    if config.use_file then
      local fp = io.open(outfile, "a")
      local str = string.format("[%-6s%s] %s: %s\n", nameupper, os.date(), lineinfo, msg)
      fp:write(str)
      fp:close()
    end
  end

  for i, x in ipairs(config.modes) do
    obj[x.name] = function(...)
      return log_at_level(i, x, make_string, ...)
    end
  end
end

log.new(default_config, true)

return log
