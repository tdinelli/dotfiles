return {
    "Shatur/neovim-tasks",
    -- event = "VeryLazy",
    keys = {
        "<leader>bu",
        "<leader>co",
        "<leader>pu",
        "<leader>mo",
    },
    dependencies = { "nvim-lua/plenary.nvim", },
    config = function()
        local Path = require("plenary.path")
        require("tasks").setup({
            default_params = {
                cmake = {
                    cmd = "cmake",
                    build_dir = tostring(Path:new("{cwd}", "build")),
                    build_type = "Debug",
                    args = {
                        configure = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
                    },
                },
            },
            save_before_run = true,
            params_file = ".cmake.neovim.json",
            quickfix = {
                pos = "botright",
                height = 8,
            },
        })

        -- TODO: add description
        vim.keymap.set("n", "<leader>bu", [[:Task start cmake build<CR>]], { desc = "[B][U]ild" })
        vim.keymap.set("n", "<leader>co", [[:Task start cmake configure<CR>]], { desc = "[C][O]nfigure" })
        vim.keymap.set("n", "<leader>pu", [[:Task start cmake clean<CR>]],
            { desc = "[P][U]lisci, italian translation of clean" })
        vim.keymap.set("n", "<leader>mo", [[:Task set_task_param cmake configure args<CR>]], { desc = "[M][O]dify" })
    end,
}
