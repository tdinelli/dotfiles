return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable "make" == 1
            end,
        },
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local builtin = require("telescope.builtin")

        telescope.setup({
            pickers = {
                find_files = {
                    follow = true
                }
            },
            defaults = {
                path_display = { "truncate " },
                mappings = {
                    i = {
                        ["<C-h>"] = "which_key",
                        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-j>"] = actions.move_selection_next,     -- move to next result
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    },
                },
            },
        })

        -- Not sure if this is needed, read documentation
        telescope.load_extension("fzf")

        -- remapping
        vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "[P]roject [F]iles" })
        vim.keymap.set("n", "<leader>bf", builtin.buffers, { desc = "[B]uffer [F]ind" })
        vim.keymap.set("n", "<leader>km", builtin.keymaps, { desc = "[K]ey [M]aps" })
        vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "[G]it [F]iles" })
        vim.keymap.set("n", "<leader>gr", builtin.live_grep, { desc = "[GR]ep something" })
        vim.keymap.set("n", "<leader>qo", builtin.quickfix, { desc = "[Q]uickfix [O]pen" })
        vim.keymap.set("n", "<leader>ts", builtin.treesitter, { desc = "[T]ree [S]itter search" })
        vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
    end,
}
