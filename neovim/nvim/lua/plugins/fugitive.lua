return {
    "tpope/vim-fugitive",
    keys = { "<leader>gs" },
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "[G]it [S]tatus" })
    end,
}
