local indentation = {
    tabstop = 3,
    softtabstop = 3,
    shiftwidth = 3,
    expandtab = true,
    smartindent = true,
    breakindent = true,
    textwidth = 89,
    wrap = true,
    spell = true
}
for key, value in pairs(indentation) do
    vim.opt[key] = value
end
