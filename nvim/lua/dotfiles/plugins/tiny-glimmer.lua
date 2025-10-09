return {
  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    opts = {
      overwrite = {
        yank = {
          default_animation = {
            name = "fade",
            settings = {
              from_color = "IncSearch",
            },
          },
        },
        paste = {
          default_animation = {
            name = "reverse_fade",
            settings = {
              from_color = "IncSearch",
            },
          },
        },
        undo = {
          enabled = true,
          default_animation = {
            settings = {
              from_color = "IncSearch",
            },
          },
        },
        redo = {
          enabled = true,
          default_animation = {
            settings = {
              from_color = "IncSearch",
            },
          },
        },
      },
    },
  },
}
