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
        local cmp_lsp = require('cmp_nvim_lsp')

        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("fidget").setup({})
        require("mason").setup({})
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "pylsp", "cmake", "julials", "clangd" },
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
                -- julials specific config (Still under testing not sure about the configuration)
                ["julials"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.julials.setup({
                        -- For infos: https://discourse.julialang.org/t/neovim-languageserver-jl/37286/91?page=5
                        -- on_new_config = function(new_config, _)
                        --     local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/")
                        --     lspconfig.util.path.is_file(julia)
                        --     new_config.cmd[1] = julia
                        -- end,
                        -- This just adds dirname(fname) as a fallback (see nvim-lspconfig#1768).
                        root_dir = function(fname)
                            local util = require 'lspconfig.util'
                            return util.root_pattern 'Project.toml' (fname) or util.find_git_ancestor(fname) or
                                util.path.dirname(fname)
                        end,
                        julia_env_path = { "/Users/tdinelli/.julia/environments/nvim-lspconfig" },
                        capabilities = capabilities,
                    })
                end,
            },
        })

        local cmp = require("cmp")
        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                -- TODO Rethink these mappings
                -- `Enter` key to confirm completion
                ['<CR>'] = cmp.mapping.confirm({ select = false }),

                -- Ctrl+Space to trigger completion menu
                ['<C-Space>'] = cmp.mapping.complete(),

                -- Scroll up and down in the completion documentation
                ['<C-k>'] = cmp.mapping.scroll_docs(-4),
                ['<C-j>'] = cmp.mapping.scroll_docs(4),
            }),
            sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                },
                {
                    { name = "buffer" },
                }),
            -- This I am just trying what they do beacuse I dont actually know
            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            -- cmp.setup.cmdline({ '/', '?' }, {
            --     mapping = cmp.mapping.preset.cmdline(),
            --     sources = {
            --         { name = 'buffer' }
            --     }
            -- }),
            -- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            -- cmp.setup.cmdline(':', {
            --     mapping = cmp.mapping.preset.cmdline(),
            --     sources = cmp.config.sources({
            --         { name = 'path' }
            --     }, {
            --             { name = 'cmdline' }
            --         })
            -- })
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
