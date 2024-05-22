return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lspconfig = require("lspconfig")

            -- Example setup for a specific language server
            lspconfig.pyright.setup{}
            -- Add additional language servers as needed
        end,
    },
}

