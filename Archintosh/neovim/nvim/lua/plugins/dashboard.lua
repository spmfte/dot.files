-- ~/.config/nvim/lua/plugins/dashboard.lua

return {
    {
        "nvimdev/dashboard-nvim",
        requires = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("dashboard").setup{
                -- Configuration options for dashboard-nvim
            }
        end,
    },
}

