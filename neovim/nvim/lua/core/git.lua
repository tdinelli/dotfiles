local M = {}

-- Cache git information with a timeout
local cache = {
    branch = nil,
    branch_timestamp = 0,
    cache_timeout = 30, -- seconds
}

-- Helper function to check if cache is valid
local function is_cache_valid()
    return os.time() - cache.branch_timestamp < cache.cache_timeout
end

-- Helper function to parse git blame output
local function parse_blame_info(blame_info)
    if not blame_info[2] then
        return blame_info[1]
    end

    local info = {
        hash = string.sub(blame_info[1], 1, 8),
        author = string.sub(blame_info[2], 8),
        date = os.date('%Y %b %d', tonumber(string.sub(blame_info[4], 12))),
        summary = string.sub(blame_info[10], 9)
    }

    return string.format("%s - %s - %s - %s",
        info.hash, info.author, info.date, info.summary)
end

-- Get git blame information for current line
function M.blame_line()
    local bufnr = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(bufnr)

    -- Check if we're in a valid buffer with a file
    if filename == '' then
        vim.notify("No file in current buffer", vim.log.levels.WARN)
        return
    end

    local row = vim.api.nvim_win_get_cursor(0)[1]

    -- Run git blame command
    local ok, blame_info = pcall(vim.fn.systemlist,
        string.format('git blame -L %d,+1 %s --porcelain', row, filename))

    if not ok then
        vim.notify("Failed to get git blame info", vim.log.levels.ERROR)
        return
    end

    -- Parse and display blame information
    local message = parse_blame_info(blame_info)
    vim.notify(message, vim.log.levels.INFO)
end

-- Get current git branch
function M.get_branch()
    -- Return cached branch name if valid
    if cache.branch and is_cache_valid() then
        return cache.branch
    end

    -- Run git branch command
    local ok, branch = pcall(vim.fn.systemlist, 'git branch --show')

    if not ok or not branch[1] or string.find(branch[1], 'fatal') then
        cache.branch = ""
        cache.branch_timestamp = os.time()
        return nil
    end

    -- Update cache
    cache.branch = " " .. branch[1]
    cache.branch_timestamp = os.time()

    return cache.branch
end

-- Create user commands
local function setup_commands()
    vim.api.nvim_create_user_command("GitBlame", function()
        M.blame_line()
    end, {
        desc = "Show git blame information for current line",
    })
end

-- Initialize module
function M.setup(opts)
    opts = opts or {}
    cache.cache_timeout = opts.cache_timeout or 30
    setup_commands()
end

-- Optional: Add keymaps
local default_keymaps = {
    { "n", "<leader>gb", M.blame_line, { desc = "[G]it [B]lame current line" } },
}

function M.setup_keymaps(keymaps)
    keymaps = keymaps or default_keymaps
    for _, map in ipairs(keymaps) do
        vim.keymap.set(unpack(map))
    end
end

return M
