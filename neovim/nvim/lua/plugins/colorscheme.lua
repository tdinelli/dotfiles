-- return {
--     "idr4n/github-monochrome.nvim",
--     lazy = false,
--     priority = 1000,
--     opts = {
--         styles = {
--             comments = { italic = true },
--             conditionals = { bold = true },
--             loops = { bold = false },
--             variables = {},
--             floats = "dark",
--             sidebars = "dark",
--         },
--     },
--     config = function()
--         vim.cmd.colorscheme("github-monochrome-light")
--         vim.api.nvim_set_hl(0, "Visual", { bg = "#c48ba1", fg = "white" })
--         vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#c48ba1", fg = "white" })
--     end,
-- }


return {
    "p00f/alabaster.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd.colorscheme("alabaster")
    end,
}
