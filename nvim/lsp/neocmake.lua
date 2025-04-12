return { ---@type vim.lsp.Config
  cmd = { "neocmakelsp", "--stdio" },
  filetypes = { "cmake" },
  root_markers = { ".git", "build", "cmake" },
}
