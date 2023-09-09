local dap_ok, dap = pcall(require, "dap")
local dapui = require("dapui")
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-lldb-vscode
if not (dap_ok) then
    print("nvim-dap not installed!")
    return
end
dap.set_log_level('TRACE') -- Helps when configuring DAP, see logs with :DapShowLog

-- https://alighorab.github.io/neovim/nvim-dap/
-- vscode-cpptools
dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = "/Users/tdinelli/.vscode/extensions/ms-vscode.cpptools-1.16.3-darwin-arm64/debugAdapters/bin/OpenDebugAD7",
}
-- codelldb

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = "/usr/bin/lldb",
        args = { "--port", "${port}" },
    },
}

dap.configurations.cpp = {
    {
        -- Change it to "cppdbg" if you have vscode-cpptools
        type = "cppdbg",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        args = {},
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
        MIMode = "lldb",
        miDebuggerPath = "/Users/tdinelli/.vscode/extensions/ms-vscode.cpptools-1.16.3-darwin-arm64/debugAdapters/lldb-mi/bin/lldb-mi",
        setupCommands = {
            {
                text = "-enable-pretty-printing",
                description = "enable pretty printing",
                ignoreFailures = false,
            },
        },
    },
}

dap.adapters.debugpy = {
}

dap.configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = function ()
            return '/opt/homebrew/Caskroom/miniconda/base/envs/spline/bin/python'
        end,
    },
    {
        type = 'python',
        request = 'launch',
        name = 'Test with pytest',
        program = '-m pytest test/',
        pythonPath = function ()
            return '/opt/homebrew/Caskroom/miniconda/base/envs/spline/bin/python'
        end,
    },
}


-- remappings
vim.keymap.set("n", "<leader>tb", "<cmd> DapToggleBreakpoint <CR>") -- add breakpoint
vim.keymap.set("n", "<leader>dr", "<cmd> DapContinue <CR>")         -- start debugging

dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end
