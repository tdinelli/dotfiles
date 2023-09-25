return {
    'lukas-reineke/indent-blankline.nvim',
    event = "VeryLazy",
    config = function()
        opts = {
            char = '┊',
            show_trailing_blankline_indent = false,
        }
    end,
}
