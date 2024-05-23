return {
    "stevearc/conform.nvim",
    opts = {},
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                cpp = { "clang-format" },
                fortran = { { "findent", "fprettify" } },
                python = { { "isort", "black", "autopep8" } },
            },
            -- format_on_save = {
            --     lsp_fallback = true,
            --     async = false,
            --     timeout_ms = 500,
            -- },
        })
        --- AUTOFORMATTING
        -- 1. Old style
        -- vim.keymap.set("n", "<leader>f", function()
        --     vim.lsp.buf.format { async = true }
        -- end, opts)
        -- 2. New way (Conform)
        vim.keymap.set('n', '<leader>f',
            function() require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 500, }) end,
            { desc = "Format current buffer" })
    end
}
