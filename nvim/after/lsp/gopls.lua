-- https://www.lazyvim.org/extras/lang/go {{{
return {
  settings = {
    gopls = {
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      completeUnimported = true,
      codelenses = {
        test = true,
      },
      directoryFilters = {
        "-.git",
        "-.idea",
        "-.vscode",
        "-.vscode-test",
        "-node_modules",
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      staticcheck = true,
      semanticTokens = true,
      usePlaceholders = true,
    },
  },
}
-- }}}
