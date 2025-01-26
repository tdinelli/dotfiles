return {
    "p00f/alabaster.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd.colorscheme("alabaster")
        vim.api.nvim_set_hl(0, "Visual", { bg = "#fc9afc", })
        vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#fc9afc", })
    end
}
