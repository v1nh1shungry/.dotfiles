return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      gopls = {
        -- https://www.lazyvim.org/extras/lang/go {{{
        setup = function(client)
          if not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            client.server_capabilities.semanticTokensProvider = {
              full = true,
              legend = {
                tokenTypes = semantic.tokenTypes,
                tokenModifiers = semantic.tokenModifiers,
              },
              range = true,
            }
          end
        end,
      },
      -- }}}
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "go",
        "gomod",
        "gosum",
        "gowork",
      },
    },
  },
}
