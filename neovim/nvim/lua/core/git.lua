-- Enhanced git functionality module that complements git-blame.nvim
local M = {}

-- Cache system for git information to optimize performance
local cache = {
    branch = nil,
    branch_timestamp = 0,
    cache_duration = 5, -- Cache duration in seconds
    head_oid = nil,     -- Store the current HEAD commit hash
    head_timestamp = 0
}

-- Execute git commands safely with proper error handling
local function execute_git_command(cmd)
    -- We use vim.system when possible as it's more efficient than systemlist
    local output = vim.fn.systemlist(cmd)

    -- Check for common error conditions
    if vim.v.shell_error ~= 0 or not output[1] or string.find(output[1], 'fatal') then
        return nil
    end

    return output
end

-- Check if current directory is inside a git repository
function M.is_git_repo()
    if not cache.is_git_repo then
        local result = execute_git_command('git rev-parse --is-inside-work-tree')
        cache.is_git_repo = result ~= nil
    end
    return cache.is_git_repo
end

-- Get the current HEAD commit hash
function M.get_head_oid()
    local current_time = os.time()

    -- Return cached HEAD if still valid
    if cache.head_oid and (current_time - cache.head_timestamp) < cache.cache_duration then
        return cache.head_oid
    end

    local head = execute_git_command('git rev-parse --short HEAD')
    if head then
        cache.head_oid = head[1]
        cache.head_timestamp = current_time
        return cache.head_oid
    end

    return nil
end

-- Get current git branch with efficient caching
function M.get_branch()
    -- Early return if we're not in a git repo
    if not M.is_git_repo() then
        return nil
    end

    local current_time = os.time()

    -- Return cached branch name if still valid
    if cache.branch and (current_time - cache.branch_timestamp) < cache.cache_duration then
        return cache.branch
    end

    -- Get current branch from git
    local branch_info = execute_git_command('git branch --show')

    if not branch_info then
        cache.branch = nil
        cache.branch_timestamp = current_time
        return nil
    end

    -- Update cache and return branch name with icon
    cache.branch = string.format(" %s", branch_info[1])
    cache.branch_timestamp = current_time
    return cache.branch
end

-- Get git status information for the current repository
function M.get_status()
    if not M.is_git_repo() then
        return { ahead = 0, behind = 0, staged = 0, changed = 0 }
    end

    local status = {
        ahead = 0,
        behind = 0,
        staged = 0,
        changed = 0
    }

    -- Get ahead/behind count
    local remote_status = execute_git_command('git rev-list --left-right --count HEAD...@{upstream}')
    if remote_status and remote_status[1] then
        local ahead, behind = remote_status[1]:match("(%d+)%s+(%d+)")
        status.ahead = tonumber(ahead) or 0
        status.behind = tonumber(behind) or 0
    end

    -- Get staged/unstaged changes
    local diff_status = execute_git_command('git status --porcelain')
    if diff_status then
        for _, line in ipairs(diff_status) do
            local staged = line:sub(1, 1)
            local unstaged = line:sub(2, 2)

            if staged ~= ' ' and staged ~= '?' then
                status.staged = status.staged + 1
            end
            if unstaged ~= ' ' and unstaged ~= '?' then
                status.changed = status.changed + 1
            end
        end
    end

    return status
end

-- Format status information for statusline display
function M.get_status_string()
    if not M.is_git_repo() then
        return ""
    end

    local status = M.get_status()
    local parts = {}

    if status.ahead > 0 then
        table.insert(parts, string.format("↑%d", status.ahead))
    end
    if status.behind > 0 then
        table.insert(parts, string.format("↓%d", status.behind))
    end
    if status.staged > 0 then
        table.insert(parts, string.format("●%d", status.staged))
    end
    if status.changed > 0 then
        table.insert(parts, string.format("○%d", status.changed))
    end

    return table.concat(parts, " ")
end

-- Clear the cache (useful when git status changes)
function M.clear_cache()
    cache = {
        branch = nil,
        branch_timestamp = 0,
        head_oid = nil,
        head_timestamp = 0,
        is_git_repo = nil
    }
end

-- Set up autocommands to clear cache when needed
local function setup_autocmds()
    local group = vim.api.nvim_create_augroup("GitStatusCache", { clear = true })

    vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained", "DirChanged" }, {
        group = group,
        callback = M.clear_cache,
        desc = "Clear git status cache on relevant events"
    })
end

-- Initialize the module
setup_autocmds()

return M
