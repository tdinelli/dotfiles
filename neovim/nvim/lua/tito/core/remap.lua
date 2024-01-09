vim.g.mapleader = " "

-- netrw options
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 30
vim.keymap.set("n", "<leader>tv", vim.cmd.Lexplore, { desc = "[T]ree [V]iew" })
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "[P]roject [V]iew" })

-- Move around stuf when in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "In visual line mode move down the block" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "In visual line mode move up the block" })

-- Ctr-d is half page jumping this two commands allows me to stai always in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move down fast while remaining in the center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move up fast while remaining in the center" })

-- This allows search therm to stay in the middle
vim.keymap.set("n", "n", "nzzzv", { desc = "Non mi ricordo" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Non mi ricordo" })

-- greatest remap ever (past without updating the internal registry)
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste the internal registry content whithout overriding it" })

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy the selection in the external registry" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Non mi ricordo" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]],
    { desc = "Delete the selection withouth pasting it in the internal registry" }) -- delete in the void register

-- If I am gonna press leader s it gives me the possibility to change the word I am on
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Change the word under the cursor" })

-- Think if we will need this again
-- TAB remapping
vim.keymap.set("n", "th", "<cmd> tabfirst <CR>", { desc = "ciao" })
vim.keymap.set("n", "tj", "<cmd> tabprev <CR>", { desc = "" })
vim.keymap.set("n", "tk", "<cmd> tabnext <CR>", { desc = "" })
vim.keymap.set("n", "te", "<cmd> tabedit<Space> <CR>", { desc = "" })
vim.keymap.set("n", "tm", "<cmd> tabm<Space> <CR>", { desc = "" })
vim.keymap.set("n", "tn", "<cmd> tabnew <CR>", { desc = "" })
vim.keymap.set("n", "tc", "<cmd> tabclose <CR>", { desc = "" })
vim.keymap.set("n", "t1", "<cmd> tabnext 1 <CR>", { desc = "" })
vim.keymap.set("n", "t2", "<cmd> tabnext 2 <CR>", { desc = "" })
vim.keymap.set("n", "t3", "<cmd> tabnext 3 <CR>", { desc = "" })
vim.keymap.set("n", "t4", "<cmd> tabnext 4 <CR>", { desc = "" })
vim.keymap.set("n", "t5", "<cmd> tabnext 5 <CR>", { desc = "" })
vim.keymap.set("n", "t6", "<cmd> tabnext 6 <CR>", { desc = "" })
vim.keymap.set("n", "t7", "<cmd> tabnext 7 <CR>", { desc = "" })
vim.keymap.set("n", "t8", "<cmd> tabnext 8 <CR>", { desc = "" })
vim.keymap.set("n", "t9", "<cmd> tabnext 9 <CR>", { desc = "" })
