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

        vim.lsp.config('neocmake', {
            capabilities = capabilities,
            init_options = {
                format = { enable = true },
                scan_cmake_in_package = true
            },
            filetypes = { "cmake" },
            root_markers = { "CMakeLists.txt", "cmake", ".git" },
        })

        -- Setup mason-lspconfig (WITHOUT clangd in ensure_installed)
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "pyright", "neocmake", "texlab" },
        })

        -- Set up nvim-cmp with buffer and path completion for C++
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        pcall(require, "snippets.customsnippets")

        cmp.setup({
            sources = cmp.config.sources({
                { name = "nvim_lsp", priority = 1000 },
                { name = "luasnip",  priority = 750 },
                { name = "buffer",   priority = 500 },  -- This gives you word completion from open buffers
                { name = "path",     priority = 400 },
            }),

            mapping = cmp.mapping.preset.insert({
                ["<Tab>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete({ reason = cmp.ContextReason.Manual }),
                ["<C-k>"] = cmp.mapping.scroll_docs(-4),
                ["<C-j>"] = cmp.mapping.scroll_docs(4),
                ["<C-e>"] = cmp.mapping.abort(),
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

            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },

            window = {
                completion = {
                    border = "rounded",
                    winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder",
                    col_offset = -3,
                    side_padding = 0,
                },
                documentation = {
                    border = "rounded",
                    winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocBorder",
                    max_width = 50,
                    max_height = 30,
                },
            },

            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    local kind_icons = {
                        Text = "󰉿", Method = "󰆧", Function = "󰊕", Constructor = "",
                        Field = "󰜢", Variable = "󰀫", Class = "󰠱", Interface = "",
                        Module = "", Property = "󰜢", Unit = "󰑭", Value = "󰎠",
                        Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
                        File = "󰈙", Reference = "󰈇", Folder = "󰉋", EnumMember = "",
                        Constant = "󰏿", Struct = "󰙅", Event = "", Operator = "󰆕",
                        TypeParameter = "",
                    }
                    vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
                    vim_item.menu = ({
                        nvim_lsp = "[LSP]",
                        luasnip = "[Snippet]",
                        buffer = "[Buffer]",
                        path = "[Path]",
                    })[entry.source.name]
                    return vim_item
                end,
            },

            completion = {
                completeopt = "menu,menuone,noinsert",
                keyword_length = 1,
                keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
            },
        })

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
