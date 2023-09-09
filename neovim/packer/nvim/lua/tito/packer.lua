-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- Colorscheme
    -- use({ 'rose-pine/neovim', as = 'rose-pine' })
    use { "catppuccin/nvim", as = "catppuccin" }

    -- TreeSitter
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

    -- Harpoon
    use('ThePrimeagen/harpoon')

    -- Git Fugitive
    use('tpope/vim-fugitive')

    -- LSP
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },             -- Required
            { 'williamboman/mason.nvim' },           -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        }
    }

    -- DAP, DAP-UI, DAP virtual text, telescopic DAP
    use { 'mfussenegger/nvim-dap' }
    use { 'mfussenegger/nvim-dap-python' }
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
    use { 'theHamsta/nvim-dap-virtual-text'}
    use { 'nvim-telescope/telescope-dap.nvim'}

    -- Add indentation guides even on blank lines
    use {
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help indent_blankline.txt`
        opts = {
            char = '┊',
            show_trailing_blankline_indent = false,
        },
    }

    -- "gc" to comment visual regions/lines
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    -- lualine
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    -- juliavim
    use { "JuliaEditorSupport/julia-vim" }
end)
