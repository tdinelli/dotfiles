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
            ensure_installed = { "lua_ls", "pylsp", "cmake", "julials", "clangd", "fortls" },
            handlers = {
                -- This handles all the LSP automatically
                function(server_name)
                    require("lspconfig")[server_name].setup({
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

                -- pylsp specific config
                ["pylsp"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.pylsp.setup({
                        capabilities = capabilities,
                        settings = {
                            pylsp = {
                                plugins = {
                                    pycodestyle = { enabled = true, maxLineLength = 89},
                                    pyls_isort = { enabled = false },
                                },

                            }
                        }
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
                            "--hover_language=fortran",
                            "--use_signature_help"
                        },
                    })
                end,

                -- julials specific config (Still under testing not sure about the configuration)
                ["julials"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.julials.setup({
                        capabilities = capabilities,
                        -- For infos: https://discourse.julialang.org/t/neovim-languageserver-jl/37286/91?page=5
                        -- on_new_config = function(new_config, _)
                        --     local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/")
                        --     lspconfig.util.path.is_file(julia)
                        --     new_config.cmd[1] = julia
                        -- end,
                        -- This just adds dirname(fname) as a fallback (see nvim-lspconfig#1768).
                        root_dir = function(fname)
                            local util = require "lspconfig.util"
                            return util.root_pattern "Project.toml" (fname) or util.find_git_ancestor(fname) or
                                util.path.dirname(fname)
                        end,
                        julia_env_path = { "$HOME/.julia/environments/nvim-lspconfig" },
                    })
                end,

                -- clangd config, see this: http://www.lazyvim.org/extras/lang/clangd
                ["clangd"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.clangd.setup({
                        capabilities = capabilities,
                        cmd = {
                            -- "$HOME/.local/share/nvim/mason/bin/clangd",
                            "/Users/tdinelli/.local/share/nvim/mason/bin/clangd",
                            "--background-index",
                            "--clang-tidy",
                            "--header-insertion=iwyu",
                            "--completion-style=detailed",
                            "--function-arg-placeholders",
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
                vim.keymap.set("n", "<leader>f", function()
                    vim.lsp.buf.format { async = true }
                end, opts)
            end,
        })
    end
}
