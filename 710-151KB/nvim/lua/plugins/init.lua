return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },
  {
  "github/copilot.vim",
  lazy = false,
  config = function()  -- Mapping tab is already used by NvChad
    vim.g.copilot_no_tab_map = true;
    vim.g.copilot_assume_mapped = true;
    vim.g.copilot_tab_fallback = "";
  -- The mapping is set to other key, see custom/lua/mappings
  -- or run <leader>ch to see copilot mapping section
  end
  },
  {
  "epwalsh/pomo.nvim",
  version = "*",  -- Recommended, use latest release instead of latest commit
  lazy = true,
  cmd = { "TmerStart", "TimerRepeat" },
  dependencies = {
    -- Optional, but highly recommended if you want to use the "Default" timer
    "rcarriga/nvim-notify",
  },
  opts = {
    -- See below for full list of options 👇
  },
},
  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
  	"williamboman/mason.nvim",
  	opts = {
  		ensure_installed = {
  			"lua-language-server", "stylua",
  			"html-lsp", "css-lsp" , "prettier"
  		},
  	},
  },

  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  			"vim", "lua", "vimdoc",
       "html", "css"
  		},
  	},
  },
  {
   "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    lazy = false,
    dependencies = {
    { "github/copilot.vim" },
    { "nvim-lua/plenary.nvim" },
  },
  build = "make tiktoken", -- Only on macOS or Linux
    config = function()
      require("configs.copilotchat").setup() -- Use the config file you just created
    end,
  },
  {
  "ellisonleao/glow.nvim", config = true, cmd = "Glow"

  },
}
