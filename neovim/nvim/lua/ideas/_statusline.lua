--[[
Neovim Statusline Module
=======================

A comprehensive statusline module for Neovim that provides a clean, informative,
and efficient status display. This module integrates with other core components
to show Git information, diagnostics, and file status in a visually appealing way.

Visual Components
---------------
The statusline is divided into several sections, from left to right:
1. Mode indicator (Normal, Insert, Visual, etc.)
2. Git information (branch and status)
3. File information (name, type, and status)
4. Diagnostic information (errors, warnings)
5. Position information (line:column and percentage)

Each section is clearly separated with brackets and uses consistent spacing
for optimal readability.

Theme Customization
-----------------
The statusline appearance can be customized through the THEME table, which
defines colors and styles for each component. Each theme entry supports:
- fg: Foreground color (hex format)
- bg: Background color (hex format)
- bold: Boolean for bold text

Example theme customization:
```lua
local THEME = {
    mode = { fg = "#000000", bg = "#ffffff", bold = true },
    git = { fg = "#0f3635", bg = "#cfd0d1", bold = true },
    -- ... additional theme entries
}
```

Dependencies
-----------
- core.git: Provides Git repository information
- nvim-web-devicons: Provides filetype icons
--]]

-- Import our core git functionality module
local git = require("core.git")

local git_info_cache = {
    info = "",
    timestamp = 0,
    duration = 30,
}

-- Create our module table
local M = {}

--[[
Theme Configuration
------------------
Defines the visual appearance of each statusline component. Each entry
specifies the colors and text styling for a specific section.

Structure:
- mode: Vim mode indicator styling
- git: Git information section styling
- file: File information styling
- modified: File modification indicator styling
- diagnostics: Error/warning count styling
- position: Cursor position styling
- percentage: File position percentage styling
--]]
local THEME = {
    mode = { fg = "#0f3635", bg = "#cfd0d1", bold = true },
    git = { fg = "#0f3635", bg = "#cfd0d1", bold = true },
    file = { fg = "#0f3635", bg = "#cfd0d1" },
    modified = { fg = "#0f3635", bg = "#cfd0d1" },
    diagnostics = { fg = "#0f3635", bg = "#cfd0d1" },
    position = { fg = "#0f3635", bg = "#cfd0d1" },
    percentage = { fg = "#0f3635", bg = "#cfd0d1" }
}

--[[
Icon Definitions
---------------
Centralizes all icons used in the statusline for easy customization
and consistent appearance across the interface.

Categories:
- modified: Indicators for file modification state
- readonly: Readonly file indicator
- diagnostic: Different diagnostic severity indicators
- git: Git status and branch indicators
--]]
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


--[[
Mode Display Mappings
--------------------
Comprehensive mapping of Vim mode codes to their human-readable names.
This table covers all Vim modes including their variants and special states.

Categories:
- Normal mode and its variants
- Visual mode variants
- Select mode variants
- Insert mode variants
- Replace mode variants
- Command and terminal modes
--]]
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

--[[
Joins multiple statusline items with proper spacing.

@param items table: Array of items to join
@return string: Space-separated string of items
--]]
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

--[[
Creates a combined section for diagnostics and filetype information.
The section will be wrapped in parentheses and only shown if there's
content to display.

@param diagnostics string: Formatted diagnostic information
@param filetype string: Current buffer's filetype
@return string: Combined section wrapped in parentheses, or empty string if no content
--]]
local function create_combined_section(diagnostics, filetype)
    -- Filter out empty strings
    local parts = vim.tbl_filter(function(item)
        return item and item ~= ""
    end, { diagnostics, filetype })

    -- Return empty string if no content
    if #parts == 0 then
        return ""
    end

    -- Join parts with space and wrap in parentheses
    return string.format("[%s] ", table.concat(parts, " | "))
end

--[[
Creates a bracketed section from multiple items.

@param items table: Array of items to include in the section
@return string: Formatted section with brackets and proper spacing
--]]
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

--[[
Gets the formatted display name for the current Vim mode.

@return string: Uppercase name of the current mode
--]]
local function get_mode_display()
    local current_mode = vim.fn.mode()
    local mode_name = MODE_MAPPINGS[current_mode] or MODE_MAPPINGS["null"]
    return mode_name:upper()
end

--[[
Retrieves current file status information.

@return table: Table containing:
    - is_modified: Modified status indicator
    - is_readonly: Readonly status indicator
    - filetype: Current buffer's filetype
    - icon: Filetype icon from nvim-web-devicons
--]]
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

--[[
Retrieves diagnostic information with caching for performance.

@return table: Table containing counts of:
    - errors: Number of error diagnostics
    - warnings: Number of warning diagnostics
    - info: Number of information diagnostics
    - hints: Number of hint diagnostics
--]]
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


--[[
Formats diagnostic information for statusline display.

@return string: Formatted string showing error and warning counts
--]]
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

--[[
Sets up highlight groups for the statusline components.
Creates highlight groups based on the THEME configuration.
--]]
local function setup_highlights()
    for name, colors in pairs(THEME) do
        vim.api.nvim_set_hl(0, "Status" .. name:gsub("^%l", string.upper), colors)
    end
end

--[[
Generates the complete statusline string.

This function combines all statusline components into a single string,
properly formatted with highlights and spacing. Components include:
- Current mode
- Git information
- File status and name
- Diagnostic information
- Position information

@return string: Complete statusline string
--]]
function M.get_statusline()

    local file_status = get_file_status()

    -- Get git information with status
    local git_info = git.get_branch()
    local git_section = ""
    if git_info then
        local git_status = git.get_status_string()
        git_section = git_info .. (git_status ~= "" and " " .. git_status or "")
    end

    local current_time = os.time()

    -- Use cached git info if still valid
    if (current_time - git_info_cache.timestamp) < git_info_cache.duration then
        git_section = git_info_cache.info
    else
        local git_branch = git.get_branch()
        if git_branch then
            -- local git_status = git.get_status_string()
            -- git_section = git_branch .. (git_status ~= "" and " " .. git_status or "")
            git_section = git_branch
        end
        git_info_cache.info = git_section
        git_info_cache.timestamp = current_time
    end

    -- Build the statusline using table.concat for efficiency
    return table.concat({
        "%#StatusMode#", create_section({ get_mode_display() }),
        "%#StatusGit#", create_section({ git_section }),
        "%=",
        "%#StatusFile#", join_items({
            file_status.is_readonly,
            file_status.icon,
            "%t",
            file_status.is_modified
        }),
        "%=",
        "%#StatusDiagnostics#", create_combined_section(format_diagnostics(), file_status.filetype),
        "%#StatusPosition#", create_section({ "%l:%c" }),
        "%#StatusPercentage#", create_section({ "%p%%" })
    })
end

--[[
Initializes the statusline module.

This function:
1. Sets up highlight groups
2. Configures the statusline format
3. Sets up autocommands for diagnostic cache management
--]]
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
