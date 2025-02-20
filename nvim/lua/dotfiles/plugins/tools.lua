return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = { { "<Leader>sr", "<Cmd>GrugFar<CR>", desc = "Search & Replace" } },
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
    opts = { picker = "snacks" },
  },
  {
    "v1nh1shungry/lyricify.nvim",
    -- TODO: use `main` branch after the branch is stable and merged
    branch = "feature/playerctl",
    config = function()
      Snacks.toggle({
        name = "lyricify",
        get = function()
          return require("lyricify").enabled
        end,
        set = function()
          vim.cmd("Lyricify toggle")
        end,
      }):map("<Leader>us")
    end,
    event = "VeryLazy",
  },
}
