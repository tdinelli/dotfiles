return {
    "p00f/alabaster.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "nvim-tree/nvim-web-devicons", },
    config = function()
        vim.opt.background = "light"
        vim.cmd.colorscheme("alabaster")
        vim.api.nvim_set_hl(0, "Visual", { bg = "#f2dcdc" })
        vim.api.nvim_set_hl(0, "Todo", { bg = "#faf7d4", fg = "#ff0d0d" })
        vim.api.nvim_set_hl(0, "TODO", { bg = "#faf7d4", fg = "#ff0d0d" })
    end
}
