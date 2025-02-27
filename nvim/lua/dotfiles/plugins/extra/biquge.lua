vim.api.nvim_set_hl(0, "BiqugeDocument", {
  link = "Comment",
  italic = false,
})

---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "v1nh1shungry/biquge.nvim",
    dependencies = "folke/snacks.nvim",
    keys = {
      { "<Leader>n", "", desc = "+novel" },
      {
        "<Leader>n/",
        function()
          require("biquge").search()
        end,
        desc = "Search",
      },
      {
        "<Leader>nn",
        function()
          require("biquge").toggle()
        end,
        desc = "Toggle",
      },
      {
        "<Leader>nt",
        function()
          require("biquge").toc()
        end,
        desc = "Toc",
      },
      {
        "]n",
        function()
          require("biquge").next_chap()
        end,
        desc = "Next Chapter",
      },
      {
        "[n",
        function()
          require("biquge").prev_chap()
        end,
        desc = "Previous Chapter",
      },
      {
        "<Leader>ns",
        function()
          require("biquge").star()
        end,
        desc = "Star",
      },
      {
        "<Leader>nl",
        function()
          require("biquge").bookshelf()
        end,
        desc = "Bookshelf",
      },
      {
        "<M-d>",
        function()
          require("biquge").scroll(2)
        end,
        desc = "Scroll Down",
      },
      {
        "<M-u>",
        function()
          require("biquge").scroll(-2)
        end,
        desc = "Scroll Up",
      },
    },
    opts = {
      hlgroup = "BiqugeDocument",
      height = 5,
      picker = "snacks",
    },
  },
}
