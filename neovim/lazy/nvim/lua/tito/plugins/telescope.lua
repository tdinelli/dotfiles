return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require('telescope.builtin')

    telescope.setup({
      defaults = {
        path_display = { "truncate " },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    telescope.load_extension("fzf")

    -- set keymaps
    vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Fuzzy find files in cwd" })
    vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = "Fuzzy find in cwd but only the one with git" })
    vim.keymap.set('n', '<leader>gr', builtin.live_grep, { desc = "Fuzzy find grepping" })
  end,
}
