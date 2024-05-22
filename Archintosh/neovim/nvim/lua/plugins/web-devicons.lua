-- ~/.config/nvim/lua/plugins/web-devicons.lua

return {
    {
        "nvim-tree/nvim-web-devicons",
        config = function()
            require("nvim-web-devicons").setup { default = true }
        end,
    },
}

