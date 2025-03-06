---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = { { "<Leader>s/", "<Cmd>GrugFar<CR>", desc = "Search & Replace" } },
    ---@module "grug-far.opts"
    ---@type GrugFarOptionsOverride
    opts = {},
  },
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    keys = {
      { "<CR>", "<Cmd>Rest run<CR>", desc = "Send Request", ft = "http" },
      { "yr", "<Cmd>Rest curl yank<CR>", desc = "Copy Request", ft = "http" },
    },
  },
  {
    "v1nh1shungry/cppman.nvim",
    cmd = "Cppman",
    enabled = vim.fn.executable("cppman") == 1,
    keys = { { "<Leader>sc", "<Cmd>Cppman<CR>", desc = "Cppman" } },
    ---@module "cppman.config"
    ---@type cppman.Config|{}
    opts = { picker = "snacks" },
  },
  {
    "v1nh1shungry/lyricify.nvim",
    -- TODO: use `main` branch after the branch is stable and merged
    branch = "feature/playerctl",
    config = function(_, opts)
      require("lyricify").setup(opts)

      Snacks.toggle({
        name = "lyricify.nvim",
        get = function()
          return require("lyricify").enabled
        end,
        set = function()
          vim.cmd("Lyricify toggle")
        end,
      }):map("<Leader>uL")
    end,
    event = "VeryLazy",
    opts = { diff_time = 5000 }, ---@type lyricify.config.Opts|{}
  },
}
