-- https://www.lazyvim.org/extras/lang/rust {{{
---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "nvim-treesitter/nvim-treesitter",
    ---@module "nvim-treesitter.configs"
    ---@type TSConfig|{}
    opts = { ensure_installed = { "rust", "toml" } },
  },
  {
    "Saecki/crates.nvim",
    event = "BufRead Cargo.toml",
    ---@module "crates.types"
    ---@type crates.UserConfig
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
  {
    "mrcjkb/rustaceanvim",
    config = function()
      ---@module "rustaceanvim.config"
      ---@type rustaceanvim.Opts
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
            Dotfiles.map({ "<Leader>cR", "<Cmd>RustLsp! runnables<CR>", buffer = bufnr, desc = "Execute" })
            Dotfiles.map({ "<Leader>cT", "<Cmd>RustLsp! testables<CR>", buffer = bufnr, desc = "Run Test" })
            Dotfiles.map({ "<C-j>", "<Cmd>RustLsp moveItem down<CR>", buffer = bufnr, desc = "Move Down" })
            Dotfiles.map({ "<C-k>", "<Cmd>RustLsp moveItem up<CR>", buffer = bufnr, desc = "Move Up" })
            Dotfiles.map({
              "<Leader>ce",
              "<Cmd>RustLsp explainError current<CR>",
              buffer = bufnr,
              desc = "Explain Error",
            })
            Dotfiles.map({
              "<C-w>d",
              "<Cmd>RustLsp renderDiagnostic current<CR>",
              buffer = bufnr,
              desc = "Show Diagnostics",
            })
            Dotfiles.map({ "gX", "<Cmd>RustLsp openDocs<CR>", buffer = bufnr, desc = "Open docs.rs" })
            Dotfiles.map({ "J", "<Cmd>RustLsp joinLines<CR>", buffer = bufnr, desc = "Join" })
          end,
        },
      }
    end,
    ft = "rust",
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "rust-analyzer" } }, ---@type dotfiles.mason.Config
  },
}
-- }}}
