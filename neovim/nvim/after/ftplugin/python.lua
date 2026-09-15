local indentation = {
    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,
    expandtab = true,
    smartindent = true,
    breakindent = true,
    textwidth = 120,
    colorcolumn = "120",
}
for key, value in pairs(indentation) do
    vim.opt[key] = value
end
