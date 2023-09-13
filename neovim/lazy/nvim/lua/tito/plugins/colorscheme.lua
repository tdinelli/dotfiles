return {
    {
        "catppuccin/nvim", 
        name = "catppuccin", 
        priority = 1000,
        config = function()
            local catppuccin = require('catppuccin')
            catppuccin.setup({
                flavour = "latte",
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = false,
                    treesitter = true,
                    notify = false,
                    mini = false,
                    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
                },
            })
            -- load the colorscheme here
            vim.cmd([[colorscheme catppuccin]])
        end,
    },
}
