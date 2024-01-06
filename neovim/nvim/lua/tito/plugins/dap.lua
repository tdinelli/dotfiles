return {
    -- DAP, DAP-UI, DAP virtual text, telescopic DAP
    'mfussenegger/nvim-dap',

    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },

    'theHamsta/nvim-dap-virtual-text',

    'nvim-telescope/telescope-dap.nvim',

    event = { "BufReadPre", "BufNewFile" },

    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        -- python debugging
        -- c/c++  debugging

        -- remappings
        vim.keymap.set("n", "<leader>bt", "<cmd> DapToggleBreakpoint <CR>") -- add breakpoint
        vim.keymap.set("n", "<leader>dr", "<cmd> DapContinue <CR>")         -- start debugging

        -- dap UI
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
    end,
}
