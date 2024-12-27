local indentation = {
    tabstop = 3,
    softtabstop = 3,
    shiftwidth = 3,
    expandtab = true,   -- Use spaces instead of tabs
    smartindent = true, -- Smart autoindenting on new lines
    breakindent = true, -- Preserve indentation on wrapped lines
    textwidth = 89,
    wrap = true,
    spell = true
}
for key, value in pairs(indentation) do
    vim.opt[key] = value
end
