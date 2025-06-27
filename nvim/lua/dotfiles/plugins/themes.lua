return vim
  .iter({
    "folke/tokyonight.nvim",
    {
      "catppuccin/nvim",
      name = "catppuccin",
      opts = {
        integrations = {
          blink_cmp = true,
          dadbod_ui = true,
          diffview = true,
          dropbar = { enabled = true, color_mode = true },
          grug_far = true,
          mason = true,
          native_lsp = {
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
          noice = true,
          snacks = { enabled = true },
          which_key = true,
        },
      },
    },
    "rebelot/kanagawa.nvim",
  })
  :map(function(spec)
    if type(spec) == "string" then
      spec = { spec }
    end
    spec.lazy = true
    spec.priority = 1000
    return spec
  end)
  :totable()
