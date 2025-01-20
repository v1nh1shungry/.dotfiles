return {
  {
    "v1nh1shungry/biquge.nvim",
    init = function()
      vim.api.nvim_create_autocmd("User", {
        callback = function()
          Snacks.util.on_module("which-key", function()
            require("which-key").add({ "<Leader>b", group = "biquge" })
          end)
        end,
        group = Dotfiles.augroup("biquge_which_key"),
        pattern = "VeryLazy",
      })

      vim.api.nvim_set_hl(0, "BiqugeDocument", { link = "Comment", italic = false })
    end,
    keys = {
      {
        "<Leader>b/",
        function()
          require("biquge").search()
        end,
        desc = "Search",
      },
      {
        "<Leader>bb",
        function()
          require("biquge").toggle()
        end,
        desc = "Toggle",
      },
      {
        "<Leader>bt",
        function()
          require("biquge").toc()
        end,
        desc = "Toc",
      },
      {
        "<Leader>bn",
        function()
          require("biquge").next_chap()
        end,
        desc = "Next chapter",
      },
      {
        "<Leader>bp",
        function()
          require("biquge").prev_chap()
        end,
        desc = "Previous chapter",
      },
      {
        "<Leader>bs",
        function()
          require("biquge").star()
        end,
        desc = "Star current book",
      },
      {
        "<Leader>bl",
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
        desc = "Scroll down",
      },
      {
        "<M-u>",
        function()
          require("biquge").scroll(-2)
        end,
        desc = "Scroll up",
      },
    },
    opts = {
      hlgroup = "BiqugeDocument",
      height = 5,
      picker = "snacks",
    },
  },
}
