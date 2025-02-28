---@module "lazy.types"
---@type LazySpec[]
return {
  { "folke/tokyonight.nvim", lazy = true },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = { ---@type CatppuccinOptions
      integrations = {
        avante = { enabled = true },
        blink_cmp = true,
        dadbod_ui = true,
        diffview = true,
        dropbar = { enabled = true, color_mode = true },
        grug_far = true,
        mason = true,
        native_lsp = { ---@type CtpIntegrationNativeLsp|{}
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        noice = true,
        snacks = true,
        which_key = true,
      },
    },
    specs = {
      {
        "akinsho/bufferline.nvim",
        ---@module "bufferline.config"
        ---@param opts bufferline.Config
        opts = function(_, opts)
          if (vim.g.colors_name or ""):find("catppuccin") then
            opts.highlights = require("catppuccin.groups.integrations.bufferline").get() --[[@as table<string, bufferline.HLGroup>]]
          end
        end,
      },
    },
  },
}
