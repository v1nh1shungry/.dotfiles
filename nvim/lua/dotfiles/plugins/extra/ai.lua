if not vim.env.AVANTE_NVIM_API_KEY then
  vim.notify("`AVANTE_NVIM_API_KEY` is not set", vim.log.levels.WARN, { title = "Avante" })
  return {}
end

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
    event = "VeryLazy",
    ---@module "avante.config"
    ---@type avante.Config
    opts = {
      provider = "deepseek",
      vendors = {
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "AVANTE_NVIM_API_KEY",
          endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1",
          model = "deepseek-r1",
          disable_tools = true,
        },
      },
      file_selector = { provider = "snacks" },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "saghen/blink.compat",
      ---@module "blink.compat.config"
      ---@type blink.compat.Config
      opts = {},
    },
    ---@module "blink.cmp.config.types_partial"
    ---@type blink.cmp.Config
    opts = {
      sources = {
        compat = { "avante_commands", "avante_mentions", "avante_files" },
        per_filetype = { AvanteInput = { "avante_commands", "avante_mentions", "avante_files" } },
      },
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
