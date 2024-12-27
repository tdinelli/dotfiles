--[[
Enhanced Git Functionality Module
===============================

This module provides enhanced Git functionality for Neovim, complementing git-blame.nvim
with efficient caching and status monitoring capabilities. It offers a comprehensive
interface for retrieving Git repository information while maintaining performance
through an intelligent caching system.

Features:
- Efficient Git command execution with proper error handling
- Smart caching system for Git information
- Branch status monitoring
- Detailed Git repository status information
- Automatic cache invalidation through Neovim events

Module Structure
--------------
The module is organized into several key components:
1. Cache system for storing Git information
2. Core Git command execution functionality
3. Public interface for Git information retrieval
4. Auto-command setup for cache management

Usage Example:
```lua
local git = require('your-plugin-name')

-- Get current branch name
local branch = git.get_branch()

-- Get formatted status string
local status = git.get_status_string()

-- Get detailed status information
local details = git.get_status()
```
--]]

local M = {}

--[[
Cache System
-----------
The cache system optimizes performance by storing frequently accessed Git information
with a configurable expiration time. This reduces the number of Git command executions
and improves response time for status updates.

Structure:
- branch: Current Git branch name
- branch_timestamp: Last update time for branch information
- cache_duration: Duration (in seconds) before cache invalidation
- head_oid: Current HEAD commit hash
- head_timestamp: Last update time for HEAD information
- is_git_repo: Boolean indicating if current directory is in a Git repository
--]]
local cache = {
    branch = nil,
    branch_timestamp = 0,
    cache_duration = 5, -- Cache duration in seconds
    head_oid = nil,     -- Store the current HEAD commit hash
    head_timestamp = 0,
    is_git_repo = nil
}

--[[
Executes a Git command safely with proper error handling.

@param cmd string: The Git command to execute
@return table|nil: Output lines from the command, or nil if the command failed
--]]
local function execute_git_command(cmd)
    -- We use vim.system when possible as it's more efficient than systemlist
    local output = vim.fn.systemlist(cmd)

    -- Check for common error conditions
    if vim.v.shell_error ~= 0 then return nil end
    if not output then return nil end
    if #output == 0 then return nil end
    if string.find(output[1] or "", 'fatal') then return nil end

    return output
end

--[[
Checks if the current directory is inside a Git repository.

@return boolean: true if inside a Git repository, false otherwise
--]]
function M.is_git_repo()
    -- Use cached value if available
    if cache.is_git_repo ~= nil then
        return cache.is_git_repo
    end

    local result = execute_git_command('git rev-parse --is-inside-work-tree')
    cache.is_git_repo = result ~= nil
    return cache.is_git_repo
end

--[[
Retrieves the current HEAD commit hash.

@return string|nil: Short form of HEAD commit hash, or nil if unavailable
--]]
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

--[[
Gets the current Git branch name with an icon prefix.

@return string|nil: Formatted branch name with icon, or nil if not in a Git repository
--]]
function M.get_branch()
    -- Early return if not in a git repo
    if not M.is_git_repo() then
        return nil
    end

    local current_time = os.time()

    -- Safe cache checking with proper type handling
    if cache.branch and
        cache.branch_timestamp and
        type(cache.branch_timestamp) == "number" and
        (current_time - cache.branch_timestamp) < (cache.cache_duration or 5) then
        return cache.branch
    end

    -- Get current branch from git
    local branch_info = execute_git_command('git branch --show-current')

    -- Safe update of cache
    cache.branch_timestamp = current_time

    if not branch_info or not branch_info[1] then
        cache.branch = nil
        return nil
    end

    -- Update cache with branch name and icon
    cache.branch = string.format(" %s", branch_info[1])
    return cache.branch
end

--[[
Retrieves detailed Git repository status information.

@return table: Status information with the following fields:
    - ahead: Number of commits ahead of remote
    - behind: Number of commits behind remote
    - staged: Number of staged changes
    - changed: Number of unstaged changes
--]]
function M.get_status()
    -- Early return if not in a git repo
    if not M.is_git_repo() then
        return { ahead = 0, behind = 0, staged = 0, changed = 0 }
    end

    local status = {
        ahead = 0,
        behind = 0,
        staged = 0,
        changed = 0
    }

    -- Safely get ahead/behind count
    local remote_status = execute_git_command('git rev-list --left-right --count HEAD...@{upstream}')
    if remote_status and remote_status[1] then
        local ahead, behind = remote_status[1]:match("(%d+)%s+(%d+)")
        if ahead and behind then
            status.ahead = tonumber(ahead) or 0
            status.behind = tonumber(behind) or 0
        end
    end

    -- Safely get staged/unstaged changes
    local diff_status = execute_git_command('git status --porcelain')
    if diff_status then
        for _, line in ipairs(diff_status) do
            if type(line) == "string" and #line >= 2 then
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
    end

    return status
end

--[[
Formats Git status information into a human-readable string.

The string includes the following indicators:
- ↑n: n commits ahead of remote
- ↓n: n commits behind remote
- ●n: n staged changes
- ○n: n unstaged changes

@return string: Formatted status string or empty string if not in a Git repository
--]]
function M.get_status_string()
    if not M.is_git_repo() then
        return ""
    end

    local status = M.get_status()
    local parts = {}

    -- Only add parts if they have positive values
    if status.ahead and status.ahead > 0 then
        table.insert(parts, string.format("↑%d", status.ahead))
    end
    if status.behind and status.behind > 0 then
        table.insert(parts, string.format("↓%d", status.behind))
    end
    if status.staged and status.staged > 0 then
        table.insert(parts, string.format("●%d", status.staged))
    end
    if status.changed and status.changed > 0 then
        table.insert(parts, string.format("○%d", status.changed))
    end

    return table.concat(parts, " ")
end

--[[
Clears the Git information cache.

This function is useful when Git status changes and cached information
needs to be refreshed. It resets all cached values to their initial state.
--]]
function M.clear_cache()
    cache = {
        branch = nil,
        branch_timestamp = 0,
        cache_duration = 5,
        head_oid = nil,
        head_timestamp = 0,
        is_git_repo = nil
    }
end

--[[
Sets up autocommands for cache management.

Creates autocommands that clear the Git information cache when:
- A buffer is written
- Neovim regains focus
- The working directory changes
- Neovim starts up

This ensures that the cached information stays up-to-date with the actual
Git repository state.
--]]
local function setup_autocmds()
    local group = vim.api.nvim_create_augroup("GitStatusCache", { clear = true })

    vim.api.nvim_create_autocmd({
        "BufWritePost",
        "FocusGained",
        "DirChanged",
        "VimEnter"
    }, {
        group = group,
        callback = function()
            M.clear_cache()
            -- Reset git repo status on directory change
            if cache.is_git_repo then
                cache.is_git_repo = nil
            end
        end,
        desc = "Clear git status cache on relevant events"
    })
end

-- Initialize the module
setup_autocmds()

return M
