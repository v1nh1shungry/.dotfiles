return { ---@type vim.lsp.Config
  settings = {
    json = {
      format = { enable = true },
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}
