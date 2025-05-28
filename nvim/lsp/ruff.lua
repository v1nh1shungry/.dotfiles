return { ---@type vim.lsp.Config
  cmd = { "ruff", "server" },
  cmd_env = { RUFF_TRACE = "messages" },
  filetypes = { "python" },
  init_options = { settings = { logLevel = "error" } },
  on_attach = function(client) client.server_capabilities.hoverProvider = false end,
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
}
