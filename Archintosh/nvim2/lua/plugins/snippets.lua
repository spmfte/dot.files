return {
    {
        "norcalli/snippets.nvim",
        event = "InsertEnter",
        config = function()
            require("snippets").use_suggested_mappings()
        end,
    },
}

