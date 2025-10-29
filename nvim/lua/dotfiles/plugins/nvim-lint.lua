-- https://www.lazyvim.org/plugins/linting {{{
return {
  {
    "mfussenegger/nvim-lint",
    config = function(_, opts)
      local lint = require("lint")

      for name, linter in pairs(opts.linters or {}) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name] --[[@as lint.Linter]], linter)
        else
          lint.linters[name] = linter
        end
      end

      lint.linters_by_ft = opts.linters_by_ft

      ---@class dotfiles.plugins.nvim_lint.Linter: lint.Linter
      ---@field condition fun(): boolean

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          local names = vim
            .iter(lint._resolve_linter_by_ft(vim.bo.filetype))
            :filter(function(name)
              local linter = lint.linters[name]
              ---@cast linter dotfiles.plugins.nvim_lint.Linter
              if not linter then
                Snacks.notify.warn("Linter not found: " .. name)
                return false
              end
              return not (type(linter) == "table" and linter.condition and not linter.condition())
            end)
            :totable()

          if #names > 0 then
            lint.try_lint(names)
          end
        end,
        desc = "Run linter automatically",
        group = Dotfiles.augroup("plugins.nvim-lint"),
      })
    end,
    event = "LazyFile",
    opts = {
      linters_by_ft = {
        bash = { "bash" },
        fish = { "fish" },
        sh = { "bash" },
      },
    },
  },
}
-- }}}
