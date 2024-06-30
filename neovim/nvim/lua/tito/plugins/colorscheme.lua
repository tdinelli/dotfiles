return {
    "p00f/alabaster.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        vim.opt.background = "light"
        vim.cmd([[colorscheme alabaster]])
    end
}
-- return {
--     "projekt0n/github-nvim-theme",
--     lazy = false,
--     priority = 1000,
--     config = function()
--         require("github-theme").setup({})
--         -- vim.cmd([[colorscheme github_dark]])
--         vim.cmd([[colorscheme github_light_default]])
--     end,
-- }
