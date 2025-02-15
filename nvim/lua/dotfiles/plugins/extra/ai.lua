if not vim.env.AVANTE_NVIM_API_KEY then
  vim.notify("`AVANTE_NVIM_API_KEY` is not set", vim.log.levels.WARN, { title = "Avante" })
  return {}
end

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
    keys = "<Leader>a",
    opts = {
      provider = "qwen",
      vendors = {
        qwen = {
          __inherited_from = "openai",
          api_key_name = "AVANTE_NVIM_API_KEY",
          endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1",
          model = "qwen-max-latest",
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
      opts = {},
    },
    opts = {
      sources = {
        compat = { "avante_commands", "avante_mentions", "avante_files" },
        per_filetype = { AvanteInput = { "avante_commands", "avante_mentions", "avante_files" } },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "Avante" },
    opts = { file_types = { "Avante" } },
  },
  {
    "folke/which-key.nvim",
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
