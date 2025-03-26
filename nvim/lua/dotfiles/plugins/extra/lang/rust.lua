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
            local map = Dotfiles.map_with({ buffer = bufnr })
            map({ "<Leader>cR", "<Cmd>RustLsp! runnables<CR>", desc = "Execute" })
            map({ "<Leader>cT", "<Cmd>RustLsp! testables<CR>", desc = "Run Test" })
            map({ "<C-w>D", "<Cmd>RustLsp renderDiagnostic current<CR>", desc = "Show Diagnostics" })
            map({ "<C-w><C-d>", "<Cmd>RustLsp explainError current<CR>", desc = "Explain Error" })
            map({ "J", "<Cmd>RustLsp joinLines<CR>", desc = "Join" })
            map({ "<Leader>sr", "<Cmd>RustLsp ssr<CR>", desc = "Structural Search & Replace" })
          end,
        },
        tools = {
          executor = {
            execute_command = function(cmd, args, cwd, _)
              Snacks.terminal(vim.list_extend({ cmd }, args), {
                cwd = cwd,
                interactive = false,
                win = { position = "bottom" },
              })
            end,
          },
          test_executor = "background",
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
