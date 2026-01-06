-- FIXME: automatically installing is broken due to plugins' resolving order.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = {
      "TSInstall",
      "TSInstallFromGrammar",
      "TSUninstall",
      "TSUpdate",
    },
    config = function(_, opts)
      require("nvim-treesitter").install(opts.ensure_installed)

      Dotfiles.treesitter.on_available(function(buf)
        vim.treesitter.start(buf)

        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"
      end)
    end,
    event = "LazyFile",
    dependencies = {
      "mason-org/mason.nvim",
      opts = {
        ensure_installed = { "tree-sitter-cli" },
      },
    },
    opts = {
      ensure_installed = {
        "bash",
        "cmake",
        "c",
        "cpp",
        "diff",
        "doxygen",
        "fish",
        "gitcommit",
        "glsl",
        "html",
        "http",
        "json",
        "just",
        "lua",
        "luadoc",
        "luap",
        "make",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "rust",
        "sql",
        "vim",
        "vimdoc",
        "yaml",
      },
    },
    opts_extend = { "ensure_installed" },
  },
}
