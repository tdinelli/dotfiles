local indentation = {
    tabstop = 2,
    softtabstop = 2,
    shiftwidth = 2,
    expandtab = true,   -- Use spaces instead of tabs
    smartindent = true, -- Smart autoindenting on new lines
    breakindent = true, -- Preserve indentation on wrapped lines
    textwidth = 120
}
for key, value in pairs(indentation) do
    vim.opt[key] = value
end

