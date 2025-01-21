return {
    "cyuria/build.nvim",
    opts = {
        set_makeprg_immediately = true,

        update_on_event = {},
        root_files = {
            ".git",
            "package.json",
            "_darcs",
            ".hg",
            ".bzr",
            ".svn",
        },
        build_dirs = {
            "build", "builddir", "bin"
        },
        indicators = {
            ["CMakeLists.txt"] = "cmake",
            ["Makefile"] = "make",
            ["meson.build"] = "meson",
            ["Cargo.toml"] = "cargo",
            ["build.zig"] = "zig",
            ["setup.py"] = "setuptools",
        },
        extra_indicators = {},
        extra_programs = {},
        build_dirs_file = vim.fn.stdpath('data') .. '/build.nvim/build_directories.json',
    }
}
