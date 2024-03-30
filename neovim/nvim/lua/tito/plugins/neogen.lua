return {
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("neogen").setup({
            enabled = true,
            languages = {
                -- ["python.numpydoc"] = require("neogen.configurations.python"),
                -- ["cpp.doxygen"] = require("neogen.configurations.cpp"),
                lua = { template = { annotation_convention = "emmylua" } },
                python = { template = { annotation_convention = "numpydoc" } },
                cpp = { template = { annotation_convention = "doxygen" } }
            },
            -- remapping
            vim.keymap.set("n", "<leader>cc", ":lua require('neogen').generate({ type = 'class' })<CR>",
                { desc = "[C]omment [C]lass" }),
            vim.keymap.set("n", "<leader>cf", ":lua require('neogen').generate({ type = 'func' })<CR>",
                { desc = "[C]omment [F]unction" }),
            vim.keymap.set("n", "<leader>ct", ":lua require('neogen').generate({ type = 'type' })<CR>",
                { desc = "[C]omment [T]ype" }),
            vim.keymap.set("n", "<leader>fi", ":lua require('neogen').generate({ type = 'file' })<CR>",
                { desc = "Comment [F][I]le" }),
        })
    end,

}
