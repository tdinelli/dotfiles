return {
    'lukas-reineke/indent-blankline.nvim',
    event = "VeryLazy",
    main = "ibl",
    config = function()
        require("ibl").setup(
            {
                enabled = true,
                exclude = {
                    filetypes =
                    {
                        "help",
                        "terminal",
                        "starter",
                        "lspinfo",
                        "TelescopePrompt",
                        "TelescopeResults",
                        "mason",
                    }
                },
                indent = { char = "┊", smart_indent_cap = true },
                scope = { enabled = false },
                whitespace = { remove_blankline_trail = true, },
            }
        )
    end,
}
