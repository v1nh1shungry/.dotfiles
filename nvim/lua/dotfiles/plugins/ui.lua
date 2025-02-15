return {
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = Dotfiles.events.enter_buffer,
    keys = {
      { "<Leader>xt", "<Cmd>TodoQuickFix<CR>", desc = "Todo" },
      {
        "<leader>st",
        function()
          Snacks.picker.todo_comments()
        end,
        desc = "Todo",
      },
    },
    opts = { signs = false },
  },
  {
    "akinsho/bufferline.nvim",
    config = function()
      require("bufferline").setup({
        options = {
          close_command = function(b)
            Snacks.bufdelete(b)
          end,
          right_mouse_command = function(b)
            Snacks.bufdelete(b)
          end,
          numbers = "ordinal",
          diagnostics = "nvim_lsp",
          themable = true,
        },
      })
      -- https://www.lazyvim.org/plugins/ui#bufferlinenvim {{{
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
        group = Dotfiles.augroup("bufferline"),
      })
      -- }}}
    end,
    event = "VeryLazy",
    keys = {
      {
        "]b",
        function()
          for _ = 1, vim.v.count1 do
            vim.cmd("BufferLineCycleNext")
          end
        end,
        desc = "Goto Next Buffer",
      },
      {
        "[b",
        function()
          for _ = 1, vim.v.count1 do
            vim.cmd("BufferLineCyclePrev")
          end
        end,
        desc = "Goto Previous Buffer",
      },
      { "[B", "<Cmd>BufferLineGoToBuffer 1<CR>", desc = "Goto First Buffer" },
      { "]B", "<Cmd>BufferLineGoToBuffer -1<CR>", desc = "Goto Last Buffer" },
      { "gb", "<Cmd>execute 'BufferLineGoToBuffer ' .. v:count1<CR>", desc = "Goto Buffer" },
      { "gB", "<Cmd>BufferLinePick<CR>", desc = "Pick Buffer" },
      { "<Leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Only" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine_require").require = require

      -- https://github.com/chrisgrieser/nvim-tinygit/blob/main/lua/tinygit/statusline/branch-state.lua {{{
      local function git_branch_state()
        local cwd = vim.fn.getcwd()
        if not cwd then
          return ""
        end

        local allBranchInfo = vim.system({ "git", "-C", cwd, "branch", "--verbose" }):wait()
        if allBranchInfo.code ~= 0 then
          return ""
        end

        local branches = vim.split(allBranchInfo.stdout, "\n")
        local currentBranchInfo

        for _, line in pairs(branches) do
          currentBranchInfo = line:match("^%* .*")
          if currentBranchInfo then
            break
          end
        end

        if not currentBranchInfo then
          return ""
        end

        local ahead = currentBranchInfo:match("ahead (%d+)")
        local behind = currentBranchInfo:match("behind (%d+)")

        if ahead and behind then
          return ("󰃻" .. " %s/%s"):format(ahead, behind)
        elseif ahead then
          return "󰶣" .. ahead
        elseif behind then
          return "󰶡" .. behind
        end

        return ""
      end

      local function refresh_branch_state()
        vim.b.dotfiles_git_branch_state = git_branch_state()
      end

      vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged", "FocusGained" }, {
        callback = refresh_branch_state,
        group = Dotfiles.augroup("lualine_git_branch_state"),
      })

      refresh_branch_state()
      -- }}}

      require("lualine").setup({
        options = {
          globalstatus = true,
          component_separators = "",
          section_separators = "",
        },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {
            { "branch", icon = "" },
            {
              function()
                return vim.b.dotfiles_git_branch_state or ""
              end,
            },
            {
              "diagnostics",
              colored = false,
              always_visible = true,
            },
            {
              "mode",
              fmt = function(str)
                return "-- " .. str .. " --"
              end,
            },
          },
          lualine_x = {
            {
              function()
                return "%S"
              end,
            },
            {
              function()
                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                return string.format("Ln %s,Col %s", row, col + 1)
              end,
            },
            {
              function()
                return "Spaces: " .. (vim.bo.expandtab and vim.bo.shiftwidth or vim.bo.softtabstop)
              end,
            },
            {
              "encoding",
              fmt = function(str)
                return string.upper(str)
              end,
            },
            {
              "fileformat",
              icons_enabled = true,
              symbols = { unix = "LF", dos = "CRLF", mac = "CR" },
            },
            { "filetype", icons_enabled = false },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {},
          lualine_x = {},
        },
        extensions = {
          "fugitive",
          "lazy",
          "man",
          "mason",
          "nvim-dap-ui",
          "quickfix",
        },
      })
    end,
    event = "VeryLazy",
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<C-w><Space>",
        function()
          require("which-key").show({ keys = "<C-w>", loop = true })
        end,
        desc = "Window Hydra Mode (which-key)",
      },
    },
    opts = {
      preset = "helix",
      spec = {
        {
          mode = { "n", "v" },
          { "g", group = "goto" },
          { "s", group = "surround" },
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
    event = "VeryLazy",
    config = function(_, opts)
      -- {{{ https://www.lazyvim.org/plugins/ui#noicenvim
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd("messages clear")
      end
      -- }}}
      require("noice").setup(opts)
    end,
    keys = {
      { "<Leader>xn", "<Cmd>NoiceAll<CR>", desc = "Message" },
      {
        "<C-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<C-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Forward",
        mode = { "i", "n", "s" },
      },
      {
        "<C-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<C-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Backward",
        mode = { "i", "n", "s" },
      },
    },
    opts = {
      views = { split = { enter = true } },
      presets = {
        long_message_to_split = true,
        bottom_search = true,
        command_palette = true,
      },
      messages = { view_search = false },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
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
    "kevinhwang91/nvim-hlslens",
    keys = {
      { "/", desc = "Forward Search" },
      { "?", desc = "Backward Search" },
      {
        "n",
        function()
          vim.cmd("execute('normal! ' . v:count1 . 'Nn'[v:searchforward] . 'zv')")
          require("hlslens").start()
        end,
        desc = "Next Search",
      },
      {
        "n",
        function()
          vim.cmd("execute('normal! ' . v:count1 . 'Nn'[v:searchforward])")
          require("hlslens").start()
        end,
        mode = { "x", "o" },
        desc = "Next Search",
      },
      {
        "N",
        function()
          vim.cmd("execute('normal! ' . v:count1 . 'nN'[v:searchforward] . 'zv')")
          require("hlslens").start()
        end,
        desc = "Previous Search",
      },
      {
        "N",
        function()
          vim.cmd("execute('normal! ' . v:count1 . 'nN'[v:searchforward])")
          require("hlslens").start()
        end,
        mode = { "x", "o" },
        desc = "Previous Search",
      },
      { "*", [[*<Cmd>lua require('hlslens').start()<CR>]], desc = "Forward Search Current Word" },
      { "#", [[#<Cmd>lua require('hlslens').start()<CR>]], desc = "Backward Search Current Word" },
    },
    opts = { calm_down = true },
  },
  {
    "Bekaboo/deadcolumn.nvim",
    event = Dotfiles.events.enter_buffer,
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
      left = {
        {
          ft = "dbui",
          title = "DBUI",
        },
      },
      bottom = {
        {
          ft = "noice",
          size = { height = 0.4 },
          filter = function(_, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
        {
          ft = "qf",
          title = "Quickfix List",
        },
        {
          ft = "help",
          size = { height = 0.4 },
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
        {
          ft = "markdown",
          size = { height = 0.4 },
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
        { ft = "man", size = { height = 0.4 } },
        {
          ft = "snacks_terminal",
          size = { height = 0.4 },
          title = "%{b:snacks_terminal.id}: %{b:term_title}",
          filter = function(_, win)
            return vim.w[win].snacks_win
              and vim.w[win].snacks_win.position == "bottom"
              and vim.w[win].snacks_win.relative == "editor"
          end,
        },
        {
          ft = "dbout",
          title = "DB Query Result",
        },
      },
      right = {
        {
          title = "Treesitter",
          ft = "query",
          filter = function(buf, _)
            return vim.bo[buf].buftype == "nofile"
          end,
          size = { width = 0.4 },
          wo = { number = false, relativenumber = false, stc = "" },
        },
        {
          ft = "Outline",
          size = { width = 0.3 },
        },
        {
          title = "Grug Far",
          ft = "grug-far",
          size = { width = 0.4 },
        },
        {
          ft = "ClangdAST",
          size = { width = 0.4 },
        },
        {
          ft = "rest_nvim_result",
          size = { width = 0.5 },
          wo = { winbar = false },
        },
      },
    },
    specs = {
      "akinsho/bufferline.nvim",
      opts = function()
        local Offset = require("bufferline.offset")
        if not Offset.edgy then
          local get = Offset.get
          Offset.get = function()
            if package.loaded.edgy then
              local layout = require("edgy.config").layout
              local ret = { left = "", left_size = 0, right = "", right_size = 0 }
              for _, pos in ipairs({ "left", "right" }) do
                local sb = layout[pos]
                if sb and #sb.wins > 0 then
                  local blank = (sb.bounds.width - 7) / 2
                  local title = string.rep(" ", blank) .. "Sidebar" .. string.rep(" ", blank)
                  ret[pos] = "%#EdgyTitle#" .. title .. "%*" .. "%#WinSeparator#│%*"
                  ret[pos .. "_size"] = sb.bounds.width
                end
              end
              ret.total_size = ret.left_size + ret.right_size
              if ret.total_size > 0 then
                return ret
              end
            end
            return get()
          end
          Offset.edgy = true
        end
      end,
    },
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
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
    ft = { "markdown" },
    keys = { { "<Leader>uc", "<Cmd>RenderMarkdown buf_toggle<CR>", desc = "Toggle Render Markdown", ft = "markdown" } },
    opts = {
      code = { sign = false, width = "block", right_pad = 1 },
      heading = { sign = false, icons = {} },
      checkbox = { enabled = false },
      file_types = { "markdown" },
    },
    opts_extend = { "file_types" },
    specs = {
      {
        "saghen/blink.cmp",
        opts = {
          sources = {
            per_filetype = { markdown = { "markdown" } },
            providers = {
              markdown = {
                name = "RenderMarkdown",
                module = "render-markdown.integ.blink",
              },
            },
          },
        },
      },
    },
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
          function()
            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
          end,
          desc = "Expand Context",
        },
        {
          "<",
          function()
            require("quicker").collapse()
          end,
          desc = "Collapse Context",
        },
        {
          "<Leader>xq",
          function()
            require("quicker").toggle()
          end,
          desc = "Toggle Quickfix List",
        },
        {
          "<Leader>xl",
          function()
            require("quicker").toggle({ loclist = true })
          end,
          desc = "Toggle Location List",
        },
      },
    },
  },
  {
    "tiagovla/scope.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.files",
    config = function()
      local show_hidden = false

      local NS = Dotfiles.ns("mini_files_extmarks")
      local AUGROUP = Dotfiles.augroup("mini_files")

      ---@type string[]
      local IGNORED_PATTERN = {
        ".cache",
        ".git",
        "build",
        "node_modules",
      }
      ---@type table<string, boolean>
      local ignored = {}

      local function filter_show(_)
        return true
      end

      local function update_ignored(path)
        local items = {}

        for name, _ in vim.fs.dir(path) do
          if vim.list_contains(IGNORED_PATTERN, name) then
            ignored[vim.fs.joinpath(path, name)] = true
          else
            ignored[vim.fs.joinpath(path, name)] = false
            table.insert(items, name)
          end
        end

        if not Dotfiles.git_root() then
          return
        end

        local ret = vim.fn.system(vim.list_extend({ "git", "-C", path, "check-ignore" }, items))
        for _, name in ipairs(vim.split(ret, "\n", { trimempty = true })) do
          ignored[vim.fs.joinpath(path, name)] = true
        end
      end

      local function filter_hide(fs_entry)
        local parent = vim.fs.dirname(fs_entry.path)
        if ignored[parent] then
          return false
        end

        if ignored[fs_entry.path] == nil then
          update_ignored(parent)
        end

        return not ignored[fs_entry.path]
      end

      vim.api.nvim_create_autocmd("User", {
        callback = function(event)
          Dotfiles.map({
            "g.",
            function()
              show_hidden = not show_hidden
              Snacks.notify.info((show_hidden and "Show" or "Hide") .. " hidden files")
              require("mini.files").refresh({ content = { filter = show_hidden and filter_show or filter_hide } })
            end,
            buffer = event.data.buf_id,
            desc = "Toggle Hidden Files",
          })
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
            local entry = require("mini.files").get_fs_entry(args.data.buf_id, i)
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
          filter = function(fs_entry)
            return show_hidden and filter_show(fs_entry) or filter_hide(fs_entry)
          end,
        },
      })
    end,
    dependencies = "echasnovski/mini.icons",
    lazy = not (vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1),
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
    -- NOTE: current HEAD will highlight all changes, very noisy
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
    "lewis6991/satellite.nvim",
    event = Dotfiles.events.enter_buffer,
  },
  {
    "Bekaboo/dropbar.nvim",
    event = Dotfiles.events.enter_buffer,
  },
  {
    "fei6409/log-highlight.nvim",
    event = "BufRead *.log",
    opts = {},
  },
  {
    "v1nh1shungry/error-lens.nvim",
    event = Dotfiles.events.enter_buffer,
  },
}
