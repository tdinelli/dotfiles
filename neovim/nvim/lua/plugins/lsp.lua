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
            ensure_installed = { "lua_ls", "clangd", "pylsp", "pyright"},
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

                ["pyright"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.pyright.setup({
                        capabilities = capabilities,
                        cmd = {
                            vim.fn.stdpath("data") .. "/mason/bin/pyright-langserver",
                            "--stdio",
                        },
                        settings = {
                            python = {
                                analysis = {
                                    autoSearchPaths = true,
                                    diagnosticMode = "openFilesOnly",
                                    useLibraryCodeForTypes = true,
                                    typeCheckingMode = "basic",

                                    -- Similar diagnostics control as pylsp
                                    diagnosticSeverityOverrides = {
                                        reportGeneralTypeIssues = "warning",
                                        reportOptionalMemberAccess = "warning",
                                        reportOptionalSubscript = "warning",
                                        reportPrivateImportUsage = "warning",
                                    },
                                },

                                -- Workspace configuration similar to pylsp
                                exclude = {
                                    "**/.git/**",
                                    "**/__pycache__/**",
                                    "**/venv/**",
                                },
                            },
                        },

                        -- Configure file pattern matching
                        filetypes = { "python" },

                        -- Root directory patterns for project detection (same as your pylsp config)
                        root_dir = function(fname)
                            return require("lspconfig.util").root_pattern(
                                "pyproject.toml",
                                "setup.py",
                                "setup.cfg",
                                "requirements.txt",
                                "Pipfile",
                                ".git"
                            )(fname)
                        end,
                    })
                end,
                -- ["pylsp"] = function()
                --     local lspconfig = require("lspconfig")
                --     lspconfig.pylsp.setup({
                --         capabilities = capabilities,
                --         cmd = {
                --             vim.fn.stdpath("data") .. "/mason/bin/pylsp",
                --         },
                --         settings = {
                --             pylsp = {
                --                 plugins = {
                --                     -- Code analysis plugins
                --                     pyflakes = { enabled = false },
                --                     pycodestyle = { enabled = false },
                --                     mccabe = { enabled = false },
                --
                --                     -- Formatting plugins
                --                     autopep8 = { enabled = false },
                --                     yapf = { enabled = false },
                --
                --                     -- Type checking and imports
                --                     pylsp_mypy = { enabled = false },
                --                     pylsp_black = { enabled = false },
                --                     pylsp_isort = { enabled = false },
                --
                --                     -- Enable helpful plugins that don't conflict with external tools
                --                     jedi_completion = {
                --                         enabled = true,
                --                         include_params = true,                -- Include parameter hints in completions
                --                         include_class_objects = true,         -- Include class objects in completions
                --                         fuzzy = true,                         -- Enable fuzzy matching for completions
                --                     },
                --                     jedi_hover = { enabled = true },          -- Enable documentation on hover
                --                     jedi_references = { enabled = true },     -- Enable finding references
                --                     jedi_signature_help = { enabled = true }, -- Enable signature help
                --                     jedi_symbols = { enabled = true },        -- Enable document symbols
                --
                --                     -- Rope for refactoring operations
                --                     rope_completion = { enabled = true },
                --                     rope_autoimport = { enabled = true },
                --                 },
                --
                --                 -- Configure diagnostics behavior
                --                 diagnostics = {
                --                     enable = true,
                --                     report_syntax_errors = true,
                --                 },
                --
                --                 -- Workspace configuration
                --                 workspace = {
                --                     symbols = {
                --                         enabled = true,
                --                         exclude = {
                --                             "**/.git/**",
                --                             "**/__pycache__/**",
                --                             "**/venv/**",
                --                         },
                --                     },
                --                 },
                --             },
                --         },
                --
                --         -- Configure file pattern matching
                --         filetypes = { "python" },
                --
                --         -- Root directory patterns for project detection
                --         root_dir = function(fname)
                --             return require("lspconfig.util").root_pattern(
                --                 "pyproject.toml",
                --                 "setup.py",
                --                 "setup.cfg",
                --                 "requirements.txt",
                --                 "Pipfile",
                --                 ".git"
                --             )(fname)
                --         end,
                --     })
                -- end,

                ["clangd"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.clangd.setup({
                        capabilities = capabilities,

                        cmd = {
                            vim.fn.stdpath("data") .. "/mason/bin/clangd",

                            -- Indexing and performance settings
                            "--background-index",       -- Index project in background for better performance
                            "--offset-encoding=utf-16", -- Ensure proper encoding handling
                            "--pch-storage=memory",     -- Store precompiled headers in memory for faster access
                            "--clang-tidy",             -- Enable clang-tidy for additional diagnostics

                            -- Code completion settings
                            "--completion-style=bundled",  -- Get detailed completion items
                            "--function-arg-placeholders", -- Include function argument placeholders in completion
                            "--header-insertion=iwyu",     -- Use IWYU style header insertion

                            -- Cross-reference and refactoring settings
                            "--cross-file-rename",     -- Enable cross-file renaming
                            "--all-scopes-completion", -- Show completions from all scopes

                            -- Additional helpful features
                            "--header-insertion-decorators", -- Show where headers will be inserted
                            "--suggest-missing-includes",    -- Suggest missing includes

                            -- Performance optimization settings
                            "-j=2", -- Number of parallel workers for indexing
                        },

                        -- Configure init_options for additional clangd features
                        init_options = {
                            -- Configure clangd's built-in code analysis
                            fallbackFlags = { "-std=c++17" }, -- Default to C++17 if no compilation database found
                            compilationDatabaseDirectories = { "build", "Build", "OUT", "out" },

                            -- Enhance code completion behavior
                            completionOrganization = "Detailed", -- Get more detailed completion items
                            includeInlayHints = true,            -- Show inlay hints for types and parameters

                            -- Configure clang-tidy integration
                            clangTidy = {
                                -- Add additional clang-tidy checks beyond the defaults
                                -- Default checks are: clang-diagnostic-*, clang-analyzer-*
                                add = {
                                    "modernize-*",   -- Modern C++ features
                                    "performance-*", -- Performance improvements
                                    "bugprone-*",    -- Likely bug patterns
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
                end,

                ["texlab"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.texlab.setup({
                        capabilities = capabilities,
                        cmd = { vim.fn.stdpath("data") .. "/mason/bin/texlab", },
                        settings = {
                            texlab = {
                                -- For the future
                                -- Configure forward search (PDF viewer integration)
                                -- forwardSearch = {
                                --     -- Configure your preferred PDF viewer here
                                --     executable = "zathura",
                                --     args = {
                                --         "--synctex-forward",
                                --         "%l:1:%f",
                                --         "%p"
                                --     },
                                -- },
                            },
                        },

                        filetypes = { "tex", "plaintex", "bib" },
                        -- Root directory patterns for project detection
                        root_dir = function(fname)
                            return require("lspconfig.util").root_pattern(
                                ".latexmkrc",
                                "main.tex",
                                "root.tex",
                                ".git"
                            )(fname)
                        end,
                    })
                end,
            },
        })

        -- Set up nvim-cmp with LuaSnip integration
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        luasnip.config.setup({})

        -- Configure the completion engine
        cmp.setup({
            -- Snippet configuration - tells nvim-cmp how to handle snippet expansion
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },

            -- Configure the completion experience
            completion = {     -- Specify completion behavior
                completeopt = "menu,menuone,noinsert",
                formatting = { -- Configure how completion menu appears
                    format = function(entry, vim_item)
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snippet]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
            },

            -- Window appearance configuration
            -- window = {
            --     documentation = {
            --         border = "rounded",
            --         max_height = 10,
            --         max_width = 50,
            --         zindex = 31,
            --         width = function()
            --             local columns = vim.o.columns
            --             local min_width = 20
            --             local max_width = math.min(columns * 0.3, 50)
            --             return math.max(min_width, max_width)
            --         end,
            --     },
            --     completion = {
            --         border = "rounded",
            --         winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            --         col_offset = -3,
            --         side_padding = 1,
            --         scrollbar = false,
            --         width = function()
            --             local columns = vim.o.columns
            --             local min_width = 20
            --             local max_width = math.min(columns * 0.4, 60)
            --             return math.max(min_width, max_width)
            --         end,
            --     },
            -- },

            mapping = cmp.mapping.preset.insert({ -- Configure keybindings for completion control
                -- Confirmation keybinding - use Tab to select
                ["<Tab>"] = cmp.mapping.confirm({ select = false, }),
                -- Manual trigger for completion menu
                ["<C-Space>"] = cmp.mapping.complete({ reason = cmp.ContextReason.Manual, }),
                -- Documentation scroll controls
                ["<C-k>"] = cmp.mapping.scroll_docs(-4), -- Scroll up
                ["<C-j>"] = cmp.mapping.scroll_docs(4),  -- Scroll down
                -- Close completion menu
                ["<C-e>"] = cmp.mapping.abort(),
            }),

            -- Configure completion sources in priority order
            sources = cmp.config.sources({
                { name = "nvim_lsp", priority = 1000 },
                { name = "luasnip",  priority = 750 },
                { name = "path",     priority = 500 },
            }),

            sorting = {
                comparators = {
                    cmp.config.compare.offset,
                    cmp.config.compare.exact,
                    cmp.config.compare.score,
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.order,
                },
            },

            experimental = {
                ghost_text = false,  -- Enable ghost text (preview of completion)
                native_menu = false, -- Enable native menu
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
