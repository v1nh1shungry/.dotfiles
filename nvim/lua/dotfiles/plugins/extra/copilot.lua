return {
  {
    "folke/sidekick.nvim",
    dependencies = {
      {
        "neovim/nvim-lspconfig",
        opts = {
          copilot = {
            keys = {
              {
                "<Tab>",
                function()
                  if not require("sidekick").nes_jump_or_apply() then
                    return "<Tab>"
                  end
                end,
                desc = "Next Edit Suggestion",
                expr = true,
              },
              { "<M-a>", function() require("sidekick.nes").update() end, desc = "Refresh Next Edit Suggestion" },
            },
            mason = "copilot-language-server",
          },
        },
      },
      {
        "saghen/blink.cmp",
        opts = {
          keymap = {
            ["<Tab>"] = {
              function(cmp)
                if cmp.snippet_active() then
                  return cmp.accept()
                else
                  return cmp.select_and_accept()
                end
              end,
              "snippet_forward",
              function() return require("sidekick").nes_jump_or_apply() end,
              "fallback",
            },
          },
        },
      },
    },
    event = "LspAttach",
  },
}
