return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "L3MON4D3/LuaSnip",
        "j-hui/fidget.nvim",
        {
            "saghen/blink.cmp",
            version = "1.*",
            opts = {
                keymap = {
                    preset = "default",
                    ["<Tab>"] = { "select_and_accept", "fallback" },
                    ["<C-space>"] = { "show", "fallback" },
                    ["<C-k>"] = { "scroll_documentation_up", "fallback" },
                    ["<C-j>"] = { "scroll_documentation_down", "fallback" },
                    ["<C-e>"] = { "hide", "fallback" },
                },
                appearance = { nerd_font_variant = "mono" },
                completion = {
                    menu = { border = "rounded" },
                    documentation = { auto_show = true, window = { border = "rounded" } },
                },
                snippets = { preset = "luasnip" },
                sources = { default = { "lsp", "path", "snippets", "buffer" } },
            },
        },
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            require("blink.cmp").get_lsp_capabilities()
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

        -- Configure servers (NO CLANGD)
        vim.lsp.config('lua_ls', {
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                }
            }
        })

        vim.lsp.config('pyright', {
            capabilities = capabilities,
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        diagnosticMode = "openFilesOnly",
                        useLibraryCodeForTypes = true,
                        typeCheckingMode = "basic",
                        diagnosticSeverityOverrides = {
                            reportGeneralTypeIssues = "warning",
                            reportOptionalMemberAccess = "warning",
                            reportOptionalSubscript = "warning",
                            reportPrivateImportUsage = "warning",
                        },
                    },
                    exclude = {
                        "**/.git/**",
                        "**/__pycache__/**",
                        "**/venv/**",
                    },
                },
            },
            filetypes = { "python" },
            root_markers = {
                "pyproject.toml",
                "setup.py",
                "setup.cfg",
                "requirements.txt",
                "Pipfile",
                ".git"
            },
        })

        vim.lsp.config('texlab', {
            capabilities = capabilities,
            settings = { texlab = {} },
            filetypes = { "tex", "plaintex", "bib" },
            root_markers = { ".latexmkrc", "main.tex", "root.tex", ".git" },
        })

        vim.lsp.config('clangd', {
            capabilities = vim.tbl_deep_extend("force", capabilities, {
                offsetEncoding = { "utf-16" },
            }),
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--clang-tidy-checks=-bugprone-easily-swappable-parameters",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--function-arg-placeholders",
                "--fallback-style=google",
            },
            filetypes = { "c", "cpp", "objc", "objcpp" },
            root_markers = {
                "CMakeLists.txt",
                "compile_commands.json",
                "compile_flags.txt",
                ".clangd",
                ".git",
            },
        })

        vim.lsp.config('neocmake', {
            capabilities = capabilities,
            init_options = {
                format = { enable = true },
                scan_cmake_in_package = true
            },
            filetypes = { "cmake" },
            root_markers = { "CMakeLists.txt", "cmake", ".git" },
        })

        -- Setup mason-lspconfig
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "pyright", "neocmake", "texlab" },
        })

        vim.lsp.enable({ "clangd", "lua_ls", "pyright", "neocmake", "texlab" })

        -- Load custom LuaSnip snippets (expanded via blink.cmp's snippets source)
        pcall(require, "snippets.customsnippets")

        -- LSP keymaps (will only work for non-C++ files now)
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

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
                on_attach(nil, ev.buf)

                -- alabaster only styles Treesitter's @function groups, not LSP
                -- semantic tokens; without this, LSP semantic highlighting paints
                -- over Treesitter and function names lose their color.
                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                if client then
                    client.server_capabilities.semanticTokensProvider = nil
                end
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
