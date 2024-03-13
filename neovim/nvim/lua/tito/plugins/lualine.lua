return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local colors = {
            white        = "#ffffff",
            green        = "#00b33c",
            lightgreen   = "#bdf5bd",
        }
        local a = { bg = colors.green, fg = colors.white}
        local b = { bg = colors.lightgreen, fg = colors.green }
        local c = { bg = colors.white, fg = colors.green }

        local custom_color = require("lualine.themes.github_light_tritanopia")
        custom_color.command.a = a
        custom_color.command.b = b
        custom_color.command.c = c


        require("lualine").setup({
            options = {
                theme = custom_color,
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
        })
    end,
}
