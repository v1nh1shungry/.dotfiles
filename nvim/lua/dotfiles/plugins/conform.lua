return {
  {
    "stevearc/conform.nvim",
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
    dependencies = {
      "williamboman/mason.nvim",
      opts = {
        ensure_installed = vim.version.cmp(vim.g.glibc_version, "2.31") > 0 and { "stylua" } or {},
      },
    },
    keys = {
      { "<Leader>cf", function() require("conform").format() end, desc = "Format Document", mode = { "n", "x" } },
    },
    opts = {
      default_format_opts = { lsp_format = "fallback" },
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        fish = { "fish_indent" },
        lua = { "stylua" },
        json = { "jq" },
        jsonc = { "jq" },
        just = { "just" },
        markdown = { "injected" },
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
