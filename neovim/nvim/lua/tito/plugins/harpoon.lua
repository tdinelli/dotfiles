return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", },
    event = "VeryLazy",
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup({
            settings = {
                save_on_toggle = true,
                sync_on_ui_close = false,
                key = function()
                    return vim.loop.cwd()
                end,
            },
        })

        -- remapping
        vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end,
            { desc = "Add file to harpoon database" })
        vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
            { desc = "Toggle quick menu for harpoon" })

        vim.keymap.set("n", "h1", function() harpoon:list():select(1) end,
            { desc = "Move to file number 1 inside the harpoon list" })
        vim.keymap.set("n", "h2", function() harpoon:list():select(2) end,
            { desc = "Move to file number 2 inside the harpoon list" })
        vim.keymap.set("n", "h3", function() harpoon:list():select(3) end,
            { desc = "Move to file number 3 inside the harpoon list" })
        vim.keymap.set("n", "h4", function() harpoon:list():select(4) end,
            { desc = "Move to file number 4 inside the harpoon list" })

        vim.keymap.set("n", "<C-P>", function() harpoon:list():prev() end,
            { desc = "Toggle the [P]revious buffer stored inside the harpoon list" })
        vim.keymap.set("n", "<C-N>", function() harpoon:list():next() end,
            { desc = "Toggle the [N]ext buffer stored inside the harpoon list" })

        -- vim.keymap.set("n", "<leader>gt", function() harpoon.tmux:sendCommand(0, "ls -La") end)
    end,
}
