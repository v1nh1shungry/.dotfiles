return {
  {
    "olimorris/codecompanion.nvim",
    cmd = "CodeCompanionChat",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    enabled = function()
      if not vim.env.CODECOMPANION_NVIM_API_KEY then
        Dotfiles.notify.warn("`CODECOMPANION_NVIM_API_KEY` is not set")
        return false
      end

      return true
    end,
    keys = {
      { "<Leader>a", "", desc = "+ai" },
      { "<Leader>aa", "<Cmd>CodeCompanionChat Toggle<CR>", desc = "Chat" },
      { "<Leader>aa", "<Cmd>CodeCompanionChat Add<CR>", mode = "x", desc = "Add Selected to Chat" },
      { "<Leader>a/", "<Cmd>CodeCompanionActions<CR>", desc = "Actions" },
    },
    opts = {
      adapters = {
        qwen = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://dashscope.aliyuncs.com/compatible-mode",
              api_key = "CODECOMPANION_NVIM_API_KEY",
            },
            schema = {
              model = {
                default = "qwen-plus-2025-07-28",
              },
            },
          })
        end,
      },
      opts = {
        language = "Chinese",
      },
      strategies = {
        chat = {
          adapter = "qwen",
        },
      },
    },
  },
}
