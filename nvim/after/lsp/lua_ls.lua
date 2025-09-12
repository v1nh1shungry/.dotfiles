return { ---@type vim.lsp.Config
  settings = {
    Lua = {
      codeLens = {
        enable = true,
      },
      completion = {
        autoRequire = false,
        keywordSnippet = "Disable",
      },
      doc = {
        privateName = { "^_" },
      },
      hint = {
        arrayIndex = "Disable",
        enable = true,
        setType = false,
        semicolon = "Disable",
        paramName = "Disable",
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
}
