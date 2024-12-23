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
    opts = {
        pickers = {
            find_files = { follow = true }
        },
        defaults = {
            path_display = { "truncate" },
            mappings = {
                i = {
                    ["<C-h>"] = "which_key",
                    ["<C-k>"] = "move_selection_previous",
                    ["<C-j>"] = "move_selection_next",
                    ["<C-q>"] = "send_selected_to_qflist",
                },
            },
        },
        extensions = {
            ["ui-select"] = {
                require("telescope.themes").get_dropdown(),
            },
        },
    },
    config = function(_, opts)
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        telescope.setup(opts)

        -- Load extensions safely
        for _, extension in ipairs({ "fzf", "ui-select" }) do
            pcall(telescope.load_extension, extension)
        end

        -- Define keymaps grouped by functionality
        local maps = {
            files = {
                { "n", "<leader>pf", builtin.find_files, { desc = "[P]roject [F]iles" } },
                { "n", "<leader>gf", builtin.git_files,  { desc = "[G]it [F]iles" } },
                { "n", "<leader>bf", builtin.buffers,    { desc = "[B]uffer [F]ind" } },
            },
            search = {
                { "n", "<leader>gr", builtin.live_grep,   { desc = "[GR]ep something" } },
                { "n", "<leader>gw", builtin.grep_string, { desc = "[G]rep current [W]ord" } },
                { "n", "<leader>/", function()
                    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                        winblend = 10,
                        previewer = false,
                    }))
                end, { desc = "[/] Fuzzily search in current buffer" } },
                { "n", "<leader>s/", function()
                    builtin.live_grep({
                        grep_open_files = true,
                        prompt_title = "Live Grep in Open Files",
                    })
                end, { desc = "[S]earch [/] in Open Files" } },
            },
            tools = {
                { "n", "<leader>km", builtin.keymaps,     { desc = "[K]ey [M]aps" } },
                { "n", "<leader>qo", builtin.quickfix,    { desc = "[Q]uickfix [O]pen" } },
                { "n", "<leader>ts", builtin.treesitter,  { desc = "[T]ree [S]itter search" } },
                { "n", "<leader>sh", builtin.help_tags,   { desc = "[S]earch [H]elp" } },
                { "n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" } },
            },
            custom = {
                { "n", "<leader>sn", function()
                    builtin.find_files({ cwd = vim.fn.stdpath("config") })
                end, { desc = "[S]earch [N]eovim files" } },
                { "n", "<leader>so", function()
                    builtin.find_files({ cwd = vim.fn.expand("$HOME/Documents/GitHub/OpenSMOKEpp/") })
                end, { desc = "[S]earch [O]penSMOKE files" } },
            },
        }

        -- Apply all keymaps
        for _, group in pairs(maps) do
            for _, map in ipairs(group) do
                vim.keymap.set(unpack(map))
            end
        end
    end,
}
