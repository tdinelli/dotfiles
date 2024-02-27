-- Set <leader> key to space
vim.g.mapleader = " "

-- netrw options
vim.g.netrw_liststyle = 0
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
-- TAB remapping. (Don't know if needed again)
vim.keymap.set("n", "th", "<cmd> tabfirst <CR>", { desc = "[T]ab [H]ead" })
vim.keymap.set("n", "tj", "<cmd> tabprev <CR>", { desc = "Move to previous tab" })
vim.keymap.set("n", "tk", "<cmd> tabnext <CR>", { desc = "Move to next tab" })
vim.keymap.set("n", "te", "<cmd> tabedit<Space> <CR>", { desc = "" })
vim.keymap.set("n", "tm", "<cmd> tabm<Space> <CR>", { desc = "" })
vim.keymap.set("n", "tn", "<cmd> tabnew <CR>", { desc = "" })
vim.keymap.set("n", "tc", "<cmd> tabclose <CR>", { desc = "[T]ab [C]locse" })
vim.keymap.set("n", "t1", "<cmd> tabnext 1 <CR>", { desc = "Move to [T]ab number [1]" })
vim.keymap.set("n", "t2", "<cmd> tabnext 2 <CR>", { desc = "Move to [T]ab number [2]" })
vim.keymap.set("n", "t3", "<cmd> tabnext 3 <CR>", { desc = "Move to [T]ab number [3]" })
vim.keymap.set("n", "t4", "<cmd> tabnext 4 <CR>", { desc = "Move to [T]ab number [4]" })

-- ================================================================= --
-- Down below I have my custom commands some of them are broken :)   --
-- ================================================================= --

-- Run Python file
vim.keymap.set("n", "<leader>rp", "<Cmd>term python %<CR>", { desc = "[R]un [P]ython", noremap = true, silent = true })

-- Comment doxygen inline for c/c++
vim.keymap.set("n", "<leader>cl", [[:s/$/\ \/\/\!\<\ /g<Left><Left>]], { desc = "[C]omment [L]ine" })

-- Underline cursor line
vim.keymap.set("n", "<leader>nl", [[:hi clear CursorLine]], { desc = "TODO" })
vim.keymap.set("n", "<leader>tl", [[:hi CursorLine guibg=NONE ctermbg=NONE gui=underline cterm=underline]], { desc = "TODO" })
