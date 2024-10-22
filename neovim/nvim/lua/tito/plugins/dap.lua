return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "nvim-neotest/nvim-nio",
        "williamboman/mason.nvim",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        -- Setup dap-ui and virtual text
        dapui.setup({})
        -- require("nvim-dap-virtual-text").setup({})

        -- Python dap configuration
        require("tito.plugins.dap_config.dap_python")
        require("tito.plugins.dap_config.dap_cpp")

        -- Keybindings for dap actions
        vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, { desc = "Dap Toggle Breakpoint" })
        vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Dap Continue" })
        vim.keymap.set("n", "<space>gb", dap.run_to_cursor, { desc = "Run to Cursor" })
        vim.keymap.set("n", "<space>?", function()
            dapui.eval(nil, { enter = true })
        end, { desc = "Evaluate expression" })

        vim.keymap.set("n", "<F2>", dap.step_into, { desc = "Step Into" })
        vim.keymap.set("n", "<F3>", dap.step_over, { desc = "Step Over" })
        vim.keymap.set("n", "<F4>", dap.step_out, { desc = "Step Out" })
        vim.keymap.set("n", "<F5>", dap.step_back, { desc = "Step Back" })
        vim.keymap.set("n", "<F13>", dap.restart, { desc = "Restart" })

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end
    end
}
