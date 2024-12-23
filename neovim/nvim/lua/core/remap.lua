local function apply_keymaps(mappings, group_name)
    for i, mapping in ipairs(mappings) do
        if mapping then
            pcall(vim.keymap.set, unpack(mapping))
        else
            vim.notify(string.format("Nil mapping found in %s at index %d", group_name, i), vim.log.levels.WARN)
        end
    end
end

-----------------------------
-- Mix
-----------------------------
local mix = {
    { "n", "<leader>tv", vim.cmd.Lexplore,                                       { desc = "[T]ree [V]iew" } },
    { "n", "<leader>pv", vim.cmd.Ex,                                             { desc = "[P]roject [V]iew" } },
    { "n", "<leader>s",  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Change the word under the cursor" } },
    { "n", "<Esc>",      "<cmd>nohlsearch<CR>" },
}
apply_keymaps(mix, "mix")

-----------------------------
-- Copy and Paste stuff
-----------------------------
local copyandpaste = {
    { "x",          "<leader>p", [["_dP]], { desc = "Paste the internal registry content whithout overriding it" } },
    { { "n", "v" }, "<leader>y", [["+y]],  { desc = "Copy the selection in the system clipboard" } },
    { "n",          "<leader>Y", [["+Y]],  { desc = "Yank line to system clipboard" } },
    { { "n", "v" }, "<leader>d", [["_d]],  { desc = "Delete the selection withouth copying it in vim clipboard" } },
}
apply_keymaps(copyandpaste, "copyandpaste")

-----------------------------
-- Windows resizing
-----------------------------
local splits = {
    -- Maximizing
    { "n", "<C-w>m", [[<C-w>|]],  { desc = "[M]aximize vertical split" } },
    { "n", "<C-w>h", [[<C-w>_]],  { desc = "Maximize [H]orizontal split" } },
    -- Resizing
    { "n", "<C-w>e", [[<C-w>=]],  { desc = "R[e]size split" } },
    { "n", "<M-,>",  [[<c-w>5<]], { desc = "Decrease width" } },
    { "n", "<M-.>",  [[<c-w>5>]], { desc = "Increase width" } },
    { "n", "<M-t>",  [[<C-w>+]],  { desc = "Increase height" } },
    { "n", "<M-s>",  [[<C-w>-]],  { desc = "Decrease height" } },
    -- Detach split
    { "n", "<C-w>d", [[<C-w>T]],  { desc = "Detach split, move the split in a separate tab" } },
}
apply_keymaps(splits, "splits")

-----------------------------
-- tabs
-----------------------------
local tabs = {
    { "n", "th", "<cmd> tabfirst <CR>",       { desc = "[T]ab [H]ead" } },
    { "n", "tj", "<cmd> tabprev <CR>",        { desc = "Move to previous tab" } },
    { "n", "tk", "<cmd> tabnext <CR>",        { desc = "Move to next tab" } },
    { "n", "te", "<cmd> tabedit<Space> <CR>", { desc = "[T]ab [E]dit" } },
    { "n", "tm", "<cmd> tabm<Space> <CR>",    { desc = "[T]ab [M]ove" } },
    { "n", "tn", "<cmd> tabnew <CR>",         { desc = "[T]ab [N]ew" } },
    { "n", "tc", "<cmd> tabclose <CR>",       { desc = "[T]ab [C]locse" } },
    { "n", "t1", "<cmd> tabnext 1 <CR>",      { desc = "Move to [T]ab number [1]" } },
    { "n", "t2", "<cmd> tabnext 2 <CR>",      { desc = "Move to [T]ab number [2]" } },
    { "n", "t3", "<cmd> tabnext 3 <CR>",      { desc = "Move to [T]ab number [3]" } },
    { "n", "t4", "<cmd> tabnext 4 <CR>",      { desc = "Move to [T]ab number [4]" } },
}
apply_keymaps(tabs, "tabs")

-----------------------------
-- Movements
-----------------------------
local movements = {
    -- Center screen after movements
    { "n", "<C-d>", "<C-d>zz", { desc = "Move down fast while remaining in the center" } },
    { "n", "<C-u>", "<C-u>zz", { desc = "Move up fast while remaining in the center" } },
    { "n", "n",     "nzzzv",   { desc = "Keep search matches centered" } },
    { "n", "N",     "Nzzzv",   { desc = "Previous search match (centered)" } },
}
apply_keymaps(movements, "movements")

-----------------------------
-- Some custom commands
-----------------------------
vim.keymap.set("n", "<leader>rp", function()
    local file = vim.fn.expand('%')
    if vim.fn.filereadable(file) == 0 then
        vim.notify("No file to run", vim.log.levels.ERROR)
        return
    end
    if vim.fn.expand('%:e') ~= 'py' then
        vim.notify("Not a Python file", vim.log.levels.ERROR)
        return
    end
    vim.cmd('term python ' .. file)
end, { desc = "[R]un [P]ython" })

-- Doxygen inline variable comments
vim.api.nvim_create_user_command('DoxygenComment', function()
    local line = vim.api.nvim_get_current_line()
    if not line:match("//!<") then
        vim.cmd([[s/$/\ \/\/\!\<\ /]])
    end
end, { desc = "Add Doxygen inline comment at end of line", bang = true, bar = true, }
)
vim.keymap.set("n", "<leader>dc", "<cmd>DoxygenComment<CR>", { desc = "[D]oxygen [C]omment" })

-----------------------------
-- Latex flavour
-----------------------------
vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    callback = function()
        vim.b.tex_flavor = "latex"
    end,
})
