return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      -- import nvim-treesitter plugin
      local treesitter = require("nvim-treesitter.configs")

      -- configure treesitter
      treesitter.setup({ -- enable syntax highlighting
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        -- enable indentation
        indent = { enable = true },
        -- enable autotagging (w/ nvim-ts-autotag plugin)
        autotag = { enable = true },
        -- ensure these language parsers are installed
        ensure_installed = {
          "latex",
          "cpp",
          "c",
          "python",
          "markdown",
          "markdown_inline",
          "bash",
          "lua",
          "vim",
          "vimdoc",
          "gitignore",
        },
        -- auto install above language parsers
        auto_install = false,
      })
    end,
  },
}
