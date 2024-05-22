require("lazy").setup({
    spec = {
        { import = "plugins.general" },
        { import = "plugins.tokyonight" },
        { import = "plugins.lualine" },
        { import = "plugins.nvim-cmp" },
        { import = "plugins.lspconfig" },
        { import = "plugins.treesitter" },
        { import = "plugins.snippets" },
        { import = "plugins.plenary" },
        { import = "plugins.web-devicons" },
        { import = "plugins.harpoon" },
        { import = "plugins.telescope" },
        { import = "plugins.nerdtree" },
        { import = "plugins.colorizer" },
        { import = "plugins.cursorline" },
        { import = "plugins.dashboard" },
        { import = "plugins.mason" },  -- Ensure Mason is included here
        -- Add more plugin imports here
    },
    defaults = {
        lazy = true, -- All plugins will be lazy-loaded by default
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

