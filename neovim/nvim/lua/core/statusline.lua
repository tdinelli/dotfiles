local git = require("core.git")

local function gen_section(items)
    local out = ""
    local bracket_left = "["
    local bracket_right = "]"
    local padding = " "
    for _, item in pairs(items) do
        if item ~= "" and item ~= nil then
            if out == "" then
                out = "" .. item
            else
                out = out .. " " .. item
            end
        else
            bracket_left = ""
            bracket_right = ""
            padding = ""
        end
    end
    return bracket_left .. out .. bracket_right .. padding
end

-- sensibly group the vim modes
local function get_mode_group(m)
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
        R = "Rplace",
        Rc = "Rplace",
        Rv = "Rplace",
        Rx = "Rplace",
        c = "Cmd",
        cv = "Cmd",
        ce = "Cmd",
        r = "Prompt",
        rm = "Prompt",
        ["r?"] = "Prompt",
        ["!"] = "Shell",
        t = "Termnl",
        ["null"] = "None",
    }
    return mode_groups[m] or "None"
end

-- get the display name for the group
local function get_mode_group_display_name(mg)
    return mg:upper()
end

-- whether the file has been modified
local function is_modified()
    if vim.bo.modified then
        if vim.bo.readonly then
            return "[-]"
        end
        return "[+]"
    end
    return ""
end

-- whether the file is read-only
local function is_readonly()
    if vim.bo.readonly then
        return "RO"
    end
    return ""
end

local function get_file_icon()
    return require("nvim-web-devicons").get_icon_by_filetype(vim.bo.filetype, { default = true })
end

local function process_diagnostics(prefix, n)
    local out = prefix .. n
    return out
end

local function get_lsp_diagnostics(bufnr)
    local result = {}
    local levels = {
        errors = vim.diagnostic.severity.ERROR,
        warnings = vim.diagnostic.severity.WARN,
        info = vim.diagnostic.severity.INFO,
        hints = vim.diagnostic.severity.HINT,
    }
    for k, level in pairs(levels) do
        result[k] = #vim.diagnostic.get(bufnr, { severity = level })
    end
    return result
end

local function setup_diagnostics()
    local diagnostics = get_lsp_diagnostics()
    local errors, warnings = diagnostics.errors, diagnostics.warnings

    -- No diagnostics
    if errors == 0 and warnings == 0 then return "" end

    local result = {}
    if errors > 0 then
        table.insert(result, process_diagnostics("E: ", errors))
    end
    if warnings > 0 then
        table.insert(result, (errors > 0 and ", " or "") .. process_diagnostics("W: ", warnings))
    end

    return table.concat(result)
end

-- Modified Status_line function with file percentage
function Status_line()
    local mode = vim.fn.mode()
    local mg = get_mode_group(mode)

    return table.concat({
        -- Apply colors using %#[highlight_group]#
        "%#StatusMode#", gen_section({ get_mode_group_display_name(mg) }),
        "%#StatusGit#", gen_section({ git.get_branch() or "" }),
        "%=",
        "%#StatusFile#", gen_section({ is_readonly(), get_file_icon(), "%t", is_modified() }),
        "%=",
        "%#StatusDiagnostics#", gen_section({ setup_diagnostics() }),
        gen_section({ vim.bo.filetype }),
        "%#StatusPosition#", gen_section({ "%l:%c" }),
        "%#StatusPercentage#", gen_section({ "%p%%" }), -- Added percentage section
    })
end

-- Set the statusline
vim.opt.statusline = "%!luaeval('Status_line()')"
vim.opt.laststatus = 3
