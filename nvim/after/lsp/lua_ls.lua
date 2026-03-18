---@module "lspconfig"
return {
  settings = { ---@type lspconfig.settings.lua_ls
    Lua = {
      addonManager = {
        enable = false,
      },
      completion = {
        autoRequire = false,
        keywordSnippet = "Disable",
        showWord = "Disable",
        workspaceWord = false,
      },
      doc = {
        privateName = { "^_" },
      },
      format = {
        enable = false,
      },
      hint = {
        arrayIndex = "Disable",
        enable = true,
        paramName = "Disable",
        semicolon = "Disable",
      },
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = "Disable",
      },
    },
  },
}
