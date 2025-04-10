---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "yetone/avante.nvim",
    build = "make BUILD_FROM_SOURCE=true",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim",
      "echasnovski/mini.icons",
    },
    enabled = function()
      if not vim.env.AVANTE_NVIM_API_KEY then
        vim.notify("`AVANTE_NVIM_API_KEY` is not set", vim.log.levels.WARN, { title = "Avante" })
        return false
      end
      return true
    end,
    event = "VeryLazy",
    ---@module "avante.config"
    ---@type avante.Config
    opts = {
      provider = "qwen",
      vendors = {
        qwen = {
          __inherited_from = "openai",
          api_key_name = "AVANTE_NVIM_API_KEY",
          endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1",
          model = "qwq-32b",
        },
      },
      behaviour = { enable_cursor_planning_mode = true },
      file_selector = { provider = "snacks" },
    },
  },
  {
    "folke/which-key.nvim",
    ---@module "which-key.config"
    ---@type wk.Opts|{}
    opts = {
      spec = {
        {
          mode = { "n", "v" },
          { "<Leader>a", group = "ai" },
        },
      },
    },
  },
}
