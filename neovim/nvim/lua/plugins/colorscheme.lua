return {
    "yorickpeterse/nvim-grey",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd.colorscheme("grey")

        -- Status line coloring scheme
        vim.api.nvim_set_hl(0, "StatusMode", { fg = "#0f3635", bg = "#cfd0d1", bold = true }) -- Mode color
        vim.api.nvim_set_hl(0, "StatusGit", { fg = "#0f3635", bg = "#cfd0d1", bold = true })  -- Git branch color
        vim.api.nvim_set_hl(0, "StatusFile", { fg = "#0f3635", bg = "#cfd0d1" })              -- File name color
        vim.api.nvim_set_hl(0, "StatusModified", { fg = "#0f3635", bg = "#cfd0d1" })          -- Modified flag color
        vim.api.nvim_set_hl(0, "StatusDiagnostics", { fg = "#0f3635", bg = "#cfd0d1" })       -- Diagnostics color
        vim.api.nvim_set_hl(0, "StatusPosition", { fg = "#0f3635", bg = "#cfd0d1" })          -- Line/column color
        vim.api.nvim_set_hl(0, "StatusPercentage", { fg = "#0f3635", bg = "#cfd0d1" })        -- Added percentage color

        -- Visual highlight
        vim.api.nvim_set_hl(0, "Visual", { bg = "#f2dcdc" })
    end,
}
