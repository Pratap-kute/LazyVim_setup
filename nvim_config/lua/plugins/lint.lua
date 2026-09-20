return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local golangcilint = require("lint.linters.golangcilint")
      opts.linters = opts.linters or {}
      opts.linters.golangcilint = function()
        local linter = vim.deepcopy(golangcilint)
        local filename = vim.api.nvim_buf_get_name(0)
        local module_root = vim.fs.root(filename, { "go.mod" })

        -- A go.work root can have GOMOD=/dev/null despite containing valid modules.
        -- Resolve from the buffer so sibling Go files are included in type checking.
        linter.cwd = module_root or vim.fs.dirname(filename)
        linter.args[#linter.args] = module_root and vim.fs.dirname(filename) or filename
        return linter
      end
    end,
  },
}
