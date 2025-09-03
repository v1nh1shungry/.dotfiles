return { ---@type vim.lsp.Config
  cmd = {
    "clangd",
    "--fallback-style=llvm",
    "--header-insertion=never",
    "-j=" .. vim.uv.available_parallelism(),
  },
}
