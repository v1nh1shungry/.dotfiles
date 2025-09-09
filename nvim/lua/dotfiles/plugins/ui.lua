return {
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "LazyFile",
    keys = {
      { "<Leader>xt", "<Cmd>TodoQuickFix keywords=TODO,FIXME<CR>", desc = "Todo" },
      { "<Leader>xT", "<Cmd>TodoQuickFix<CR>", desc = "Todo & Note" },
      {
        "<Leader>st",
        function() require("todo-comments.fzf").todo({ keywords = { "TODO", "FIXME" } }) end,
        desc = "Todo",
      },
      { "<Leader>sT", function() require("todo-comments.fzf").todo() end, desc = "Todo & Note" },
    },
    opts = { signs = false },
  },
  {
    "nvim-mini/mini.tabline",
    dependencies = "nvim-mini/mini.icons",
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvim-mini/mini.statusline",
    dependencies = "nvim-mini/mini.icons",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      icons = { mappings = false },
      preset = "helix",
      spec = {
        {
          mode = { "n", "x" },
          { "g", group = "goto" },
          { "]", group = "next" },
          { "[", group = "prev" },
          { "z", group = "fold" },
          { "<Space>", group = "leader" },
          { "<Leader><Tab>", group = "tab" },
          { "<Leader>b", group = "buffer" },
          { "<Leader>c", group = "code" },
          { "<Leader>f", group = "file" },
          { "<Leader>g", group = "git" },
          { "<Leader>gx", group = "conflict" },
          { "<Leader>p", group = "package" },
          { "<Leader>q", group = "quit" },
          { "<Leader>s", group = "search" },
          { "<Leader>u", group = "ui" },
          { "<Leader>x", group = "quickfix" },
        },
      },
    },
    opts_extend = { "spec" },
  },
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
  {
    "folke/noice.nvim",
    -- https://github.com/LazyVim/LazyVim {{{
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      --       but this is not ideal when Lazy is installing
      --       plugins, so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end

      require("noice").setup(opts)
    end,
    -- }}}
    event = "VeryLazy",
    keys = { { "<Leader>xn", "<Cmd>NoiceAll<CR>", desc = "Message" } },
    opts = {
      lsp = {
        hover = { enabled = false },
        signature = { enabled = false },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
      routes = {
        {
          filter = {
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
            event = "msg_show",
          },
          view = "mini",
        },
      },
      views = { split = { enter = true } },
    },
  },
  {
    "Bekaboo/deadcolumn.nvim",
    event = "VeryLazy", -- NOTE: Otherwise nofile brokes.
  },
  {
    "nvim-mini/mini.icons",
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
    lazy = true,
    opts = {},
  },
  {
    "mcauley-penney/visual-whitespace.nvim",
    event = "ModeChanged *:[vV\x16]*",
    opts = {},
  },
  {
    "kevinhwang91/nvim-bqf",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = "qf",
  },
  {
    "stevearc/quicker.nvim",
    event = "VeryLazy", -- NOTE: Doesn't work for loclist if `ft = "qf"`.
    keys = {
      { "<Leader>xq", function() require("quicker").toggle() end, desc = "Toggle Quickfix List" },
      { "<Leader>xl", function() require("quicker").toggle({ loclist = true }) end, desc = "Toggle Location List" },
    },
    opts = {
      keys = {
        {
          ">",
          function() require("quicker").expand({ before = 2, after = 2, add_to_existing = true }) end,
          desc = "Expand Context",
        },
        { "<", function() require("quicker").collapse() end, desc = "Collapse Context" },
        { "q", "<Cmd>close<CR>", desc = ":close" },
      },
    },
  },
  {
    "nvim-mini/mini.files",
    config = function()
      -- Modified from https://github.com/stevearc/oil.nvim/blob/master/doc/recipes.md#hide-gitignored-files-and-show-git-tracked-hidden-files {{{
      local function new_git_ignored()
        return setmetatable({}, {
          __index = function(self, key)
            local obj = vim
              .system(
                { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
                { cwd = key, text = true }
              )
              :wait()

            local ret = {}

            if obj.code == 0 then
              for line in vim.gsplit(obj.stdout, "\n", { plain = true, trimempty = true }) do
                ret[line:gsub("/$", "")] = true
              end
            end

            rawset(self, key, ret)
            return ret
          end,
        })
      end
      -- }}}

      local show_hidden = false
      local git_ignored = new_git_ignored()

      local NS = Dotfiles.ns("mini.files.extmarks")
      local AUGROUP = Dotfiles.augroup("mini.files")

      local IGNORED_PATTERN = { ---@type string[]
        ".cache",
        ".git",
        "build",
        "node_modules",
      }

      ---@return boolean
      local function filter_show(_) return true end

      ---@return boolean
      local function filter_hide(fs_entry)
        if vim.list_contains(IGNORED_PATTERN, fs_entry.name) then
          return false
        end

        local dir = vim.fs.dirname(fs_entry.path)
        return not git_ignored[dir][fs_entry.name]
      end

      vim.api.nvim_create_autocmd("User", {
        callback = function(args)
          Snacks.toggle({
            name = "Hidden Files",
            get = function() return show_hidden end,
            set = function()
              show_hidden = not show_hidden
              MiniFiles.refresh({ content = { filter = show_hidden and filter_show or filter_hide } })
            end,
          }):map("g.", { buffer = args.data.buf_id })
        end,
        desc = "Setup keymappings for mini.files",
        group = AUGROUP,
        pattern = "MiniFilesBufferCreate",
      })

      vim.api.nvim_create_autocmd("User", {
        callback = function(args)
          vim.api.nvim_buf_clear_namespace(args.data.buf_id, NS, 0, -1)

          if not show_hidden then
            return
          end

          for i = 1, vim.api.nvim_buf_line_count(args.data.buf_id) do
            local entry = MiniFiles.get_fs_entry(args.data.buf_id, i)
            if entry and not filter_hide(entry) then
              vim.api.nvim_buf_set_extmark(args.data.buf_id, NS, i - 1, 0, {
                line_hl_group = "DiagnosticUnnecessary",
              })
            end
          end
        end,
        desc = "Render ignored files for mini.files",
        group = AUGROUP,
        pattern = "MiniFilesBufferUpdate",
      })

      vim.api.nvim_create_autocmd("User", {
        callback = function() git_ignored = new_git_ignored() end,
        desc = "Refresh Git status",
        group = AUGROUP,
        pattern = "MiniFilesExplorerOpen",
      })

      require("mini.files").setup({
        content = {
          filter = function(fs_entry) return show_hidden and filter_show(fs_entry) or filter_hide(fs_entry) end,
        },
      })
    end,
    dependencies = "nvim-mini/mini.icons",
    lazy = not (
        vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0) --[[@as string]]) == 1
      ),
    keys = {
      {
        "<Leader>e",
        function()
          if not MiniFiles.close() then
            MiniFiles.open()
          end
        end,
        desc = "Explorer",
      },
    },
  },
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
  {
    "Bekaboo/dropbar.nvim",
    event = "LazyFile",
  },
  {
    "fei6409/log-highlight.nvim",
    event = "BufRead *.log",
    opts = {},
  },
  {
    "nvim-mini/mini.trailspace",
    event = "LazyFile",
    keys = { { "d<Space>", function() require("mini.trailspace").trim() end, desc = "Trim Trailing Space" } },
    opts = {},
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        include = {
          node_type = {
            lua = { "table_constructor" },
          },
        },
        show_start = false,
        show_end = false,
      },
    },
  },
}
