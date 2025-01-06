return {
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("Comment").setup()
        end,
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
    },
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            signs = false,
            keywords = {
                FIX = { color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, },
                TODO = { color = "info" },
                HACK = { color = "warning" },
                WARN = { color = "warning", alt = { "WARNING", "XXX" } },
                PERF = { alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { color = "hint", alt = { "INFO" } },
                TEST = { color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
            },
            colors = {
                error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
                warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
                info = { "DiagnosticInfo", "#2563EB" },
                hint = { "DiagnosticHint", "#10B981" },
                default = { "Identifier", "#7C3AED" },
                test = { "Identifier", "#FF00FF" }
            },
        }
    },
    {
        "f-person/git-blame.nvim",
        keys = { "<leader>gb" },
        config = function()
            require("gitblame").setup { enabled = false }
            vim.keymap.set("n", "<leader>gb", vim.cmd.GitBlameToggle, { desc = "[G]it [B]lame toggle" })
        end,
    },
    {
        "tpope/vim-fugitive",
        keys = { "<leader>gs" },
        config = function()
            vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "[G]it [S]tatus" })
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
}
