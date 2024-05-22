-- ~/.config/nvim/lua/plugins/harpoon.lua

return {
    {
        "ThePrimeagen/harpoon",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("harpoon").setup{}
        end,
    },
}

