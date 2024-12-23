-----------------------------
-- Global settings
-----------------------------
local global = {
    netrw_liststyle = 0,
    netrw_winsize = 30,
}
for option, value in pairs(global) do
    vim.g[option] = value
end
