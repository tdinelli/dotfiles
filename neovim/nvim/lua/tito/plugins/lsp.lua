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
        require("mason").setup({})
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "cmake", "julials", "clangd", "fortls" },
            handlers = {
                -- texlab
                ["texlab"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.texlab.setup({
                        capabilities = capabilities,
                        settings = {
                            latex = {
                                build = { auxDirectory = "build", logDirectory = "build", pdfDirectory = "build" },
                            },
                        },
                    })
                end,

                -- cmake-language-server
                ["cmake"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.cmake.setup({
                        capabilities = capabilities,
                    })
                end,

                -- lua_ls specific config
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" }
                                }
                            }
                        }
                    })
                end,

                ["pylsp"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.pylsp.setup({
                        capabilities = capabilities,
                        settings = {
                            pylsp = {
                                plugins = {
                                    -- formatter options
                                    black = { enabled = true },
                                    autopep8 = { enabled = false },
                                    yapf = { enabled = false },
                                    -- linter options
                                    pycodestyle = { enabled = true, ignore = { 'W391' }, maxLineLength = 120 },
                                    pylint = { enabled = false, executable = "pylint" },
                                    pyflakes = { enabled = false },
                                    mccabe = { enabled = false },
                                },
                            }
                        },
                    })
                end,

                -- fortls config for details see: https://fortls.fortran-lang.org/editor_integration.html
                ["fortls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.fortls.setup({
                        capabilities = capabilities,
                        cmd = {
                            "fortls",
                            "--hover_signature",
                            "--lowercase_intrinsics",
                            "--hover_language=fortran",
                            "--use_signature_help"
                        },
                    })
                end,

                -- Julia lsp is very broken ( :') )
                ["julials"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.julials.setup({
                        -- This just adds dirname(fname) as a fallback (see nvim-lspconfig#1768).
                        root_dir = function(fname)
                            local util = require 'lspconfig.util'
                            return util.root_pattern 'Project.toml' (fname) or util.find_git_ancestor(fname) or
                                util.path.dirname(fname)
                        end,
                        settings = {
                            julia = {
                                lint = {
                                    missingrefs = "none", -- Disabilita l'hint per variabili assegnate ma non usate
                                    iter = false,         -- Puoi disabilitare altri hint specifici qui
                                },
                            },
                        },
                        capabilities = capabilities,
                    })
                end,

                ["clangd"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.clangd.setup({
                        capabilities = capabilities,
                        cmd = {
                            vim.fn.stdpath("data") .. "/mason/bin/clangd",
                            "--background-index",
                            -- by default, clang-tidy use -checks=clang-diagnostic-*,clang-analyzer-*
                            -- to add more checks, create .clang-tidy file in the root directory
                            -- and add Checks key, see https://clang.llvm.org/extra/clang-tidy/
                            "--clang-tidy",
                            "--completion-style=bundled",
                            "--cross-file-rename",
                            "--header-insertion=iwyu",
                        },
                    })
                end,
            },
        })

        local cmp = require("cmp")
        local luasnip = require("luasnip")
        luasnip.config.setup({})
        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            completion = { completeopt = 'menu,menuone,noinsert' },
            mapping = cmp.mapping.preset.insert({
                -- TODO Rethink these mappings
                -- `Enter` key to confirm completion
                -- ["<CR>"] = cmp.mapping.confirm({ select = false }),
                -- TAB key to confirm completion
                ["<tab>"] = cmp.mapping.confirm({ select = false }),

                -- Ctrl+Space to trigger completion menu
                ["<C-Space>"] = cmp.mapping.complete(),

                -- Scroll up and down in the completion documentation
                ["<C-k>"] = cmp.mapping.scroll_docs(-4),
                ["<C-j>"] = cmp.mapping.scroll_docs(4),
            }),
            sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                },
                {
                    { name = "buffer" },
                }),
        })

        vim.diagnostic.config({
            update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        -- Lspattach rempapping: for the moment I am testing these remappings
        -- those are the default ones in the future maybe I will move them into init.lua
        -- considering maybe I will add my own autogroups in the future
        -- TODO: add comments for the remapping
        -- TODO: add the following vim.keymap.set("n", "<leader>ws", require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
                local opts = { buffer = ev.buf }
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "<C-h>", vim.lsp.buf.signature_help, opts)
                vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
                vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
                vim.keymap.set("n", "<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts)
                vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            end,
        })
    end
}
