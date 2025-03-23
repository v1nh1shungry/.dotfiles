---@module "lazy.types"
---@type LazySpec[]
return {
  -- https://www.lazyvim.org/extras/lang/typescript {{{
  {
    "nvim-treesitter/nvim-treesitter",
    ---@module "nvim-treesitter.configs"
    ---@type TSConfig|{}
    opts = { ensure_installed = { "javascript", "jsdoc", "tsx", "typescript" } },
  },
  {
    "neovim/nvim-lspconfig",
    ---@module "lspconfig"
    ---@type dotfiles.plugins.ide.lspconfig.Config
    opts = {
      servers = {
        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              autoUseWorkspaceTsdk = true,
              experimental = { completion = { enableServerSideFuzzyMatch = true } },
            },
            typescript = {
              suggest = { completeFunctionCalls = true },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
      },
      setup = {
        vtsls = function(_, opts)
          opts.settings.javascript =
            vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
        end,
      },
    },
  },
  -- }}}
}
