-- General settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true

-- Performance optimization
vim.opt.lazyredraw = true
vim.opt.synmaxcol = 200
vim.opt.updatetime = 300

-- Enable true color support
vim.opt.termguicolors = true

-- Folding settings
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99  -- Set to a high value to keep everything unfolded by default

