return {
    "stevearc/conform.nvim",
    opts = {},
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("conform").setup({})
        vim.keymap.set('n', '<leader>f',
            function()
                require("conform").format(
                    {
                        async = false,
                        timeout_ms = 5000,
                        lsp_fallback = true,
                    })
            end,
            { desc = "Format current buffer" }
        )
    end
}
