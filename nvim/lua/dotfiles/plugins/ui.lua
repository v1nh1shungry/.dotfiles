local events = require("dotfiles.utils.events")
local map = require("dotfiles.utils.keymap")
local ui = require("dotfiles.utils.ui")

return {
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = events.enter_buffer,
    keys = {
      {
        "[t",
        function() require("todo-comments").jump_prev() end,
        desc = "Jump to the previous TODO",
      },
      {
        "]t",
        function() require("todo-comments").jump_next() end,
        desc = "Jump to the next TODO",
      },
      { "<Leader>xt", "<Cmd>TodoQuickFix<CR>", desc = "Todo" },
      { "<Leader>xT", "<Cmd>TodoQuickFix keywords=TODO,FIX,FIXME<CR>", desc = "Todo/Fix/Fixme" },
      { "<Leader>st", "<Cmd>TodoTelescope<CR>", desc = "Todo" },
      { "<Leader>sT", "<Cmd>TodoTelescope keywords=TODO,FIX,FIXME<CR>", desc = "Todo/Fix/Fixme" },
    },
    opts = { signs = false },
  },
  -- https://www.lazyvim.org/extras/ui/alpha {{{
  {
    "goolord/alpha-nvim",
    config = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
 __    __ __     __ ______ __       __      __    __ ________ _______   ______
|  \  |  \  \   |  \      \  \     /  \    |  \  |  \        \       \ /      \
| ▓▓\ | ▓▓ ▓▓   | ▓▓\▓▓▓▓▓▓ ▓▓\   /  ▓▓    | ▓▓  | ▓▓ ▓▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\
| ▓▓▓\| ▓▓ ▓▓   | ▓▓ | ▓▓ | ▓▓▓\ /  ▓▓▓    | ▓▓__| ▓▓ ▓▓__   | ▓▓__| ▓▓ ▓▓  | ▓▓
| ▓▓▓▓\ ▓▓\▓▓\ /  ▓▓ | ▓▓ | ▓▓▓▓\  ▓▓▓▓    | ▓▓    ▓▓ ▓▓  \  | ▓▓    ▓▓ ▓▓  | ▓▓
| ▓▓\▓▓ ▓▓ \▓▓\  ▓▓  | ▓▓ | ▓▓\▓▓ ▓▓ ▓▓    | ▓▓▓▓▓▓▓▓ ▓▓▓▓▓  | ▓▓▓▓▓▓▓\ ▓▓  | ▓▓
| ▓▓ \▓▓▓▓  \▓▓ ▓▓  _| ▓▓_| ▓▓ \▓▓▓| ▓▓    | ▓▓  | ▓▓ ▓▓_____| ▓▓  | ▓▓ ▓▓__/ ▓▓
| ▓▓  \▓▓▓   \▓▓▓  |   ▓▓ \ ▓▓  \▓ | ▓▓    | ▓▓  | ▓▓ ▓▓     \ ▓▓  | ▓▓\▓▓    ▓▓
 \▓▓   \▓▓    \▓    \▓▓▓▓▓▓\▓▓      \▓▓     \▓▓   \▓▓\▓▓▓▓▓▓▓▓\▓▓   \▓▓ \▓▓▓▓▓▓
]]
      dashboard.section.header.val = vim.split(logo, "\n", { trimempty = true })
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", "<Cmd>Telescope find_files<CR>"),
        dashboard.button("r", " " .. " Recent files", "<Cmd>Telescope oldfiles cwd_only=true<CR>"),
        dashboard.button("/", " " .. " Find text", "<Cmd>Telescope live_grep<CR>"),
        dashboard.button("c", " " .. " Config", "<Cmd>e ~/.nvimrc<CR>"),
        dashboard.button("s", " " .. " Restore session", "<Cmd>SessionLoad<CR>"),
        dashboard.button("l", "󰒲 " .. " Lazy", "<Cmd>Lazy<CR>"),
        dashboard.button("q", " " .. " Quit", "<Cmd>qa<CR>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.opts.layout[1].val = math.max(
        0,
        math.floor(
          (
            vim.o.lines
            - #dashboard.section.header.val -- header
            - dashboard.opts.layout[3].val -- padding between header and buttons
            - #dashboard.section.buttons.val * 2 -- buttons
            - 1 -- rooter
          ) / 2
        )
      )
      require("alpha").setup(dashboard.opts)

      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          once = true,
          pattern = "AlphaReady",
          callback = function() require("lazy").show() end,
        })
      end
      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
  -- }}}
  {
    "akinsho/bufferline.nvim",
    config = function()
      require("bufferline").setup({
        options = {
          close_command = function(b) require("mini.bufremove").delete(b) end,
          right_mouse_command = function(b) require("mini.bufremove").delete(b) end,
          numbers = "ordinal",
          diagnostics = "nvim_lsp",
          themable = true,
        },
      })
      -- https://www.lazyvim.org/plugins/ui#bufferlinenvim {{{
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function() pcall(nvim_bufferline) end)
        end,
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
        desc = "Jump to the next buffer",
      },
      {
        "[b",
        function()
          for _ = 1, vim.v.count1 do
            vim.cmd("BufferLineCyclePrev")
          end
        end,
        desc = "Jump to the previous buffer",
      },
      { "[B", function() require("bufferline").go_to(1, true) end, desc = "Jump to the first buffer" },
      { "]B", function() require("bufferline").go_to(-1, true) end, desc = "Jump to the last buffer" },
      { "gb", "<Cmd>BufferLinePick<CR>", desc = "Pick buffer" },
    },
  },
  {
    "stevearc/dressing.nvim",
    -- https://www.lazyvim.org/extras/editor/telescope#dressingnvim {{{
    init = function()
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
    -- }}}
    lazy = true,
    opts = {
      input = { relative = "editor" },
      select = {
        telescope = {
          layout_strategy = "bottom_pane",
          sorting_strategy = "ascending",
          layout_config = {
            bottom_pane = {
              height = 0.4,
            },
          },
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine_require").require = require

      vim.opt.laststatus = 3

      local function is_cmake_project()
        return package.loaded["cmake-tools"] and require("cmake-tools").is_cmake_project()
      end

      -- https://github.com/chrisgrieser/nvim-tinygit/blob/main/lua/tinygit/statusline/branch-state.lua {{{
      local function get_git_branch_state()
        local cwd = vim.uv.cwd()
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

      local function refresh_git_branch_state() vim.b.dotfiles_git_branch_state = get_git_branch_state() end

      vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged", "FocusGained" }, {
        callback = refresh_git_branch_state,
        group = vim.api.nvim_create_augroup("dotfiles_lualine_git_branch_state", {}),
      })

      refresh_git_branch_state()
      -- }}}

      require("lualine").setup({
        options = { component_separators = "", section_separators = "" },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {
            { "branch", icon = "" },
            { function() return vim.b.dotfiles_git_branch_state or "" end },
            {
              "diagnostics",
              sections = { "error", "warn", "info" },
              colored = false,
              always_visible = true,
            },
            {
              function() return "CMake: [" .. (require("cmake-tools").get_configure_preset() or "X") .. "]" end,
              cond = function() return is_cmake_project() and require("cmake-tools").has_cmake_preset() end,
            },
            {
              function() return "CMake: [" .. (require("cmake-tools").get_build_type() or "X") .. "]" end,
              cond = function() return is_cmake_project() and not require("cmake-tools").has_cmake_preset() end,
            },
            {
              function() return "[" .. (require("cmake-tools").get_kit() or "X") .. "]" end,
              cond = function() return is_cmake_project() and require("cmake-tools").has_cmake_preset() end,
              icon = "󱌣",
            },
            {
              function() return "[" .. (require("cmake-tools").get_build_preset() or "X") .. "]" end,
              cond = function() return is_cmake_project() and require("cmake-tools").has_cmake_preset() end,
            },
            {
              function() return "[" .. (require("cmake-tools").get_build_target() or "X") .. "]" end,
              cond = is_cmake_project,
              icon = "",
            },
            {
              function() return "[" .. (require("cmake-tools").get_launch_target() or "X") .. "]" end,
              cond = is_cmake_project,
              icon = "",
            },
            {
              "mode",
              fmt = function(str) return "-- " .. str .. " --" end,
            },
          },
          lualine_x = {
            { function() return "%S" end },
            {
              function()
                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                return string.format("Ln %s,Col %s", row, col + 1)
              end,
            },
            {
              function()
                if vim.bo.shiftwidth == 0 then
                  return "Tab: " .. vim.bo.tabstop
                else
                  return "Spaces: " .. vim.bo.shiftwidth
                end
              end,
            },
            {
              "encoding",
              fmt = function(str) return string.upper(str) end,
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
          "lazy",
          "man",
          "mason",
          "nvim-dap-ui",
          "quickfix",
          "toggleterm",
        },
      })
    end,
    event = "VeryLazy",
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = events.enter_buffer,
    opts = { max_lines = 4, multiline_threshold = 1 },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        {
          mode = { "n", "v" },
          { "g", group = "goto" },
          { "]", group = "next" },
          { "[", group = "prev" },
          { "z", group = "fold" },
          { "<Space>", group = "leader" },
          { "<Leader><Tab>", group = "tab" },
          { "<Leader>c", group = "code" },
          { "<Leader>cc", group = "text-case" },
          { "<Leader>d", group = "debug" },
          { "<Leader>dp", group = "print" },
          { "<Leader>f", group = "file" },
          { "<Leader>g", group = "git" },
          { "<Leader>gx", group = "conflict" },
          { "<Leader>m", group = "cmake" },
          { "<Leader>p", group = "package" },
          { "<Leader>q", group = "quit/sessions" },
          { "<Leader>s", group = "search" },
          { "<Leader>u", group = "ui/utils" },
          { "<Leader>x", group = "diagnostic/quickfix" },
        },
      },
    },
  },
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = {
      timeout = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
      on_open = function(win) vim.api.nvim_win_set_config(win, { zindex = 100 }) end,
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      -- {{{ https://www.lazyvim.org/plugins/ui#noicenvim
      if vim.o.filetype == "lazy" then
        vim.cmd("messages clear")
      end
      -- }}}
      require("noice").setup(opts)
    end,
    keys = {
      { "<Leader>xn", "<Cmd>NoiceAll<CR>", desc = "Message" },
      { "<Leader>un", "<Cmd>Noice dismiss<CR>", desc = "Dismiss all notifications" },
      {
        "<C-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return vim.fn.mode() == "i" and "<Right>" or "<C-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
        mode = { "i", "n", "s" },
      },
      {
        "<C-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return vim.fn.mode() == "i" and "<Left>" or "<C-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = { "i", "n", "s" },
      },
    },
    opts = {
      views = { split = { enter = true } },
      presets = {
        long_message_to_split = true,
        bottom_search = true,
        command_palette = true,
        lsp_doc_border = true,
      },
      messages = { view_search = false },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      markdown = { hover = { ["%[.-%]%((%S-)%)"] = vim.ui.open } },
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
    "luukvbaal/statuscol.nvim",
    branch = "0.10",
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        bt_ignore = ui.excluded_buftypes,
        relculright = true,
        segments = {
          { sign = { name = { "Dap" } }, click = "v:lua.ScSa" },
          { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
          { sign = { namespace = { "gitsigns" } }, click = "v:lua.ScSa" },
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
        },
      })
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    keys = {
      { "/", desc = "Forward search" },
      { "?", desc = "Backward search" },
      { "<C-n>", mode = { "n", "v" }, desc = "Multi cursors" },
      {
        "n",
        [[<Cmd>execute('normal! ' . v:count1 . 'Nn'[v:searchforward])<CR><Cmd>lua require('hlslens').start()<CR>]],
        desc = "Next search result",
      },
      {
        "N",
        [[<Cmd>execute('normal! ' . v:count1 . 'nN'[v:searchforward])<CR><Cmd>lua require('hlslens').start()<CR>]],
        desc = "Previous search result",
      },
      { "*", [[*<Cmd>lua require('hlslens').start()<CR>]], desc = "Forward search current word" },
      { "#", [[#<Cmd>lua require('hlslens').start()<CR>]], desc = "Backward search current word" },
    },
    opts = { calm_down = true },
  },
  {
    "Bekaboo/deadcolumn.nvim",
    event = events.enter_buffer,
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    dependencies = {
      "akinsho/bufferline.nvim",
      optional = true,
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
    opts = {
      bottom = {
        {
          ft = "toggleterm",
          size = { height = 0.4 },
          filter = function(_, win) return vim.api.nvim_win_get_config(win).relative == "" end,
        },
        {
          ft = "noice",
          size = { height = 0.4 },
          filter = function(_, win) return vim.api.nvim_win_get_config(win).relative == "" end,
        },
        { ft = "qf", title = "QuickFix" },
        {
          ft = "help",
          size = { height = 0.4 },
          filter = function(buf) return vim.bo[buf].buftype == "help" end,
        },
        {
          ft = "markdown",
          size = { height = 0.4 },
          filter = function(buf) return vim.bo[buf].buftype == "help" end,
        },
        { ft = "dap-repl", title = "REPL" },
        { ft = "dapui_console", title = "Console" },
        { ft = "man", size = { height = 0.4 } },
      },
      left = {
        {
          ft = "dapui_scopes",
          title = "Scopes",
          size = { height = 0.25 },
        },
        {
          ft = "dapui_breakpoints",
          title = "Breakpoints",
          size = { height = 0.25 },
        },
        {
          ft = "dapui_stacks",
          title = "Stacks",
          size = { height = 0.25 },
        },
        {
          ft = "dapui_watches",
          title = "Watches",
          size = { height = 0.25 },
        },
      },
      right = {
        {
          title = "Treesitter",
          ft = "query",
          filter = function(buf, _) return vim.bo[buf].buftype ~= "" end,
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
      },
      exit_when_last = true,
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
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    opts = {},
  },
  {
    "mcauley-penney/visual-whitespace.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = events.enter_buffer,
    main = "ibl",
    opts = {
      debounce = 500,
      indent = { char = "│", tab_char = "│" },
      scope = {
        show_start = false,
        show_end = false,
        include = { node_type = { lua = { "table_constructor" } } },
      },
      exclude = { buftypes = ui.excluded_buftypes },
    },
  },
  {
    "kevinhwang91/nvim-bqf",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = "qf",
  },
  {
    "tiagovla/scope.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "RRethy/vim-illuminate",
    config = function() require("illuminate").configure({ providers = { "lsp", "treesitter" } }) end,
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = events.enter_buffer,
    keys = {
      {
        "[[",
        function()
          for _ = 1, vim.v.count1 do
            require("illuminate").goto_prev_reference(false)
          end
        end,
        desc = "Jump to the previous reference",
      },
      {
        "]]",
        function()
          for _ = 1, vim.v.count1 do
            require("illuminate").goto_next_reference(false)
          end
        end,
        desc = "Jump to the next reference",
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = "TermExec",
    keys = { { "<M-=>", desc = "Toggle terminal" } },
    opts = {
      open_mapping = "<M-=>",
      size = 10,
      float_opts = { title_pos = "center", border = "curved" },
    },
  },
  {
    "echasnovski/mini.files",
    config = function()
      require("mini.files").setup()

      -- https://www.lazyvim.org/extras/editor/mini-files {{{
      local function map_split(bufnr, lhs, direction, close_on_file)
        map({
          lhs,
          function()
            local new_target_window
            local cur_target_window = MiniFiles.get_target_window()
            if cur_target_window then
              vim.api.nvim_win_call(cur_target_window, function()
                vim.cmd("belowright " .. direction .. " split")
                new_target_window = vim.api.nvim_get_current_win()
              end)
              MiniFiles.set_target_window(new_target_window)
              MiniFiles.go_in({ close_on_file = close_on_file })
            end
          end,
          buffer = bufnr,
          desc = "Open in " .. direction .. " split" .. (close_on_file and " and close" or ""),
        })
      end

      local function cwd()
        local cur_entry_path = MiniFiles.get_fs_entry().path
        local cur_directory = vim.fs.dirname(cur_entry_path)
        if cur_entry_path then
          vim.fn.chdir(cur_directory)
        end
      end

      vim.api.nvim_create_autocmd("User", {
        callback = function(event)
          local bufnr = event.data.buf_id
          map({ "gc", cwd, buffer = bufnr, desc = "Change CWD to here" })
          map_split(bufnr, "<C-w>s", "horizontal", false)
          map_split(bufnr, "<C-w>v", "vertical", false)
          map_split(bufnr, "<C-w>S", "horizontal", true)
          map_split(bufnr, "<C-w>V", "vertical", true)
        end,
        pattern = "MiniFilesBufferCreate",
      })
      -- }}}
    end,
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
    keys = {
      { "u", desc = "Undo" },
      { "<C-r>", desc = "Redo" },
    },
    opts = {
      undo = { hlgroup = "IncSearch" },
      redo = { hlgroup = "IncSearch" },
    },
  },
  {
    "hedyhli/outline.nvim",
    cmd = "Outline",
    opts = {
      outline_window = { auto_close = true, hide_cursor = true },
      preview_window = { border = "rounded", winblend = require("dotfiles.user").ui.blend },
      keymaps = {
        goto_location = { "o", "<CR>" },
        peek_location = {},
        goto_and_close = {},
        up_and_jump = "<C-p>",
        down_and_jump = "<C-n>",
      },
      symbols = { icon_fetcher = function(kind, _) return require("mini.icons").get("lsp", kind) end },
    },
  },
  {
    "OXY2DEV/helpview.nvim",
    ft = "help",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "lewis6991/satellite.nvim",
    event = events.enter_buffer,
  },
}
