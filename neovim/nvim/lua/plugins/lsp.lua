return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("fidget").setup({})
        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        })

        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "clangd",
            },
            handlers = {
                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" }
                                },
                                workspace = {
                                    checkThirdParty = false,
                                },
                                telemetry = { enable = false },
                            }
                        }
                    })
                end,
                ["clangd"] = function()
                    local lspconfig = require("lspconfig")

                    -- Configure clangd with enhanced settings
                    lspconfig.clangd.setup({
                        capabilities = capabilities,

                        cmd = {
                            vim.fn.stdpath("data") .. "/mason/bin/clangd",

                            -- Indexing and performance settings
                            "--background-index", -- Index project in background for better performance
                            "--offset-encoding=utf-16", -- Ensure proper encoding handling
                            "--pch-storage=memory", -- Store precompiled headers in memory for faster access
                            "--clang-tidy", -- Enable clang-tidy for additional diagnostics

                            -- Code completion settings
                            "--completion-style=bundled", -- Get detailed completion items
                            "--function-arg-placeholders", -- Include function argument placeholders in completion
                            "--header-insertion=iwyu", -- Use IWYU style header insertion

                            -- Cross-reference and refactoring settings
                            "--cross-file-rename", -- Enable cross-file renaming
                            "--all-scopes-completion", -- Show completions from all scopes

                            -- Additional helpful features
                            "--header-insertion-decorators", -- Show where headers will be inserted
                            "--suggest-missing-includes", -- Suggest missing includes

                            -- Performance optimization settings
                            "-j=1", -- Number of parallel workers for indexing
                        },

                        -- Configure init_options for additional clangd features
                        init_options = {
                            -- Configure clangd's built-in code analysis
                            fallbackFlags = { "-std=c++17" }, -- Default to C++17 if no compilation database found
                            compilationDatabaseDirectories = { "build", "Build", "OUT", "out" },

                            -- Enhance code completion behavior
                            completionOrganization = "Detailed", -- Get more detailed completion items
                            includeInlayHints = true, -- Show inlay hints for types and parameters

                            -- Configure clang-tidy integration
                            clangTidy = {
                                -- Add additional clang-tidy checks beyond the defaults
                                -- Default checks are: clang-diagnostic-*, clang-analyzer-*
                                add = {
                                    "modernize-*", -- Modern C++ features
                                    "performance-*", -- Performance improvements
                                    "bugprone-*", -- Likely bug patterns
                                    "readability-*", -- Code readability
                                },
                                -- Disable specific checks that might be too noisy
                                remove = {
                                    "modernize-use-trailing-return-type", -- Avoid forcing trailing return types
                                },
                            },
                        },

                        -- Configure file pattern matching
                        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },

                        -- Root directory patterns for project detection
                        root_dir = function(fname)
                            return require("lspconfig.util").root_pattern(
                                "compile_commands.json",
                                "compile_flags.txt",
                                ".clangd",
                                ".clang-tidy",
                                ".clang-format",
                                "configure.ac",
                                "CMakeLists.txt",
                                "build/compile_commands.json",
                                "compile_flags.txt",
                                ".git"
                            )(fname)
                        end,
                    })
                end
            },
        })

        -- LSP keymaps
        local function on_attach(_, bufnr)
            local map = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end

            map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
            map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
            map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
            map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
            map("n", "<C-h>", vim.lsp.buf.signature_help, "Signature Help")
            map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder")
            map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
            map("n", "<leader>wl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, "List Workspace Folders")
            map("n", "<leader>D", vim.lsp.buf.type_definition, "Type Definition")
            map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
            map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
            map("n", "gr", vim.lsp.buf.references, "Go to References")
            map("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
        end

        -- Attach keymaps when LSP connects
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
                on_attach(nil, ev.buf)
            end,
        })

        -- Diagnostics configuration
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            update_in_insert = false,
            underline = true,
            severity_sort = true,
            float = {
                border = "rounded",
                source = "always",
            },
        })
    end
}
