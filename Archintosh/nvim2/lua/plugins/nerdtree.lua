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
        cmd = "NERDTreeToggle",
        config = function()
            -- Setup nvim-web-devicons
            require('nvim-web-devicons').setup({ default = true })

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

            -- NERDTree Git Plugin Configuration
            vim.g.NERDTreeGitStatusIndicatorMapCustom = {
                Modified  = "✹",
                Staged    = "✚",
                Untracked = "✭",
                Renamed   = "➜",
                Unmerged  = "═",
                Deleted   = "✖",
                Dirty     = "✗",
                Ignored   = "☒",
                Clean     = "✔︎",
                Unknown   = "?",
            }

            -- Highlight git status in NERDTree
            vim.cmd([[
                highlight NERDTreeGitModified guifg=#e32636
                highlight NERDTreeGitStaged guifg=#50fa7b
                highlight NERDTreeGitUntracked guifg=#bd93f9
                highlight NERDTreeGitRenamed guifg=#ffb86c
                highlight NERDTreeGitUnmerged guifg=#ff5555
                highlight NERDTreeGitDeleted guifg=#ff5555
                highlight NERDTreeGitDirty guifg=#ffb86c
                highlight NERDTreeGitIgnored guifg=#6272a4
                highlight NERDTreeGitClean guifg=#50fa7b
                highlight NERDTreeGitUnknown guifg=#bd93f9
            ]])
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

