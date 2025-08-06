-- https://www.lazyvim.org/extras/lang/rust {{{
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "rust", "toml" } },
  },
  {
    "Saecki/crates.nvim",
    event = "BufRead Cargo.toml",
    opts = {
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
  {
    "mrcjkb/rustaceanvim",
    config = function()
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
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
          on_attach = function(_, bufnr)
            local map = Dotfiles.map_with({ buffer = bufnr })
            map({ "<Leader>cR", "<Cmd>RustLsp! runnables<CR>", desc = "Execute" })
            map({ "<Leader>cT", "<Cmd>RustLsp! testables<CR>", desc = "Run Test" })
            map({ "<C-w>d", "<Cmd>RustLsp renderDiagnostic current<CR>", desc = "Show Diagnostics" })
            map({ "]d", "<Cmd>RustLsp renderDiagnostic cycle<CR>", desc = "Next Diagnostic" })
            map({ "[d", "<Cmd>RustLsp renderDiagnostic cycle_prev<CR>", desc = "Previous Diagnostic" })
            map({ "<C-w>e", "<Cmd>RustLsp explainError current<CR>", desc = "Explain Error" })
          end,
        },
      }
    end,
    ft = "rust",
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "rust-analyzer" } },
  },
}
-- }}}
