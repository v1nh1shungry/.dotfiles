return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "javascript", "jsdoc", "tsx", "typescript" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = { completion = { enableServerSideFuzzyMatch = true } },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
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
  {
    "monaqa/dial.nvim",
    opts = function(_, opts)
      local augend = require("dial.augend")

      opts = vim.tbl_deep_extend("force", opts or {}, {
        typescript = {
          augend.integer.alias.decimal,
          augend.constant.alias.bool,
          augend.constant.new({ elements = { "&&", "||" } }),
          augend.constant.new({ elements = { "==", "!=" } }),
          augend.constant.new({ elements = { "let", "const" } }),
        },
      })

      opts.javascript = opts.typescript
    end,
  },
}
