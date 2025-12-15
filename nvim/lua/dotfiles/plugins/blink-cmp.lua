return {
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    dependencies = "xzbdmw/colorful-menu.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        enabled = false,
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        list = {
          selection = {
            preselect = function() return not require("blink.cmp").snippet_active({ direction = 1 }) end,
          },
        },
        menu = {
          draw = {
            columns = { { "kind_icon" }, { "label", gap = 1 } },
            components = {
              label = {
                text = function(ctx) return require("colorful-menu").blink_components_text(ctx) end,
                highlight = function(ctx) return require("colorful-menu").blink_components_highlight(ctx) end,
              },
            },
          },
        },
      },
      fuzzy = {
        prebuilt_binaries = {
          download = false,
        },
      },
      keymap = {
        preset = "super-tab",
      },
      signature = {
        enabled = true,
      },
      sources = {
        default = { "lsp", "snippets", "path", "buffer" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
  },
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        signature = {
          enabled = false,
        },
      },
    },
  },
}
