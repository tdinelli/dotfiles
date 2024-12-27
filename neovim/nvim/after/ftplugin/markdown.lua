local indentation = {
    wrap = true,
    spell = true,
    textwidth = 100
}
for key, value in pairs(indentation) do
    vim.opt[key] = value
end
