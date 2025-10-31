return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    config = function()
        local highlight = {
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
        }

        local hooks = require "ibl.hooks"
        -- Create the highlight groups in the highlight setup hook
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#CCCCCC" })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#D0D0D0" })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#D4D4D4" })
        end)

        require("ibl").setup {
            enabled = true,
            exclude = {
                filetypes = {
                    "help",
                    "terminal",
                    "starter",
                    "lspinfo",
                    "TelescopePrompt",
                    "TelescopeResults",
                    "mason",
                }
            },
            indent = {
                char = '│',
                highlight = highlight,
            },
            scope = { enabled = false },
            whitespace = { remove_blankline_trail = true },
        }
    end,
}
