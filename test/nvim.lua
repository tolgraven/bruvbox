local function equal(actual, expected, label)
  assert(actual == expected, label .. ': expected ' .. tostring(expected) .. ', got ' .. tostring(actual))
end
local bb = require('bruvbox')
for _, variant in ipairs({ 'dark', 'light' }) do
  bb.setup({ variant = variant, transparent = false, italic = true, overrides = {} })
  vim.cmd.colorscheme('bruvbox-next')
  local theme = bb.get(variant)
  equal(vim.g.colors_name, 'bruvbox-next', 'scheme name')
  equal(vim.api.nvim_get_hl(0, {name='Normal'}).bg, tonumber(theme.colors['surface.canvas']:sub(2),16), 'Normal background')
  equal(vim.api.nvim_get_hl(0, {name='@function'}).fg, tonumber(theme.colors['syntax.function']:sub(2),16), 'Treesitter function')
  equal(vim.api.nvim_get_hl(0, {name='DiagnosticUnderlineError'}).undercurl, true, 'diagnostic underline')
  equal(vim.g.terminal_color_15, theme.colors['terminal.ansi-15'], 'terminal slot')
end
bb.setup({ variant='auto', transparent=true, italic=false, overrides={NormalFloat={fg='#ffffff'}} })
vim.o.background='dark'
vim.cmd.colorscheme('bruvbox-next')
equal(vim.api.nvim_get_hl(0,{name='Normal'}).bg,nil,'transparent')
equal(vim.api.nvim_get_hl(0,{name='Comment'}).italic,nil,'disabled italic')
equal(vim.api.nvim_get_hl(0,{name='NormalFloat'}).fg,16777215,'override')
vim.o.background='light'
equal(vim.api.nvim_get_hl(0,{name='Normal'}).fg,tonumber('2d3030',16),'background switch')
assert(not pcall(bb.setup, {variant='typo'}), 'invalid variant accepted')
assert(not pcall(bb.setup, {italic='yes'}), 'invalid option accepted')
-- The Vim adapter still consumes all legacy names and uses a fresh palette each load.
vim.o.background='dark'
vim.o.termguicolors=true
vim.cmd('set t_Co=256')
vim.cmd.colorscheme('bruvbox')
equal(vim.g.bruvbox_palette.bright_red[1],'#d18479','legacy red')
equal(vim.g.bruvbox_palette.dark0[1],'#262525','legacy canvas')
local p=vim.fn['bruvbox#palette#get'](); p.dark0[1]='changed'
equal(vim.fn['bruvbox#palette#get']().dark0[1],'#262525','palette copy isolation')
print('Bruvbox Neovim smoke checks passed')
