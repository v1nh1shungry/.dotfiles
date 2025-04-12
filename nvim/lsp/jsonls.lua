return { ---@type vim.lsp.Config
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  init_options = {
    provideFormatter = true,
  },
  root_markers = { ".git" },
  settings = {
    json = {
      format = { enable = true },
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}
