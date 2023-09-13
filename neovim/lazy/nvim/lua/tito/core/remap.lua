vim.g.mapleader = " "

-- netrw options
-- tree view, no banner on top
vim.g.netrw_liststyle = 3
-- vim.g.netrw_banner = 0
vim.g.netrw_winsize = 30
-- vim.g.netrw_keepdir = 0
vim.keymap.set("n", "<leader>tv", vim.cmd.Lexplore)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move around stuf when in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Ctr-d is half page jumping this two commands allows me to stai always in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- This allows search therm to stay in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]]) -- delete in the void register

-- If I am gonna press leader s it gives me the possibility to change the word I am on
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- TAB remapping
vim.keymap.set("n", "th", "<cmd> tabfirst <CR>")
vim.keymap.set("n", "tj", "<cmd> tabprev <CR>")
vim.keymap.set("n", "tk", "<cmd> tabnext <CR>")
vim.keymap.set("n", "te", "<cmd> tabedit<Space> <CR>")
vim.keymap.set("n", "tm", "<cmd> tabm<Space> <CR>")
vim.keymap.set("n", "tn", "<cmd> tabnew <CR>")
vim.keymap.set("n", "tc", "<cmd> tabclose <CR>")
vim.keymap.set("n", "t1", "<cmd> tabnext 1 <CR>")
vim.keymap.set("n", "t2", "<cmd> tabnext 2 <CR>")
vim.keymap.set("n", "t3", "<cmd> tabnext 3 <CR>")
vim.keymap.set("n", "t4", "<cmd> tabnext 4 <CR>")
vim.keymap.set("n", "t5", "<cmd> tabnext 5 <CR>")
vim.keymap.set("n", "t6", "<cmd> tabnext 6 <CR>")
vim.keymap.set("n", "t7", "<cmd> tabnext 7 <CR>")
vim.keymap.set("n", "t8", "<cmd> tabnext 8 <CR>")
vim.keymap.set("n", "t9", "<cmd> tabnext 9 <CR>")

