-- ~/.config/nvim/lua/plugins/nerdtree.lua

return {
    {
        "preservim/nerdtree",
        config = function()
            vim.api.nvim_set_keymap("n", "<leader>n", ":NERDTreeToggle<CR>", { noremap = true, silent = true })
        end,
    },
}

