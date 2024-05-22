-- ~/.config/nvim/lua/plugins/snippets.lua

return {
    {
        "norcalli/snippets.nvim",
        config = function()
            require("snippets").use_suggested_mappings()
        end,
    },
}

