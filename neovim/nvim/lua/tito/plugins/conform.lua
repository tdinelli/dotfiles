return {
    "stevearc/conform.nvim",
    opts = {},
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                cpp = { "clang-format" },
                fortran = { { "findent", "fprettify" } },
                -- python = { "isort", "black", "autopep8" },
                python = { "black" },
                cmake = { "cmake_format" },
            },
            formatters = {
                black = {
                    prepend_args = { '--fast', '--line-length', '120' },
                },
                cmake_format = {
                    prepend_args = {
                        '--line-width', '80',
                        '--enable-markup',
                        '--command-case', 'lower',
                        '--keyword-case', 'lower',
                        '--dangle-parens', 'true',
                        '--separate-ctrl-name-with-space', 'true',
                        '--separate-fn-name-with-space', 'true',
                        '--line-ending', 'unix',
                    },
                },
            },

        })
        --- AUTOFORMATTING
        -- 1. Old style
        -- vim.keymap.set("n", "<leader>f", function()
        --     vim.lsp.buf.format { async = true }
        -- end, opts)
        -- 2. New way (Conform)
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
