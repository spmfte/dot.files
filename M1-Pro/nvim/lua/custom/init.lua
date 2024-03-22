-- local autocmd = vim.api.nvim_create_autocmd

-- init.lua for NvChad with Neorg integration

-- Load NvChad settings
require("custom.chadrc")

-- Plugin management
require("custom.plugins")

-- Set up Neovim options for Neorg
vim.wo.foldlevel = 99
vim.wo.conceallevel = 2

-- Additional setup or plugin configurations can go here
-- This is where you can further customize your Neovim experience
-- by adding keybindings, additional plugin settings, etc.
-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
-- adapted from https://github.com/folke/lazy.nvim#-installation

