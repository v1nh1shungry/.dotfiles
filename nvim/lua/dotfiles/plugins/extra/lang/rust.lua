-- https://www.lazyvim.org/extras/lang/rust {{{
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "rust", "toml" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = { enable = true },
              },
              checkOnSave = true,
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
              files = {
                excludeDirs = {
                  ".direnv",
                  ".git",
                  ".github",
                  ".gitlab",
                  "bin",
                  "node_modules",
                  "target",
                  "venv",
                  ".venv",
                },
              },
            },
          },
        },
      },
    },
  },
  {
    "Saecki/crates.nvim",
    event = "BufRead Cargo.toml",
    opts = {
      completion = { crates = { enabled = true } },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
}
-- }}}
