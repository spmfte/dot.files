return {
    {
        "lewis6991/gitsigns.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        event = "BufReadPre",
        config = function()
            require("gitsigns").setup {
                signs = {
                    add = {hl = 'GitGutterAdd', text = '│', numhl='GitSignsAddNr', linehl='GitSignsAddLn'},
                    change = {hl = 'GitGutterChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
                    delete = {hl = 'GitGutterDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
                    topdelete = {hl = 'GitGutterDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
                    changedelete = {hl = 'GitGutterChangeDelete', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
                },
                keymaps = {
                    -- Default keymap options
                    noremap = true,
                    buffer = true,

                    ['n ]c'] = { expr = true, '&diff ? \']c\' : \'<cmd>lua require"gitsigns".next_hunk()<CR>\''},
                    ['n [c'] = { expr = true, '&diff ? \'[c\' : \'<cmd>lua require"gitsigns".prev_hunk()<CR>\''},

                    ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
                    ['v <leader>hs'] = ':lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
                    ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
                    ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
                    ['v <leader>hr'] = ':lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
                    ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
                    ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
                    ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
                    ['n <leader>hS'] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',
                    ['n <leader>hU'] = '<cmd>lua require"gitsigns".reset_buffer_index()<CR>',

                    -- Text objects
                    ['o ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
                    ['x ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>'
                },
                watch_gitdir = {
                    interval = 1000,
                    follow_files = true
                },
                current_line_blame = true,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                    delay = 1000,
                },
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil, -- Use default
                max_file_length = 40000, -- Disable if file is longer than this (in lines)
                preview_config = {
                    -- Options passed to nvim_open_win
                    border = 'single',
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1
                },
                yadm = {
                    enable = false
                },
            }
        end,
    }
}

