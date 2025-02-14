if not vim.env.AVANTE_NVIM_API_KEY then
  vim.notify("`AVANTE_NVIM_API_KEY` is not set", vim.log.levels.WARN, { title = "Avante" })
  return {}
end

vim.api.nvim_create_autocmd("FileType", {
  command = "let b:snacks_image_attached = v:true",
  group = Dotfiles.augroup("avante_disable_image"),
  pattern = "Avante",
})

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
    keys = { { "<Leader>a", desc = "+ai" } },
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
      opts = {},
    },
    opts = { sources = { compat = { "avante_commands", "avante_mentions", "avante_files" } } },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = { file_types = { "Avante" } },
    ft = "Avante",
  },
}
