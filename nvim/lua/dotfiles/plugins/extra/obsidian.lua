local VAULT_DIR = vim.fs.joinpath(vim.uv.os_homedir(), "Documents", "notes")

return {
  {
    "obsidian-nvim/obsidian.nvim",
    cmd = "Obsidian",
    event = {
      "BufReadPre " .. vim.fs.joinpath(VAULT_DIR, "*.md"),
      "BufNewFile " .. vim.fs.joinpath(VAULT_DIR, "*.md"),
    },
    opts = {
      completion = {
        blink = true,
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
