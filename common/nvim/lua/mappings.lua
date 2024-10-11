require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("n", "<space>tt", "<cmd>TimerHide<CR>", { noremap = true, silent = true, desc = "Hide Timer" })
map("n", "<space>ts", "<cmd>TimerShow<CR>", { noremap = true, silent = true, desc = "Show Timer" })
map("n", "<space>df", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true, desc = "Show diagnostic floating window" })
map({ "n", "v",}, "<A-o>", "<cmd>CopilotChatToggle<CR>", { noremap = true, silent = true, desc = "Toggle Copilot Chat" })
map("n", "<A-l>", function()
    require("lazy").load({ plugins = { "minty" } }) -- ensure minty is loaded
    require("minty.huefy").open()
end, { noremap = true, silent = true, desc = "Open color picker" })

-- map
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <CR>", { desc = "Save file" })

vim.keymap.set('i', '<C-J>', 'copilot#Accept("<CR>")', {
  expr = true,
  replace_keycodes = false,
  desc = "Copilot accept suggestion"
})
vim.g.copilot_no_tab_map = true
