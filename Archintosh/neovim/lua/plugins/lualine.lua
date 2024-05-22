-- ~/.config/nvim/lua/plugins/lualine.lua

return {
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        config = function()
            require("lualine").setup({
                options = {
                    theme = "tokyonight"
                }
            })
        end,
    },
}

