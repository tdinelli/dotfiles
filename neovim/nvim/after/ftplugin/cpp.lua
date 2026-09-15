local indentation = {
    tabstop = 2,
    softtabstop = 2,
    shiftwidth = 2,
    expandtab = true,
    smartindent = true,
    breakindent = true,
    textwidth = 89,
    colorcolumn = "89",
}
for key, value in pairs(indentation) do
    vim.opt[key] = value
end
