-- core/statusline.lua - A comprehensive statusline module for Neovim
-- This module provides a clean, informative, and efficient statusline
-- that integrates with other core components

-- Import dependencies from our core modules
local git = require("core.git")

-- Create our module table
local M = {}

-- Theme configuration defining our statusline colors and styles
-- These values can be easily customized to match your colorscheme
local THEME = {
    mode = { fg = "#0f3635", bg = "#cfd0d1", bold = true },
    git = { fg = "#0f3635", bg = "#cfd0d1", bold = true },
    file = { fg = "#0f3635", bg = "#cfd0d1" },
    modified = { fg = "#0f3635", bg = "#cfd0d1" },
    diagnostics = { fg = "#0f3635", bg = "#cfd0d1" },
    position = { fg = "#0f3635", bg = "#cfd0d1" },
    percentage = { fg = "#0f3635", bg = "#cfd0d1" }
}

-- Icons used throughout the statusline
-- Using a separate table makes it easy to modify all icons in one place
local ICONS = {
    modified = {
        normal = "[+]",
        readonly = "[-]"
    },
    readonly = "RO",
    diagnostic = {
        error = "E ",
        warning = "W ",
        info = "I ",
        hint = "H "
    },
    git = {
        branch = "",
        ahead = "↑",
        behind = "↓",
        staged = "●",
        changed = "○"
    }
}

-- Comprehensive mapping of Vim modes to their display names
-- This table provides clear, readable names for all Vim modes
local MODE_MAPPINGS = {
    -- Normal mode variants
    n = "Normal",
    no = "Normal-Operator",
    nov = "Normal-Operator-Pending",
    noV = "Normal-Operator-Pending",
    ["noCTRL-V"] = "Normal-Operator-Pending",
    niI = "Normal-Insert",
    niR = "Normal-Replace",
    niV = "Normal-Virtual",

    -- Visual mode variants
    v = "Visual",
    V = "Visual-Line",
    ["CTRL-V"] = "Visual-Block",

    -- Select mode variants
    s = "Select",
    S = "Select-Line",
    ["CTRL-S"] = "Select-Block",

    -- Insert mode variants
    i = "Insert",
    ic = "Insert-Completion",
    ix = "Insert-X",

    -- Replace mode variants
    R = "Replace",
    Rc = "Replace-Completion",
    Rv = "Replace-Virtual",
    Rx = "Replace-X",

    -- Command and terminal modes
    c = "Command",
    cv = "Command-Ex",
    ce = "Command-Ex",
    r = "Prompt",
    rm = "Prompt-More",
    ["r?"] = "Prompt-Confirm",
    ["!"] = "Shell",
    t = "Terminal",

    -- Fallback
    ["null"] = "None"
}

-- Cache for storing diagnostic information to improve performance
local diagnostic_cache = {}

local function join_items(items)
    -- Filter out empty or nil items
    local filtered_items = vim.tbl_filter(function(item)
        return item and item ~= ""
    end, items)
    if #filtered_items == 0 then
        return ""
    end
    -- Join items with a space, but no brackets
    return table.concat(filtered_items, " ") .. " "
end

-- Utility function to create bracketed sections with consistent spacing
local function create_section(items)
    -- Remove empty or nil items to avoid unnecessary brackets
    local filtered_items = vim.tbl_filter(function(item)
        return item and item ~= ""
    end, items)

    if #filtered_items == 0 then
        return ""
    end

    -- Join items with proper spacing and add brackets
    return string.format("[%s] ", table.concat(filtered_items, " "))
end

-- Get the formatted display name for the current mode
local function get_mode_display()
    local current_mode = vim.fn.mode()
    local mode_name = MODE_MAPPINGS[current_mode] or MODE_MAPPINGS["null"]
    return mode_name:upper()
end

-- Get information about the current file's status
local function get_file_status()
    local modified = vim.bo.modified and ICONS.modified.normal or ""
    local readonly = vim.bo.readonly and ICONS.modified.readonly or ""

    -- Get the file icon from nvim-web-devicons
    local icon = require("nvim-web-devicons").get_icon_by_filetype(
        vim.bo.filetype,
        { default = true }
    )

    return {
        is_modified = modified,
        is_readonly = readonly,
        filetype = vim.bo.filetype,
        icon = icon
    }
end

-- Get diagnostic information with caching for better performance
local function get_diagnostics()
    local bufnr = vim.api.nvim_get_current_buf()

    -- Use cached diagnostics if available and still valid
    if not diagnostic_cache[bufnr] or diagnostic_cache[bufnr].tick ~= vim.b[bufnr].changedtick then
        local diagnostics = {
            errors = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR }),
            warnings = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN }),
            info = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.INFO }),
            hints = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.HINT })
        }

        diagnostic_cache[bufnr] = {
            data = diagnostics,
            tick = vim.b[bufnr].changedtick
        }
    end

    return diagnostic_cache[bufnr].data
end

-- Format diagnostic information for display in the statusline
local function format_diagnostics()
    local diagnostics = get_diagnostics()
    local parts = {}

    if diagnostics.errors > 0 then
        table.insert(parts, ICONS.diagnostic.error .. diagnostics.errors)
    end
    if diagnostics.warnings > 0 then
        table.insert(parts, ICONS.diagnostic.warning .. diagnostics.warnings)
    end

    return #parts > 0 and table.concat(parts, " ") or ""
end

-- Set up highlight groups for the statusline
local function setup_highlights()
    for name, colors in pairs(THEME) do
        vim.api.nvim_set_hl(0, "Status" .. name:gsub("^%l", string.upper), colors)
    end
end

-- Generate the complete statusline string
function M.get_statusline()
    local file_status = get_file_status()

    -- Get git information with status
    local git_info = git.get_branch()
    local git_section = ""
    if git_info then
        local git_status = git.get_status_string()
        git_section = git_info .. (git_status ~= "" and " " .. git_status or "")
    end

    -- Build the statusline using table.concat for efficiency
    return table.concat({
        "%#StatusMode#", create_section({ get_mode_display() }),
        "%#StatusGit#", create_section({ git_section }),
        "%=",
        "%#StatusFile#", join_items({ -- Changed this line to use join_items
        file_status.is_readonly,
        file_status.icon,
        "%t",
        file_status.is_modified
    }),
        "%=",
        "%#StatusDiagnostics#", create_section({ format_diagnostics() }),
        create_section({ file_status.filetype }),
        "%#StatusPosition#", create_section({ "%l:%c" }),
        "%#StatusPercentage#", create_section({ "%p%%" })
    })
end

-- Initialize the statusline module
function M.setup()
    -- Set up highlights
    setup_highlights()

    -- Configure the statusline
    vim.opt.statusline = "%!luaeval('require\"core.statusline\".get_statusline()')"
    vim.opt.laststatus = 3

    -- Set up autocommands for diagnostic cache management
    local group = vim.api.nvim_create_augroup("StatuslineDiagnostics", { clear = true })
    vim.api.nvim_create_autocmd({ "DiagnosticChanged", "BufEnter" }, {
        group = group,
        callback = function(args)
            diagnostic_cache[args.buf] = nil
        end
    })
end

return M
