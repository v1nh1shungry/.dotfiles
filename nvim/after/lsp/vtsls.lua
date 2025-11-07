-- https://www.lazyvim.org/extras/lang/typescript {{{
return {
  settings = {
    javascript = {
      inlayHints = {
        enumMemberValues = {
          enabled = true,
        },
        functionLikeReturnTypes = {
          enabled = true,
        },
        parameterNames = {
          enabled = "literals",
        },
        parameterTypes = {
          enabled = true,
        },
        propertyDeclarationTypes = {
          enabled = true,
        },
      },
      suggest = {
        completeFunctionCalls = true,
      },
      updateImportsOnFileMove = {
        enabled = "always",
      },
    },
    typescript = {
      inlayHints = {
        enumMemberValues = {
          enabled = true,
        },
        functionLikeReturnTypes = {
          enabled = true,
        },
        parameterNames = {
          enabled = "literals",
        },
        parameterTypes = {
          enabled = true,
        },
        propertyDeclarationTypes = {
          enabled = true,
        },
      },
      suggest = {
        completeFunctionCalls = true,
      },
      updateImportsOnFileMove = {
        enabled = "always",
      },
    },
    vtsls = {
      autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
  },
}
-- }}}
