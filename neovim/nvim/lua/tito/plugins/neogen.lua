return {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
    version = "*",
    event = "VeryLazy",
    config = function()
        local neogen = require('neogen')
        neogen.setup({
            languages = {
                ['cpp.doxygen'] = require('neogen.configurations.cpp')
            }
        })
    end,

    -- Neogen remap
    vim.keymap.set("n", "<leader>gc", ":lua require('neogen').generate()<CR>", { desc = "[G]enerate [C]omment" })
}
