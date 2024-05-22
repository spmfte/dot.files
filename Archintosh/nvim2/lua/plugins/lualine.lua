return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VimEnter",
        config = function()
            require("lualine").setup({
                options = {
                    theme = "tokyonight"
                }
            })
        end,
    },
}

