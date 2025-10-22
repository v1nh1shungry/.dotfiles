return {
  cmd = {
    "clangd",
    "--header-insertion=never",
    "-j=" .. vim.uv.available_parallelism(),
  },
}
