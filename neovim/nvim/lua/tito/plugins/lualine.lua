return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            options = {
                theme = "catppuccin",
                icons_enabled = true,
                component_separators = { left = "|", right = "|" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = false,
                globalstatus = true,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                }
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff" },
                lualine_c = { "filename" },
                lualine_x = { "encoding", "filetype", "fileformat" },
                lualine_y = { "progress" },
                lualine_z = { "location" }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {
                lualine_a = {
                    {
                        "buffers",
                        show_filename_only = true,          -- Shows shortened relative path when set to false.
                        hide_filename_extension = false,    -- Hide filename extension when set to true.
                        show_modified_status = true,        -- Shows indicator when the buffer is modified.
                        mode = 3,
                        max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
                        use_mode_colors = false,

                        tabs_color = {
                            active = 'lualine_{section}_normal',
                            inactive = 'lualine_{section}_inactive',
                        },

                        symbols = {
                            modified = " ●", -- Text to show when the buffer is modified
                            alternate_file = "#", -- Text to show to identify the alternate file
                            directory = "", -- Text to show when the buffer is a directory
                        },
                    }
                }
            },
            winbar = {},
            inactive_winbar = {},
            extensions = {}
        })
    end,
}
