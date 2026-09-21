return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- full rewrite; incompatible with the legacy `configs`-based API
    build = ":TSUpdate",
    lazy = false, -- this plugin does not support lazy-loading
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
        -- enable_autocmd is off: nothing consumes its pre_hook (no Comment.nvim),
        -- and the autocmd errors on buffers with no attached treesitter parser
        require("ts_context_commentstring").setup({ enable_autocmd = false })

        require("nvim-treesitter").install({
            "cpp", "c", "python", "julia", "markdown", "markdown_inline",
            "bash", "lua", "vim", "vimdoc", "gitignore", "fortran", "make",
            "regex", "yaml", "toml", "json", "cmake"
        })

        -- Highlighting and indentation are no longer configured centrally;
        -- enable them per buffer instead (pcall: no-ops on filetypes with no parser)
        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                pcall(vim.treesitter.start)
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })

        -- Textobjects
        require("nvim-treesitter-textobjects").setup({
            select = { lookahead = true }, -- Automatically jump forward to textobj, similar to targets.vim
            move = { set_jumps = true },   -- whether to set jumps in the jumplist
        })

        local select_obj = require("nvim-treesitter-textobjects.select")
        local move_obj = require("nvim-treesitter-textobjects.move")
        local swap_obj = require("nvim-treesitter-textobjects.swap")

        local textobject_maps = {
            -- You can use the capture groups defined in textobjects.scm
            { { "x", "o" },      "aa", function() select_obj.select_textobject("@parameter.outer", "textobjects") end },
            { { "x", "o" },      "ia", function() select_obj.select_textobject("@parameter.inner", "textobjects") end },
            { { "x", "o" },      "af", function() select_obj.select_textobject("@function.outer", "textobjects") end },
            { { "x", "o" },      "if", function() select_obj.select_textobject("@function.inner", "textobjects") end },
            { { "x", "o" },      "ac", function() select_obj.select_textobject("@class.outer", "textobjects") end },
            { { "x", "o" },      "ic", function() select_obj.select_textobject("@class.inner", "textobjects") end },

            { { "n", "x", "o" }, "]m", function() move_obj.goto_next_start("@function.outer", "textobjects") end },
            { { "n", "x", "o" }, "]]", function() move_obj.goto_next_start("@class.outer", "textobjects") end },
            { { "n", "x", "o" }, "]M", function() move_obj.goto_next_end("@function.outer", "textobjects") end },
            { { "n", "x", "o" }, "][", function() move_obj.goto_next_end("@class.outer", "textobjects") end },
            { { "n", "x", "o" }, "[m", function() move_obj.goto_previous_start("@function.outer", "textobjects") end },
            { { "n", "x", "o" }, "[[", function() move_obj.goto_previous_start("@class.outer", "textobjects") end },
            { { "n", "x", "o" }, "[M", function() move_obj.goto_previous_end("@function.outer", "textobjects") end },
            { { "n", "x", "o" }, "[]", function() move_obj.goto_previous_end("@class.outer", "textobjects") end },

            { "n",               "<leader>a", function() swap_obj.swap_next("@parameter.inner") end },
            { "n",               "<leader>A", function() swap_obj.swap_previous("@parameter.inner") end },
        }
        for _, map in ipairs(textobject_maps) do
            vim.keymap.set(map[1], map[2], map[3])
        end
    end,
}
