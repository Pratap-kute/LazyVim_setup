return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")

      -- 1. Define the adapter to point to your Makefile's server
      dap.adapters.go = {
        type = "server",
        host = "127.0.0.1",
        port = 2345,
      }

      -- 2. Add the configuration to the existing list (don't overwrite)
      dap.configurations.go = dap.configurations.go or {}
      table.insert(dap.configurations.go, {
        type = "go",
        name = "Attach to Makefile Delve",
        request = "attach",
        mode = "remote",
        port = 2345,
        host = "127.0.0.1",
        -- Use substitutePath if the code is in a container,
        -- otherwise DAP usually handles local paths fine.
      })
    end,
  },
}
