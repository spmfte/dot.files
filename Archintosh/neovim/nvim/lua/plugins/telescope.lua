-- ~/.config/nvim/lua/plugins/telescope.lua

return {
    {
        "nvim-telescope/telescope.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup{}
        end,
    },
}

