-- Define your custom options
local options = {

  -- Base46 Theme Configurations
  base46 = {
    theme = "jabuti",  -- Replace with your theme
    hl_override = {
      NvDashAscii = {
        bg = "none",
        fg = "blue"
      },
      NvDashButtons = {
        bg = "none",
        fg = "#abb7c1"
      },
    },
    transparency = false,
    theme_toggle = { "jabuti", "jabuti" },
    extended_integrations = { "notify" }, -- Additional integrations
  },

  -- UI configurations
  ui = {
    cmp = {
      icons_left = true,
      lspkind_text = true,
      style = "atom_colored",
      format_colors = {
        tailwind = false, -- Disable tailwind icon colors
        icon = "󱓻",
      },
    },

    telescope = { style = "bordered" }, -- Keep "bordered" style for Telescope

    statusline = {
      theme = "vscode_colored", -- Custom theme
      separator_style = "default", -- Separator style for statusline
    },

    tabufline = {
      enabled = true,
      lazyload = true,
      order = { "treeOffset", "buffers", "tabs", "btns" },
    },
  },

  -- Nvdash dashboard configuration
  nvdash = {
    load_on_startup = true,
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
      "                                 ",
    },

    buttons = {
      { txt = "  Find File", keys = "Spc f f", cmd = "Telescope find_files" },
      { txt = "󰈚  Recent Files", keys = "Spc f o", cmd = "Telescope oldfiles" },
      { txt = "󰈭  Find Word", keys = "Spc f w", cmd = "Telescope live_grep" },
      { txt = "  Bookmarks", keys = "Spc m a", cmd = "Telescope marks" },
      { txt = "  Themes", keys = "Spc t h", cmd = "Telescope themes" },
      { txt = "  Mappings", keys = "Spc c h", cmd = "NvCheatsheet" },
      { txt = " NeoVim Config", keys = "Spc c n", cmd = "OpenNvimConfig" },

      { txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },

      {
        txt = function()
          local stats = require("lazy").stats()
          local ms = math.floor(stats.startuptime) .. " ms"
          return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
        end,
        hl = "NvDashLazy",
        no_gap = true,
      },

      { txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },
    },
  },

    --
  -- LSP settings
  lsp = {
    signature = {
      disabled = false,
      silent = true, -- Silence 'no signature help available'
    },
  },
}


-- This maps the key combination 'Spc c n' to execute the 'OpenNvimConfig' command directly
vim.keymap.set('n', '<leader>cn', function()
    vim.cmd('cd ~/.config/nvim')
    vim.cmd('NvimTreeToggle')
end, { noremap = true, silent = true, desc = "Open Neovim Config with NERDTree" })

-- Add commands
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

-- Add a vim command to toggle transparency using NvChad's method
vim.cmd("command! Bg lua require'base46'.toggle_transparency()")

-- run lazy update from 'U'
vim.cmd("command! U :Lazy update")
-- Merging with the current 'chadrc'
local status, chadrc = pcall(require, "chadrc")
return vim.tbl_deep_extend("force", options, status and chadrc or {})
