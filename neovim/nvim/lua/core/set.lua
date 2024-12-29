-----------------------------
-- Editor UI
-----------------------------
local ui = {
    termguicolors = true,
    guifont = "font-hack-nerd-font",
    number = true,
    relativenumber = true,
    signcolumn = "yes",
    scrolloff = 8,
    list = true,
    listchars = { tab = "\\x20\\x20", eol = "\\u21b5", trail = "·" },
    lazyredraw = true, -- Don't redraw screen while executing macros
    updatetime = 250,  -- Reduce updatetime from default 4000ms
    redrawtime = 1500, -- Time in milliseconds for redrawing the display
}

-----------------------------
-- Indentation and Formatting
-----------------------------
local indentation = {
    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,
    expandtab = true,   -- Use spaces instead of tabs
    smartindent = true, -- Smart autoindenting on new lines
    breakindent = true, -- Preserve indentation on wrapped lines
    wrap = false,       -- Don't wrap lines
}

-----------------------------
-- Search and Completion
-----------------------------
local search = {
    hlsearch = true,  -- Highlight search results
    incsearch = true, -- Show search matches as you type
    wildmode = "longest,list,full",
    wildmenu = true,  -- Command-line completion
    isfname = "@-@",  -- Characters to be included in file names
}

-----------------------------
-- File Management
-----------------------------
local files = {
    undofile = false, -- No persistent undo
    swapfile = false, -- No swap file
    backup = false,   -- No backup file
    updatetime = 50,  -- Faster completion
}

-----------------------------
-- Folding Configuration
-----------------------------
local folding = {
    foldcolumn = "0", -- Width of fold column (1 is recommended)
    foldmethod = "expr",
    foldexpr = "nvim_treesitter#foldexpr()",
    foldlevel = 100,
    foldlevelstart = 99,
    foldenable = true,
}

-- Apply all settings
local function apply_settings(settings)
    for key, value in pairs(settings) do
        vim.opt[key] = value
    end
end

for _, settings in pairs({ ui, indentation, search, files, folding }) do
    apply_settings(settings)
end

-- Set ColorColumn highlight
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "LightGray" })
