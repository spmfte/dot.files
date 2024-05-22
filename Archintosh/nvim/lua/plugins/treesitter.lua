-- ~/.config/nvim/lua/plugins/treesitter.lua

return {
    {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup{
                highlight = { enable = true },
                indent = { enable = true },
            }
        end,
    },
}

