return {
  {
    "Saecki/crates.nvim",
    event = "BufRead Cargo.toml",
    opts = {
      lsp = {
        actions = true,
        completion = true,
        enabled = true,
        hover = true,
      },
    },
  },
}
