return {
    {
        "folke/tokyonight.nvim",
        event = "VimEnter",
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme tokyonight]])
        end,
    },
}

