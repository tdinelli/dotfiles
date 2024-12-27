return {
    "Shatur/neovim-tasks",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>bu", desc = "[B][U]ild with CMake" },
        { "<leader>ma", desc = "[M][A]ke build" },
        { "<leader>mc", desc = "[M]ake [C]lean" },
        { "<leader>co", desc = "[C][O]nfigure CMake" },
        { "<leader>pu", desc = "[P][U]lisci (Clean)" },
        { "<leader>mo", desc = "[M][O]dify CMake args" },
    },
    opts = {
        default_params = {
            cmake = {
                cmd = "cmake",
                build_dir = vim.fn.stdpath("data") .. "/build", -- More robust path handling
                build_type = "Debug",
                args = {
                    configure = { "-DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE" },
                },
            },
            make = {
                cmd = "make",
                args = {
                    all = {},
                    build = {},
                    nuke = { "clean" },
                },
            }
        },
        save_before_run = true,
        params_file = ".cmake.neovim.json",
        quickfix = {
            pos = "botright",
            height = 8,
        },
    },
    config = function(_, opts)
        local tasks = require("tasks")
        tasks.setup(opts)

        -- Define keymaps with consistent formatting
        local keymaps = {
            { "n", "<leader>bu", "<cmd>Task start cmake build<cr>",                   { desc = "[B][U]ild with CMake" } },
            { "n", "<leader>ma", "<cmd>Task start make build<cr>",                    { desc = "[M][A]ke build" } },
            { "n", "<leader>mc", "<cmd>Task start make clean<cr>",                    { desc = "[M]ake [C]lean" } },
            { "n", "<leader>co", "<cmd>Task start cmake configure<cr>",               { desc = "[C][O]nfigure CMake" } },
            { "n", "<leader>pu", "<cmd>Task start cmake clean<cr>",                   { desc = "[P][U]lisci (Clean)" } },
            { "n", "<leader>mo", "<cmd>Task set_task_param cmake configure args<cr>", { desc = "[M][O]dify CMake args" } },
        }

        -- Apply keymaps
        for _, map in ipairs(keymaps) do
            vim.keymap.set(unpack(map))
        end
    end,
}
