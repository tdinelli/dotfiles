return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "latte",
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    harpoon=true,
                    treesitter = true,
                },
            })
            -- load the colorscheme here
            vim.cmd([[colorscheme catppuccin]])
        end,
    },
}
