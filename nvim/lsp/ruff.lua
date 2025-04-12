Dotfiles.lsp.on_attach(function(client, _) client.server_capabilities.hoverProvider = false end, "ruff")

return { ---@type vim.lsp.Config
  cmd = { "ruff", "server" },
  cmd_env = { RUFF_TRACE = "messages" },
  filetypes = { "python" },
  init_options = { settings = { logLevel = "error" } },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
}
