return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    cmd = {
      "TSInstall",
      "TSInstallFromGrammar",
      "TSUninstall",
      "TSUpdate",
    },
    config = function(_, opts)
      require("nvim-treesitter").install(opts.ensure_installed)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          if not pcall(vim.treesitter.start) then
            return
          end

          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

          Snacks.toggle.treesitter():map("<Leader>uT")
        end,
        desc = "Enable treesitter highlight and indent",
        group = Dotfiles.augroup("nvim-treesitter"),
      })
    end,
    event = "LazyFile",
    dependencies = {
      "mason-org/mason.nvim",
      opts = {
        ensure_installed = vim.version.cmp(vim.g.glibc_version, "2.31") > 0 and { "tree-sitter-cli" } or {},
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
        "json",
        "just",
        "lua",
        "luadoc",
        "luap",
        "make",
        "markdown",
        "markdown_inline",
        "printf",
        "query",
        "regex",
        "vim",
        "vimdoc",
      },
    },
    opts_extend = { "ensure_installed" },
  },
}
