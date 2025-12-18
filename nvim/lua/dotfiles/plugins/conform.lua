return {
  {
    "stevearc/conform.nvim",
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
    dependencies = {
      "williamboman/mason.nvim",
      opts = {
        ensure_installed = { "stylua" },
      },
    },
    keys = {
      { "<Leader>cf", function() require("conform").format() end, desc = "Format Document", mode = { "n", "x" } },
    },
    opts = {
      default_format_opts = {
        lsp_format = "prefer",
      },
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        fish = { "fish_indent" },
        lua = { "stylua", lsp_format = "never" },
        json = { "jq" },
        jsonc = { "jq" },
        just = { "just" },
        markdown = { "injected" },
        python = { "ruff_format" },
        query = { "format-queries" },
      },
      formatters = {
        ["clang-format"] = {
          prepend_args = { "--fallback-style=llvm" },
        },
        injected = {
          options = {
            ignore_errors = true,
          },
        },
      },
    },
  },
}
