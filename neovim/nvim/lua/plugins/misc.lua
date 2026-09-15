return {
    {
        "danymat/neogen",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("neogen").setup({
                enabled = true,
                languages = {
                    cpp = { template = { annotation_convention = "doxygen" } },
                    c = { template = { annotation_convention = "doxygen" } },
                },
            })
            vim.keymap.set("n", "<Leader>dg", function()
                require("neogen").generate()
            end, { desc = "[D]oc [G]enerate" })
        end,
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
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
        dir = "~/Documents/GitHub/ckgrep/editor/vim",
        name = "vim-ckgrep",
        cmd = "Ckgrep",
        init = function(plugin)
            vim.g.ckgrep_executable = plugin.dir .. "/../../build/source/ckgrep"
        end,
    },
}
