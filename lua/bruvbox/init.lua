local M = {}
local config = { variant = 'auto', transparent = false, italic = true, overrides = {} }

function M.setup(opts)
  opts = opts or {}
  for key, _ in pairs(opts) do
    if config[key] == nil then error('Unknown Bruvbox option: ' .. key) end
  end
  if opts.variant ~= nil and opts.variant ~= 'auto' and opts.variant ~= 'dark' and opts.variant ~= 'light' then
    error('Bruvbox variant must be auto, dark or light')
  end
  for _, key in ipairs({ 'transparent', 'italic' }) do
    if opts[key] ~= nil and type(opts[key]) ~= 'boolean' then error(key .. ' must be boolean') end
  end
  if opts.overrides ~= nil and type(opts.overrides) ~= 'table' and type(opts.overrides) ~= 'function' then
    error('Bruvbox overrides must be a table or function')
  end
  config = vim.tbl_extend('force', config, opts)
end

function M.get(variant)
  variant = variant or config.variant
  if variant == 'auto' then variant = vim.o.background end
  local data = require('bruvbox.generated')[variant]
  if not data then error('Unknown Bruvbox variant: ' .. tostring(variant)) end
  return vim.deepcopy(data)
end

function M.load()
  local variant = config.variant == 'auto' and vim.o.background or config.variant
  -- Set background before colors_name to avoid recursively reloading this scheme.
  vim.g.colors_name = nil
  vim.o.background = variant
  local theme = M.get(variant)
  vim.cmd('highlight clear')
  vim.o.termguicolors = true
  vim.g.colors_name = 'bruvbox-next'
  local groups = theme.highlights
  if not config.italic then
    for _, attrs in pairs(groups) do if attrs.italic ~= nil then attrs.italic = false end end
  end
  if config.transparent then
    for _, group in ipairs({ 'Normal', 'NormalNC', 'SignColumn', 'EndOfBuffer' }) do
      groups[group].bg = nil
    end
  end
  local overrides = config.overrides
  if type(overrides) == 'function' then overrides = overrides(theme) end
  for name, attrs in pairs(overrides or {}) do groups[name] = attrs end
  for name, attrs in pairs(groups) do vim.api.nvim_set_hl(0, name, attrs) end
  for i = 0, 15 do vim.g['terminal_color_' .. i] = theme.colors['terminal.ansi-' .. i] end
end
return M
