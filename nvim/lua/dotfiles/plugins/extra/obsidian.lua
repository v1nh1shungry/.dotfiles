local VAULT_DIR = vim.fs.joinpath(vim.uv.os_homedir(), "Documents", "notes")

return {
  {
    "obsidian-nvim/obsidian.nvim",
    cmd = "Obsidian",
    dependencies = {
      "saghen/blink.cmp",
      "ibhagwan/fzf-lua",
      "folke/snacks.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    event = {
      "BufReadPre " .. vim.fs.joinpath(VAULT_DIR, "*.md"),
      "BufNewFile " .. vim.fs.joinpath(VAULT_DIR, "*.md"),
    },
    opts = {
      completion = {
        blink = true,
      },
      picker = {
        name = "fzf-lua",
      },
      workspaces = {
        {
          name = "notes",
          path = VAULT_DIR,
        },
      },
    },
  },
}
