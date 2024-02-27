
return {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    config = function()
        require("gitblame").setup {
            enabled = false,
        }

        -- remapping
        vim.keymap.set("n", "<leader>gb", vim.cmd.GitBlameToggle, { desc = "[G]it [B]lame toggle" })
    end,
}
