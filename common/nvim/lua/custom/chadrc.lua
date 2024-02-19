---@class MyChadrcConfig : ChadrcConfig
---@field options table
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"
------------------------------------------------------------------------
------------------------------- BEGIN COPY -----------------------------
------------------------------------------------------------------------
M.ui = {
  theme = "bearded-arc",
  theme_toggle = { "bearded-arc", "decay" },
  hl_override = {
     NvDashAscii = {
      bg ="none",
      fg ="blue"
    },
      NvDashButtons = {
      bg = "none",
      fg = "#abb7c1"
    },
  } ,
  hl_add = highlights.add,
  transparency = false,
  lsp_semantic_tokens = true,

 -- https://github.com/NvChad/base46/tree/v2.0/lua/base46/extended_integrations
  extended_integrations = {"notify"}, -- these aren't compiled by default, ex: "alpha", "notify"

  -- cmp themeing
  cmp = {
    icons = true,
    lspkind_text = true,
    style = "atom_colored", -- default/flat_light/flat_dark/atom/atom_colored
    border_color = "default", -- only applicable for "default" style, use color names from base30 variables
    selected_item_bg = "colored", -- colored / simple
  },

  telescope = { style = "bordered" }, -- borderless / bordered

  ------------------------------- nvchad_ui modules -----------------------------
  statusline = {
    theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "default",
    overriden_modules = nil,
  },

  -- lazyload it when there are 1+ buffers
  tabufline = {
    show_numbers = false,
    enabled = true,
    lazyload = true,
    overriden_modules = nil,
  },

  -- nvdash (dashboard)
  nvdash = {
    load_on_startup = true,
    transparency = false,

    header = {
      "         Aidan Littman           ",
      "           ▄ ▄                   ",
      "       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ",
      "       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ",
      "    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ",
      "  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ",
      "  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄",
      "▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █",
      "█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █",
      "    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    ",
    },

    buttons = {
      { "  Find File", "Spc f f", "Telescope find_files" },
      { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
      { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
      { "  Bookmarks", "Spc m a", "Telescope marks" },
      { "  Themes", "Spc t h", "Telescope themes" },
      { "  Mappings", "Spc c h", "NvCheatsheet" },
    },
  },

  cheatsheet = { theme = "grid" }, -- simple/grid

  lsp = {
    -- show function signatures i.e args as you type
    signature = {
      disabled = false,
      silent = true, -- silences 'no signature help available' message from appearing
    },
  },
}



-- Add commands
vim.cmd("command! Update NvChadUpdate")
vim.cmd("command! Yy %y+")

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

------------------------------------------------------------------------
------------------------------- END COPY -------------------------------
------------------------------------------------------------------------
M.plugins = "custom.plugins"

-- Check core.mappings for table structure
M.mappings = require "custom.mappings"

return M

