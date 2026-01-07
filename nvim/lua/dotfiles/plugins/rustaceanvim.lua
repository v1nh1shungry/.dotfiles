return {
  {
    "mrcjkb/rustaceanvim",
    config = function()
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
              },
              checkOnSave = true,
              files = {
                excludeDirs = {
                  ".direnv",
                  ".git",
                  ".github",
                  ".gitlab",
                  ".venv",
                  "bin",
                  "node_modules",
                  "target",
                  "venv",
                },
                watcher = "client",
              },
            },
          },
          on_attach = function(_, bufnr)
            local map = Dotfiles.map_with({ buffer = bufnr })
            map({ "<Leader>cR", "<Cmd>RustLsp! runnables<CR>", desc = "Execute (Rust)" })
            map({ "<Leader>cT", "<Cmd>RustLsp! testables<CR>", desc = "Run Test (Rust)" })
          end,
        },
      }
    end,
    ft = "rust",
  },
}
