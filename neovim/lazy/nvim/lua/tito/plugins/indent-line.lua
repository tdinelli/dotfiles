return {
    'lukas-reineke/indent-blankline.nvim',
    event = "VeryLazy",
    main = "ibl",
    opts = {
        enabled = true,
        exclude = {
            "help",
            "terminal",
            "starter",
            "nvim-tree",
            "packer",
            "lspinfo",
            "TelescopePrompt",
            "TelescopeResults",
            "mason",
            "",
        },
        indent = {char="┊",},
        show_trailing_blankline_indent = false,
        scope = { enabled = false },
        smart_indent_cap = true,
    }
}
