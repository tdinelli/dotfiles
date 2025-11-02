local indentation = {
    tabstop = 2,
    softtabstop = 2,
    shiftwidth = 2,
    expandtab = true,
    smartindent = true,
    breakindent = true,
    textwidth = 89
}
for key, value in pairs(indentation) do
    vim.opt[key] = value
end

-- LSP Semantic Token Highlighting for C
-- Set function names to blue
-- vim.api.nvim_set_hl(0, '@lsp.type.function.c', { fg = '#0451a5', bold = true })
-- vim.api.nvim_set_hl(0, '@lsp.type.method.c', { fg = '#0451a5', bold = true })
-- vim.api.nvim_set_hl(0, '@lsp.type.function', { fg = '#0451a5', bold = true })
-- vim.api.nvim_set_hl(0, '@lsp.type.method', { fg = '#0451a5', bold = true })
