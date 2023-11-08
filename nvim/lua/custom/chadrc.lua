---@class MyChadrcConfig : ChadrcConfig
---@field options table
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = "bearded-arc",
  theme_toggle = { "bearded-arc", "bearded-arc" },
  hl_override = highlights.override,
  hl_add = highlights.add,
}

-- Add the transparency option
M.options = {
    transparency = false
}

-- Add commands
vim.cmd("command! Update NvChadUpdate")
vim.cmd("command! Yy %y+")
vim.cmd("command! Vimrc edit $MYVIMRC")

-- Add current date and time
vim.cmd("command! DateTime normal! i" .. os.date('%B %d, %Y @ %I:%M%p'))

-- Add various section breaks
-- Function to insert a full-width line
vim.cmd([[
function! InsertFullWidthLine(character)
    let l:winwidth = winwidth(0)
    let l:line = repeat(a:character, l:winwidth)
    execute "normal! i" . l:line . "\<CR>"
endfunction
]])

-- Commands to insert full-width lines
vim.cmd("command! LB call InsertFullWidthLine('—')")
vim.cmd("command! WaveBreak call InsertFullWidthLine('~')")
vim.cmd("command! DottedBreak call InsertFullWidthLine('*')")
vim.cmd("command! PlusBreak call InsertFullWidthLine('+')")
vim.cmd("command! EqBreak call InsertFullWidthLine('=')")

-- Formatting templates
vim.cmd("command! Bold normal! i**Bold Text**\\<CR>")
vim.cmd("command! Italic normal! i*Italic Text*\\<CR>")

-- Add a vim command to toggle transparency using NvChad's method
vim.cmd("command! Bg lua require'base46'.toggle_transparency()")

M.plugins = "custom.plugins"

-- Check core.mappings for table structure
M.mappings = require "custom.mappings"

return M

