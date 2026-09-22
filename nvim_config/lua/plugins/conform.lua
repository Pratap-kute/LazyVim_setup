return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local util = require("conform.util")
      local original = opts.formatters_by_ft or {}

      local function project_formatter(ft)
        local fallback = original[ft]

        return function(bufnr)
          local file = vim.api.nvim_buf_get_name(bufnr)
          local root = vim.fs.root(file, { "biome.json" })

          if root then
            return { "biome" }
          end

          if type(fallback) == "function" then
            return fallback(bufnr)
          end

          return fallback or {}
        end
      end

      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs({
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      }) do
        opts.formatters_by_ft[ft] = project_formatter(ft)
      end

      opts.formatters = opts.formatters or {}
      opts.formatters.biome = {
        command = "deno",
        args = {
          "x",
          "npm:@biomejs/biome",
          "format",
          "--stdin-file-path",
          "$FILENAME",
        },
        cwd = util.root_file({ "biome.json" }),
        require_cwd = true,
      }
    end,
  },
}
