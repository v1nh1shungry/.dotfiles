return { ---@type vim.lsp.Config
  settings = {
    Lua = {
      completion = {
        autoRequire = false,
        keywordSnippet = "Disable",
      },
      doc = { privateName = { "^_" } },
      hint = {
        arrayIndex = "Disable",
        awaitPropagate = true,
        enable = true,
        setType = false,
        semicolon = "Disable",
      },
      workspace = { checkThirdParty = false },
    },
  },
}
