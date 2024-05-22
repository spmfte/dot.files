return {
    {
        "nvim-tree/nvim-web-devicons",
        event = "VimEnter",
        config = function()
            require("nvim-web-devicons").setup({
                default = true,
                override = {
                    zsh = {
                        icon = "",
                        color = "#428850",
                        cterm_color = "65",
                        name = "Zsh"
                    },
                    log = {
                        icon = "",
                        color = "#81e043",
                        name = "Log"
                    },
                    [".gitignore"] = {
                        icon = "",
                        color = "#f1502f",
                        name = "Gitignore"
                    },
                    ["apple"] = {
                        icon = "",
                        color = "#A2AAAD",
                        cterm_color = "248",
                        name = "Apple",
                    },
                },
                color_icons = true,
                strict = true,
            })
        end,
    },
}

