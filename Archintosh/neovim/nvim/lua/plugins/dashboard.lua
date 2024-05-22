-- ~/.config/nvim/lua/plugins/dashboard.lua

return {
    {
        "nvimdev/dashboard-nvim",
        requires = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local dashboard = require("dashboard")

            dashboard.setup({
                theme = 'hyper',
                config = {
                    header = {
                        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
                        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣷⣶⣤⣀⠀⠀⠀⠀⠀⠀]],
                        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⣿⣿⣿⣶⣤⣀⠀⠀]],
                        [[⠀⠀⠀⠀⠀⠀⣀⣤⣤⣤⣀⣀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
                        [[⠀⠀⠀⠀⢀⣾⣿⡿⠛⢻⣿⣿⣿⣷⣄⡀⠀⠈⠙⢿⣿⣿⣿⣿⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
                        [[⠀⠀⠀⣰⣿⣿⠋⠁⠀⠀⠙⣿⣿⣿⣿⣿⣿⣶⣄⠀⠀⠙⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
                        [[⠀⢠⣾⣿⣿⠁⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣧⡀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
                        [[⣰⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
                        [[⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
                        [[⠸⠿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠘⠛⠻⠿⠿⠿⠟⠋⠉⠉⠉⠛⠛⠃⠀⠀⠈⠙⠻⠿⠿⠿⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
                    },
                    week_header = {
                        enable = true,
                        concat = " - Happy Coding!",
                        append = { "Have a productive week!" },
                    },
                    shortcut = {
                        { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
                        {
                            icon = ' ',
                            icon_hl = '@variable',
                            desc = 'Files',
                            group = 'Label',
                            action = 'Telescope find_files',
                            key = 'f',
                        },
                        {
                            desc = ' Projects',
                            group = 'DiagnosticHint',
                            action = 'Telescope projects',
                            key = 'p',
                        },
                        {
                            desc = ' Config',
                            group = 'Number',
                            action = 'Telescope find_files cwd=~/.config/nvim',
                            key = 'c',
                        },
                    },
                    packages = { enable = true },
                    project = {
                        enable = true,
                        limit = 8,
                        icon = ' ',
                        label = 'Projects',
                        action = function(path)
                            vim.cmd('Telescope find_files cwd=' .. path)
                        end,
                    },
                    mru = {
                        limit = 10,
                        icon = ' ',
                        label = 'Recent files',
                        cwd_only = false,
                    },
                    footer = {
                        "🎉 Have a great coding session! 🚀"
                    },
                },
            })
        end,
    },
}

