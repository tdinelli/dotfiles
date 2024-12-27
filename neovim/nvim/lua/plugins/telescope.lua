return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = vim.fn.executable("make") == 1,
        },
        "nvim-telescope/telescope-ui-select.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        local config = {
            pickers = {
                find_files = { follow = true, hidden = true, no_ignore = false, },
                live_grep = { additional_args = function() return { "--hidden" } end, },
            },
            defaults = {
                path_display = { "truncate" },
                sorting_strategy = "ascending",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.7,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.9,
                    height = 0.80,
                    preview_cutoff = 120,
                },
                mappings = {
                    i = {
                        ["<C-h>"] = "which_key",
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        ["<C-s>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        ["<C-n>"] = actions.cycle_history_next,
                        ["<C-p>"] = actions.cycle_history_prev,
                        ["<C-u>"] = actions.preview_scrolling_up,
                        ["<C-d>"] = actions.preview_scrolling_down,
                    },
                },
                file_ignore_patterns = {
                    "%.git/",
                    "node_modules",
                    "%.DS_Store",
                },
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--trim",
                },
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        }
        telescope.setup(config)
        -- Load extensions
        local extensions = { "fzf", "ui-select" }
        for _, ext in ipairs(extensions) do
            pcall(telescope.load_extension, ext)
        end

        -- remapping
        local builtin = require("telescope.builtin")
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
    end,
}
