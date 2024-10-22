local dap = require("dap")

dap.adapters.python = function(cb, config)
    if config.request == "attach" then
        ---@diagnostic disable-next-line: undefined-field
        local port = (config.connect or config).port
        ---@diagnostic disable-next-line: undefined-field
        local host = (config.connect or config).host or "127.0.0.1"
        cb({
            type = "server",
            port = assert(port, "`connect.port` is required for a python `attach` configuration"),
            host = host,
            options = {
                source_filetype = "python",
            },
        })
    else
        cb({
            type = "executable",
            command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
            args = { "-m", "debugpy.adapter" },
            options = {
                source_filetype = "python",
            },
        })
    end
end

dap.configurations.python = {
    {
        -- The first three options are required by nvim-dap
        type = "python",
        request = "launch",
        name = "Launch file",
        console = "internalConsole",
        justMyCode = true,

        program = "${file}",
        pythonPath = function()
            -- Get the python from the current conda env that is running
            local conda_prefix = os.getenv("CONDA_PREFIX")
            if conda_prefix then
                return conda_prefix .. "/bin/python"
            else
                return "/usr/bin/python"
            end
        end,
    },
}
