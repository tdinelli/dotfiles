return {
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "VeryLazy" },
    config = function()
        require("neogen").setup({
            languages = {
                ["cpp.doxygen"] = require("neogen.configurations.cpp"),
                lua = { template = { annotation_convention = "emmylua" } }
            },
            -- remapping
            vim.keymap.set("n", "<leader>cc", ":lua require('neogen').generate({ type = 'class' })<CR>",
                { desc = "[C]omment [C]lass" }),
            vim.keymap.set("n", "<leader>cf", ":lua require('neogen').generate({ type = 'func' })<CR>",
                { desc = "[C]omment [F]unction" }),
            vim.keymap.set("n", "<leader>ct", ":lua require('neogen').generate({ type = 'type' })<CR>",
                { desc = "[C]omment [T]ype" }),
        })
    end,

}
