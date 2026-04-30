return {
  {
    "milanglacier/minuet-ai.nvim",
    enabled = vim.env.ANTHROPIC_AUTH_TOKEN,
    opts = {
      provider = "openai_compatible",
      provider_options = {
        openai_compatible = {
          api_key = "ANTHROPIC_AUTH_TOKEN",
          end_point = "https://open.bigmodel.cn/api/coding/paas/v4/chat/completions",
          model = "glm-4.5-air",
          name = "Zhipu",
          optional = {
            thinking = {
              type = "disabled",
            },
          },
        },
      },
      virtualtext = {
        keymap = {
          accept = "<M-A>",
          accept_line = "<M-a>",
          prev = "<M-[>",
          next = "<M-]>",
          dismiss = "<M-e>",
        },
      },
    },
  },
}
