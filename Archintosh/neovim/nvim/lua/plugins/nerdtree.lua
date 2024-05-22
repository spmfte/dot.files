-- ~/.config/nvim/lua/plugins/nerdtree.lua

return {
    {
        "preservim/nerdtree",
        requires = {
            "Xuyuanp/nerdtree-git-plugin",
            "ryanoasis/vim-devicons",
            "tiagofumo/vim-nerdtree-syntax-highlight",
            "PhilRunninger/nerdtree-buffer-ops",
            "PhilRunninger/nerdtree-visual-selection",
        },
        config = function()
            -- Automatically close Vim if NERDTree is the last window
            vim.cmd([[
                autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
            ]])

            -- Key mappings for NERDTree actions
            vim.api.nvim_set_keymap('n', '<leader>e', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>n', ':NERDTreeFocus<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<C-n>', ':NERDTree<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<C-t>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<C-f>', ':NERDTreeFind<CR>', { noremap = true, silent = true })

            -- Customize NERDTree appearance
            vim.g.NERDTreeDirArrowExpandable = '▸'
            vim.g.NERDTreeDirArrowCollapsible = '▾'
            vim.g.NERDTreeMinimalUI = 1
            vim.g.NERDTreeShowHidden = 1

            -- Enable line numbers for files in NERDTree
            vim.g.NERDTreeFileLines = 1
        end,
    },
    {
        "Xuyuanp/nerdtree-git-plugin",
        requires = "preservim/nerdtree",
    },
    {
        "ryanoasis/vim-devicons",
        requires = "preservim/nerdtree",
    },
    {
        "tiagofumo/vim-nerdtree-syntax-highlight",
        requires = "preservim/nerdtree",
    },
    {
        "PhilRunninger/nerdtree-buffer-ops",
        requires = "preservim/nerdtree",
    },
    {
        "PhilRunninger/nerdtree-visual-selection",
        requires = "preservim/nerdtree",
    },
}

