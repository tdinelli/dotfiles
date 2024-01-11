return {
    "Civitasv/cmake-tools.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim", },
    config = function()
        require("cmake-tools").setup({
            cmake_command = "cmake",
            ctest_command = "ctest",
            cmake_regenerate_on_save = false,
            cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
            cmake_build_directory = "./build/${variant:buildType}",
            cmake_build_options = {},
            cmake_soft_link_compile_commands = true,
            cmake_compile_commands_from_lsp = false,
            cmake_kits_path = nil,
            cmake_variants_message = {
                short = { show = true },
                long = { show = true, max_length = 40 },
            },
            cmake_executor = {
                name = "quickfix",
                opts = {},
                default_opts = {
                    quickfix = {
                        show = "always",
                        position = "belowright",
                        size = 10,
                        encoding = "utf-8",
                        auto_close_when_success = true,
                    },
                    terminal = {
                        name = "Main Terminal",
                        prefix_name = "[CMakeTools]: ",
                        split_direction = "horizontal",
                        split_size = 11,

                        -- Window handling
                        single_terminal_per_instance = true,
                        single_terminal_per_tab = true,
                        keep_terminal_static_location = true,

                        -- Running Tasks
                        start_insert = false,
                        focus = false,
                        do_not_add_newline = false,
                    },
                },
            },
            cmake_notifications = {
                runner = { enabled = true },
                executor = { enabled = true },
                -- spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, -- icons used for progress display
                refresh_rate_ms = 100, -- how often to iterate icons
            },
        })
    end
}
