return {
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "LazyFile",
    keys = {
      { "<Leader>xt", "<Cmd>TodoQuickFix keywords=TODO,FIXME<CR>", desc = "Todo" },
      { "<Leader>xT", "<Cmd>TodoQuickFix<CR>", desc = "Todo & Note" },
      ---@diagnostic disable-next-line: undefined-field
      { "<Leader>st", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIXME" } }) end, desc = "Todo" },
      ---@diagnostic disable-next-line: undefined-field
      { "<Leader>sT", function() Snacks.picker.todo_comments() end, desc = "Todo & Note" },
    },
    opts = { signs = false },
  },
  {
    "echasnovski/mini.tabline",
    dependencies = "echasnovski/mini.icons",
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.statusline",
    dependencies = "echasnovski/mini.icons",
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
          mode = { "n", "v" },
          { "g", group = "goto" },
          { "gs", group = "surround" },
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
          { "<Leader>p", group = "package/profile" },
          { "<Leader>pn", group = "nightly" },
          { "<Leader>q", group = "quit" },
          { "<Leader>s", group = "search" },
          { "<Leader>u", group = "ui/utils" },
          { "<Leader>x", group = "diagnostic/quickfix" },
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
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end

      require("noice").setup(opts)
    end,
    -- }}}
    event = "VeryLazy",
    keys = { { "<Leader>xn", "<Cmd>NoiceAll<CR>", desc = "Message" } },
    opts = {
      views = { split = { enter = true } },
      presets = { long_message_to_split = true, bottom_search = true, command_palette = true },
      lsp = {
        hover = { enabled = false },
        signature = { enabled = false },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
    },
  },
  {
    "Bekaboo/deadcolumn.nvim",
    event = "LazyFile",
  },
  {
    "echasnovski/mini.icons",
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
    -- NOTE: loclist doesn't work in `ft = "qf"`
    event = "VeryLazy",
    opts = {
      keys = {
        {
          ">",
          function() require("quicker").expand({ before = 2, after = 2, add_to_existing = true }) end,
          desc = "Expand Context",
        },
        { "<", function() require("quicker").collapse() end, desc = "Collapse Context" },
        { "<Leader>xq", function() require("quicker").toggle() end, desc = "Toggle Quickfix List" },
        { "<Leader>xl", function() require("quicker").toggle({ loclist = true }) end, desc = "Toggle Location List" },
      },
    },
  },
  {
    "echasnovski/mini.files",
    config = function()
      local show_hidden = false
      local ignored = {} ---@type table<string, boolean>

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
        local dir = vim.fs.dirname(fs_entry.path)
        if ignored[dir] then
          return false
        end

        if ignored[fs_entry.path] == nil then
          local entries = {} ---@type string[]

          for name, _ in vim.fs.dir(dir) do
            local path = vim.fs.joinpath(dir, name)
            if vim.list_contains(IGNORED_PATTERN, name) then
              ignored[path] = true
            else
              ignored[path] = false
              table.insert(entries, name)
            end
          end

          if Dotfiles.git.root() then
            local ret = vim.fn.system(vim.list_extend({ "git", "-C", dir, "check-ignore" }, entries))
            for name in vim.gsplit(ret, "\n", { trimempty = true }) do
              ignored[vim.fs.joinpath(dir, name)] = true
            end
          end
        end

        return not ignored[fs_entry.path]
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
        group = AUGROUP,
        pattern = "MiniFilesBufferUpdate",
      })

      require("mini.files").setup({
        content = {
          filter = function(fs_entry) return show_hidden and filter_show(fs_entry) or filter_hide(fs_entry) end,
        },
      })
    end,
    dependencies = "echasnovski/mini.icons",
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
    "tzachar/highlight-undo.nvim",
    commit = "795fc36f8bb7e4cf05e31bd7e354b86d27643a9e",
    keys = {
      { "u", desc = "Undo" },
      { "<C-r>", desc = "Redo" },
      { "p", desc = "Paste" },
      { "P", desc = "Paste Before" },
    },
    opts = {
      keymaps = {
        undo = { hlgroup = "IncSearch" },
        redo = { hlgroup = "IncSearch" },
        paste = { hlgroup = "IncSearch" },
      },
    },
    pin = true,
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
    "echasnovski/mini.trailspace",
    event = "LazyFile",
    opts = {},
  },
}
