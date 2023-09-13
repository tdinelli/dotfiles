return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    -- set keymaps
    vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Mark a file with harpoon" })
    vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Toggle quick menu for harpoon" })

    vim.keymap.set("n", "h1", function() ui.nav_file(1) end, { desc = "Move to file number 1" })
    vim.keymap.set("n", "h2", function() ui.nav_file(2) end, { desc = "Move to file number 2" })
    vim.keymap.set("n", "h3", function() ui.nav_file(3) end, { desc = "Move to file number 3" })
    vim.keymap.set("n", "h4", function() ui.nav_file(4) end, { desc = "Move to file number 4" })
    vim.keymap.set("n", "h5", function() ui.nav_file(5) end, { desc = "Move to file number 5" })
    vim.keymap.set("n", "h6", function() ui.nav_file(6) end, { desc = "Move to file number 6" })
  end,
}
