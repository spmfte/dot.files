-- ~/.config/nvim/lua/keymaps.lua

-- Set leader keys
vim.g.mapleader = " "  -- Space as leader key
vim.g.maplocalleader = "\\"  -- Backslash as local leader key

-- Function to set key mappings
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Remap ';' to ':' so you don't need to press Shift
map('n', ';', ':')
map('v', ';', ':')
map('c', ';', ':')
map('x', ';', ':')

-- NERDTree Toggle and Focus
map('n', '<leader>e', ':NERDTreeToggle<CR>')
map('n', '<leader>n', ':NERDTreeFocus<CR>')
map('n', '<C-n>', ':NERDTree<CR>')
map('n', '<C-t>', ':NERDTreeToggle<CR>')
map('n', '<C-f>', ':NERDTreeFind<CR>')

-- Save file
map('n', '<leader>w', ':w<CR>')

-- Quit Neovim
map('n', '<leader>q', ':q<CR>')

-- Save and quit
map('n', '<leader>wq', ':wq<CR>')

-- Close the current buffer
map('n', '<leader>bc', ':bd<CR>')

-- Split window
map('n', '<leader>ss', ':split<CR>')
map('n', '<leader>vs', ':vsplit<CR>')

-- Navigate between splits
map('n', '<leader>h', '<C-w>h')
map('n', '<leader>j', '<C-w>j')
map('n', '<leader>k', '<C-w>k')
map('n', '<leader>l', '<C-w>l')

-- Resize splits
map('n', '<leader><left>', ':vertical resize -2<CR>')
map('n', '<leader><right>', ':vertical resize +2<CR>')
map('n', '<leader><up>', ':resize +2<CR>')
map('n', '<leader><down>', ':resize -2<CR>')

-- Open terminal
map('n', '<leader>t', ':term<CR>')

-- Telescope mappings for finding files, live grep, etc.
map('n', '<leader>ff', ':Telescope find_files<CR>')
map('n', '<leader>fg', ':Telescope live_grep<CR>')
map('n', '<leader>fb', ':Telescope buffers<CR>')
map('n', '<leader>fh', ':Telescope help_tags<CR>')

-- Toggle relative numbers
map('n', '<leader>rn', ':set relativenumber!<CR>')

