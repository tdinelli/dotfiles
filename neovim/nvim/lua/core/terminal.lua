-----------------------------
-- Terminal Configuration
-----------------------------
-- Create augroup for terminal settings
local term_group = vim.api.nvim_create_augroup("custom-term", {})

-- Terminal buffer-local settings
vim.api.nvim_create_autocmd("TermOpen", {
    group = term_group,
    callback = function()
        local opts = {
            number = false,
            relativenumber = false,
            scrolloff = 0,
            signcolumn = "no",    -- Hide signcolumn in terminal
            cursorline = false,   -- Disable cursorline in terminal
            bufhidden = "hide",   -- Hide buffer when not in window
        }

        for opt, value in pairs(opts) do
            vim.opt_local[opt] = value
        end

        -- Start in insert mode when opening terminal
        vim.cmd("startinsert")
    end,
})

-- Terminal keymaps
local term_maps = {
    -- Exit terminal mode
    { "t", "<esc><esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" }},
    -- Quick terminal toggle
    { "n", "<leader>st", function()
        vim.cmd.new()
        vim.cmd.wincmd("J")
        vim.api.nvim_win_set_height(0, 12)
        vim.wo.winfixheight = true
        vim.cmd.term()
    end, { desc = "[S]plit [T]erminal" }},
    -- Optional: Quick terminal hide/show
    { "n", "<leader>tt", function()
        local term_bufs = {}
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].buftype == 'terminal' then
                table.insert(term_bufs, buf)
            end
        end
        if #term_bufs > 0 then
            -- Toggle existing terminal
            local win = vim.fn.bufwinnr(term_bufs[1])
            if win ~= -1 then
                vim.cmd(win .. 'hide')
            else
                vim.cmd('sbuffer ' .. term_bufs[1])
                vim.cmd.wincmd("J")
                vim.api.nvim_win_set_height(0, 12)
            end
        else
            -- Create new terminal
            vim.cmd.new()
            vim.cmd.wincmd("J")
            vim.api.nvim_win_set_height(0, 12)
            vim.wo.winfixheight = true
            vim.cmd.term()
        end
    end, { desc = "[T]oggle [T]erminal" }},
}

-- Apply terminal keymaps
for _, map in ipairs(term_maps) do
    vim.keymap.set(unpack(map))
end
