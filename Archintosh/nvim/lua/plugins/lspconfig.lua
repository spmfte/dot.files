-- ~/.config/nvim/lua/plugins/lspconfig.lua

return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")

            -- Example setup for a specific language server
            lspconfig.pyright.setup{}
            -- Add additional language servers as needed
        end,
    },
}

