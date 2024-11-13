return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable "make" == 1
            end,
        },
        { "nvim-telescope/telescope-ui-select.nvim" },
        { "nvim-tree/nvim-web-devicons" },
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
                path_display = { "truncate" },
                mappings = {
                    i = {
                        ["<C-h>"] = "which_key",
                        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-j>"] = actions.move_selection_next,     -- move to next result
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    },
                },
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
            },
        })

        -- Not sure if this is needed, read documentation
        -- telescope.load_extension("fzf")
        pcall(telescope.load_extension, "fzf")
        pcall(telescope.load_extension, "ui-select")

        -- remapping
        -- vim.keymap.set("n", "<leader>gr", function() builtin.grep_string({ search = vim.fn.input("Grep > ") }) end,
        --     { desc = "[GR]ep something" })
        vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "[P]roject [F]iles" })
        vim.keymap.set("n", "<leader>bf", builtin.buffers, { desc = "[B]uffer [F]ind" })
        vim.keymap.set("n", "<leader>km", builtin.keymaps, { desc = "[K]ey [M]aps" })
        vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "[G]it [F]iles" })
        vim.keymap.set("n", "<leader>gr", builtin.live_grep, { desc = "[GR]ep something" })
        vim.keymap.set("n", "<leader>gw", builtin.grep_string, { desc = "[G]rep current [W]ord" })
        vim.keymap.set("n", "<leader>qo", builtin.quickfix, { desc = "[Q]uickfix [O]pen" })
        vim.keymap.set("n", "<leader>ts", builtin.treesitter, { desc = "[T]ree [S]itter search" })
        vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

        -- Following stuff copied from kickstart
        vim.keymap.set('n', '<leader>/', function()
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
            })
        end, { desc = '[/] Fuzzily search in current buffer' })

        -- Also possible to pass additional configuration options.
        --  See `:help telescope.builtin.live_grep()` for information about particular keys
        vim.keymap.set('n', '<leader>s/', function()
            builtin.live_grep {
                grep_open_files = true,
                prompt_title = 'Live Grep in Open Files',
            }
        end, { desc = '[S]earch [/] in Open Files' })

        -- Shortcut for searching your neovim configuration files
        vim.keymap.set('n', '<leader>sn', function()
            builtin.find_files { cwd = vim.fn.stdpath 'config' }
        end, { desc = '[S]earch [N]eovim files' })

        -- Shortcut for searching whithin my GitHub folder certain specific repo I usually work on
        vim.keymap.set('n', '<leader>so', function()
            builtin.find_files { cwd = '$HOME/Documents/GitHub/OpenSMOKEpp/' }
        end, { desc = '[S]earch [O]penSMOKE files' })
    end,
}
