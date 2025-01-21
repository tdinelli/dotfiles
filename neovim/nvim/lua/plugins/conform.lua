return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        -- Define formatting options for each formatter
        local formatters = {
            -- C++ formatting configuration with clang-format
            clangformat = {
                prepend_args = {
                    "--style=file:.clang-format", -- Try to use project's style first
                    "--fallback-style=Google",    -- Fallback to Google style if no .clang-format found
                },
            },

            -- CMake formatting configuration
            cmake_format = {
                -- Configure cmake-format behavior
                prepend_args = {
                    "--line-width=100",
                    "--tab-size=2",
                    "--separate-ctrl-name-with-space=false",
                    "--separate-fn-name-with-space=false",
                },
            },

            -- python formatting configuration
            black = {
                prepend_args = {
                    "--line-length=120",
                    "--preview",
                    "--quiet",
                },
            },
            isort = {
                prepend_args = {
                    "--profile=black",
                    "--line-length=120",
                    "--multi-line=3",
                    "--lines-after-imports=2",
                    "--combine-as",
                },
            },
            ruff_format = { prepend_args = { "format", "--line-length=120", }, },

            -- LaTeX formatting configuration
            latexindent = {
                prepend_args = {
                    "-l",                  -- Use local configuration file if available
                    "-m",                  -- Modify line breaks
                    "--logfile=/dev/null", -- Disable logging
                },
                -- "-g=/dev/null",                -- Disable backup files
                -- "--local",                     -- Use .latexindent.yaml from project directory
                -- "--lines=1-100000",            -- Format entire file
                -- "-y=\"noTabs:1\"",             -- Prevent usage of tabs
                -- "-y=\"defaultIndent:' '\"",    -- Use space for indentation
                -- "-y=\"indentRules:' '\"",      -- Use space for indentation
                -- "-y=\"maximumIndentation:89\"" -- Set maximum line length to 89
            },
            ["bibtex-tidy"] = {
                prepend_args = {
                    "--omit=abstract", -- Skip abstract field
                    "--curly",         -- Use curly braces for titles
                    "--sort-fields",   -- Sort fields within entries
                    "--duplicates",    -- Check for duplicates
                    "--align=14",      -- Align fields at column 14
                    "--wrap=80",       -- Wrap long lines at 80 characters
                    "--blank-lines"
                },
            },
        }

        -- Set up format-on-save functionality
        local format_on_save = {
            cpp = false,
            python = false,
            cmake = false,
            latex = false,
            tex = false,
            plaintex = false,
            bib = false,
        }

        -- Configure conform.nvim
        require("conform").setup({
            -- Define formatters for each filetype
            formatters_by_ft = {
                -- C++ files use clang-format
                cpp = { "clang-format" },
                -- Python files use multiple formatters in sequence
                python = {
                    "isort",       -- First sort imports
                    "black",       -- Then format code
                    "ruff_format", -- Finally, apply additional formatting
                },
                -- CMake files use cmake-format
                cmake = { "cmake_format" },

                -- LaTeX
                latex = { "latexindent" },
                tex = { "latexindent" },
                plaintex = { "latexindent" },
                bib = { "bibtex-tidy" }
            },

            -- Apply the formatter configurations
            formatters = formatters,

            -- Format on save configuration
            format_on_save = function(bufnr)
                -- Don't format if the file is too large
                if vim.api.nvim_buf_line_count(bufnr) > 10000 then
                    return
                end

                -- Get the filetype of the buffer
                local filetype = vim.bo[bufnr].filetype

                -- Check if format on save is enabled for this filetype
                if format_on_save[filetype] then
                    return {
                        timeout_ms = 5000,
                        lsp_fallback = true,
                    }
                end
            end,

            -- Notify on format errors
            notify_on_error = true,
        })

        -- Create keymap for manual formatting
        vim.keymap.set(
            "n",
            "<leader>f",
            function()
                require("conform").format({
                    async = false,
                    timeout_ms = 5000,
                    lsp_fallback = true,
                })
            end,
            { desc = "Format current buffer" }
        )

        -- Create commands for enabling/disabling format on save
        vim.api.nvim_create_user_command("FormatEnable", function(args)
            local ft = args.args ~= "" and args.args or vim.bo.filetype
            format_on_save[ft] = true
            print(string.format("Enabled formatting on save for '%s'", ft))
        end, {
            nargs = "?",
            complete = function()
                return vim.tbl_keys(format_on_save)
            end,
        })

        vim.api.nvim_create_user_command("FormatDisable", function(args)
            local ft = args.args ~= "" and args.args or vim.bo.filetype
            format_on_save[ft] = false
            print(string.format("Disabled formatting on save for '%s'", ft))
        end, {
            nargs = "?",
            complete = function()
                return vim.tbl_keys(format_on_save)
            end,
        })
    end,
}
