local M = {}
local git = require("core.git")
local devicons = require("nvim-web-devicons")

--------------------------------------------
-- Safe require for devicons
--------------------------------------------
local has_devicons, _ = pcall(require, "nvim-web-devicons")
if not has_devicons then
    vim.notify("nvim-web-devicons not found", vim.log.levels.WARN)
end

--------------------------------------------
-- Add error handling for git operations
--------------------------------------------
local function safe_get_branch()
    local ok, branch = pcall(git.get_branch)
    return ok and branch or ""
end

--------------------------------------------
-- Highlight Configuration
--------------------------------------------
local highlights = {
    mode = { fg = "#0f3635", bg = "#cfd0d1", bold = true },
    git = { fg = "#0f3635", bg = "#cfd0d1", bold = true },
    file = { fg = "#0f3635", bg = "#cfd0d1" },
    modified = { fg = "#0f3635", bg = "#cfd0d1" },
    diagnostics = { fg = "#0f3635", bg = "#cfd0d1" },
    position = { fg = "#0f3635", bg = "#cfd0d1" },
    percentage = { fg = "#0f3635", bg = "#cfd0d1" }
}

local function setup_highlights()
    for name, colors in pairs(highlights) do
        local ok, err = pcall(vim.api.nvim_set_hl, 0,
            "Status" .. name:gsub("^%l", string.upper), colors)
        if not ok then
            vim.notify("Failed to set highlight: " .. err, vim.log.levels.ERROR)
        end
    end
end

--------------------------------------------
-- Improved file status with safe icon fetching
--------------------------------------------
local function get_file_status()
    local icon = ""
    if has_devicons then
        icon = devicons.get_icon_by_filetype(vim.bo.filetype) or ""
    end

    return {
        readonly = vim.bo.readonly and "RO" or "",
        modified = vim.bo.modified and "[+]" or "",
        icon = icon,
        name = "%t",
    }
end

-----------------------------
-- Mode Handling
-----------------------------
local mode_groups = {
    n = "Normal",
    no = "Nop",
    nov = "Nop",
    noV = "Nop",
    ["noCTRL-V"] = "Visual",
    niI = "Normal",
    niR = "Normal",
    niV = "Normal",
    v = "Visual",
    V = "Visual",
    ["CTRL-V"] = "Visual",
    s = "Select",
    S = "Select",
    ["CTRL-S"] = "Select",
    i = "Insert",
    ic = "Insert",
    ix = "Insert",
    R = "Replace",
    Rc = "Replace",
    Rv = "Replace",
    Rx = "Replace",
    c = "Cmd",
    cv = "Cmd",
    ce = "Cmd",
    r = "Prompt",
    rm = "Prompt",
    ["r?"] = "Prompt",
    ["!"] = "Shell",
    t = "Terminal",
    ["null"] = "None",
}

local function get_mode()
    local mode = vim.fn.mode()
    return (mode_groups[mode] or "None"):upper()
end

-----------------------------
-- File Status
-----------------------------
local function get_file_status()
    local status = {
        readonly = vim.bo.readonly and "RO" or "",
        modified = vim.bo.modified and (vim.bo.readonly and "[-]" or "[+]") or "",
        icon = devicons.get_icon_by_filetype(vim.bo.filetype, { default = true }),
        name = "%t",
    }

    return status
end

-----------------------------
-- Diagnostics
-----------------------------
local diagnostic_signs = {
    errors = " ", -- You can customize these icons
    warnings = " ",
    info = " ",
    hints = " ",
}

local function get_diagnostics()
    local diagnostics = {}
    local levels = {
        errors = vim.diagnostic.severity.ERROR,
        warnings = vim.diagnostic.severity.WARN,
        info = vim.diagnostic.severity.INFO,
        hints = vim.diagnostic.severity.HINT,
    }

    for name, level in pairs(levels) do
        local count = #vim.diagnostic.get(0, { severity = level })
        if count > 0 then
            table.insert(diagnostics, diagnostic_signs[name] .. count)
        end
    end

    return #diagnostics > 0 and table.concat(diagnostics, " ") or ""
end

-----------------------------
-- Section Generator
-----------------------------
local function gen_section(items)
    local content = table.concat(vim.tbl_filter(function(item)
        return item and item ~= ""
    end, items), " ")

    return content ~= "" and string.format("[%s] ", content) or ""
end

-----------------------------
-- Statusline Builder
-----------------------------
function M.get_statusline()
    local file_status = get_file_status()

    local sections = {
        left = {
            { highlight = "StatusMode", content = get_mode() },
            { highlight = "StatusGit",  content = git.get_branch() or "" },
        },
        middle = {
            {
                highlight = "StatusFile",
                content = table.concat({
                    file_status.readonly,
                    file_status.icon,
                    file_status.name,
                    file_status.modified,
                }, " "):gsub("%s+", " ")
            },
        },
        right = {
            { highlight = "StatusDiagnostics", content = get_diagnostics() },
            { highlight = "StatusFile",        content = vim.bo.filetype },
            { highlight = "StatusPosition",    content = "%l:%c" },
            { highlight = "StatusPercentage",  content = "%p%%" },
        },
    }

    local statusline = {}

    -- Add left sections
    for _, section in ipairs(sections.left) do
        if section.content ~= "" then
            table.insert(statusline, string.format("%%#%s#%s",
                section.highlight, gen_section({ section.content })))
        end
    end

    -- Add middle sections
    table.insert(statusline, "%=")
    for _, section in ipairs(sections.middle) do
        if section.content ~= "" then
            table.insert(statusline, string.format("%%#%s#%s",
                section.highlight, gen_section({ section.content })))
        end
    end

    -- Add right sections
    table.insert(statusline, "%=")
    for _, section in ipairs(sections.right) do
        if section.content ~= "" then
            table.insert(statusline, string.format("%%#%s#%s",
                section.highlight, gen_section({ section.content })))
        end
    end

    return table.concat(statusline)
end

-----------------------------
-- Setup
-----------------------------
function M.setup(opts)
    opts = opts or {}
    if opts.highlights then
        highlights = vim.tbl_deep_extend("force", highlights, opts.highlights)
    end

    -- Ensure git is set up
    git.setup({ cache_timeout = 30 })

    -- Set up highlights
    setup_highlights()

    -- Set statusline
    vim.opt.statusline = "%!luaeval('require(\"statusline\").get_statusline()')"
    vim.opt.laststatus = 3

    -- Force initial render
    vim.cmd("redrawstatus!")
end

return M
