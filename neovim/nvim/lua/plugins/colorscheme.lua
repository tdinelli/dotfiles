return {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,
    priority = 1000,
    config = function()
        require("github-theme").setup({
            -- ...
        })
        vim.opt.background = "light"
        vim.cmd.colorscheme("github_light")
        vim.api.nvim_set_hl(0, "Visual", { bg = "#f2dcdc" })
        vim.api.nvim_set_hl(0, "Todo", { bg = "#faf7d4", fg = "#ff0d0d" })
        vim.api.nvim_set_hl(0, "TODO", { bg = "#faf7d4", fg = "#ff0d0d" })
    end,
}
