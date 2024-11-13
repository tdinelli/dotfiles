-- return {
--     "p00f/alabaster.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--         vim.opt.background = "light"
--         vim.cmd([[colorscheme alabaster]])
--     end
-- }
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
-- return {
--     "yorik1984/newpaper.nvim",
--     priority = 1000,
--     lazy = false,
--     config = function()
--         vim.opt.background = "light"
--         vim.cmd([[colorscheme newpaper]])
--     end
-- }
-- return {
--     "zenbones-theme/zenbones.nvim",
--     dependencies = "rktjmp/lush.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--         -- vim.g.zenbones_darken_comments = 45
--         vim.opt.background = "light"
--         vim.cmd.colorscheme('zenbones')
--     end
-- }
-- return {
--     "haystackandroid/rusticated",
--     lazy = false,
--     priority = 1000,
--     config = function()
--         vim.opt.background = "light"
--         vim.cmd.colorscheme("rusticated")
--     end
-- }
-- Not tested yet
-- https://github.com/protesilaos/tempus-themes?tab=readme-ov-file
return {
    "yorickpeterse/nvim-grey",
    lazy = false,
    priority = 1000,
    config = function()
        vim.opt.background = "light"
        vim.cmd.colorscheme("grey")
        vim.api.nvim_set_hl(0, "Visual", { bg = "#f2dcdc" })
        vim.api.nvim_set_hl(0, "Todo", { bg = "#faf7d4", fg = "#ff0d0d" })
        vim.api.nvim_set_hl(0, "TODO", { bg = "#faf7d4", fg = "#ff0d0d" })
    end,
}
