-- ~/.config/nvim/lua/plugins/harpoon.lua

return {
    {
        "ThePrimeagen/harpoon",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("harpoon").setup({
                global_settings = {
                    save_on_toggle = false,
                    save_on_change = true,
                    enter_on_sendcmd = false,
                    tmux_autoclose_windows = false,
                    excluded_filetypes = { "harpoon" },
                    mark_branch = false,
                    tabline = true,
                    tabline_prefix = "   ",
                    tabline_suffix = "   ",
                },
                menu = {
                    width = vim.api.nvim_win_get_width(0) - 4,
                },
                projects = {
                    ["$HOME/personal/vim-with-me/server"] = {
                        term = {
                            cmds = {
                                "./env && npx ts-node src/index.ts",
                            },
                        },
                    },
                },
            })

            -- Key mappings for Harpoon
            vim.api.nvim_set_keymap('n', '<leader>ha', ":lua require('harpoon.mark').add_file()<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>hh', ":lua require('harpoon.ui').toggle_quick_menu()<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>hn', ":lua require('harpoon.ui').nav_next()<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>hp', ":lua require('harpoon.ui').nav_prev()<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>1', ":lua require('harpoon.ui').nav_file(1)<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>2', ":lua require('harpoon.ui').nav_file(2)<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>3', ":lua require('harpoon.ui').nav_file(3)<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>4', ":lua require('harpoon.ui').nav_file(4)<CR>", { noremap = true, silent = true })

            -- Terminal navigation
            vim.api.nvim_set_keymap('n', '<leader>ht', ":lua require('harpoon.term').gotoTerminal(1)<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>hc', ":lua require('harpoon.term').sendCommand(1, 1)<CR>", { noremap = true, silent = true })
        end,
    },
}

