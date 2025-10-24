return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    opts = {
      code = {
        position = "right",
        width = "block",
      },
      file_types = { "markdown" },
      latex = {
        enabled = false,
      },
      overrides = {
        buftype = {
          nofile = {
            code = {
              language = false,
            },
          },
        },
      },
      pipe_table = {
        border_virtual = true,
      },
      quote = {
        repeat_linebreak = true,
      },
      render_modes = true,
      sign = {
        enabled = false,
      },
    },
    opts_extend = { "file_types" },
  },
}
