return {
  {
    "ravitemer/mcphub.nvim",
    build = "bundled_build.lua",
    cmd = "MCPHub",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
      auto_approve = true,
      auto_toggle_mcp_servers = false,
      config = vim.fs.joinpath(vim.fn.stdpath("config"), "mcphub.json"),
      use_bundled_binary = true,
    },
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = "ravitemer/mcphub.nvim",
    opts = {
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            show_result_in_chat = false,
            show_server_tools_in_chat = false,
          },
        },
      },
    },
  },
  {
    "coder/claudecode.nvim",
    dependencies = "ravitemer/mcphub.nvim",
  },
}
