-- This set the cursor always to be fat as in vim
-- vim.opt.guicursor=''
vim.opt.cursorline = true

vim.opt.termguicolors = true
vim.opt.guifont = "font-hack-nerd-font"
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.list = true
vim.opt.listchars = { tab = "\\x20\\x20", eol = "\\u21b5" }

-- set bash like file autocompletion
vim.opt.wildmode = "longest,list,full"
vim.opt.wildmenu = true

-- Folding method
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 100
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
