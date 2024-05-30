local events = require("utils.events")
local excluded_buftypes = require("utils.ui").excluded_buftypes
local excluded_filetypes = require("utils.ui").excluded_filetypes

return {
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = events.enter_buffer,
    keys = {
      {
        "[t",
        function() require("todo-comments").jump_prev() end,
        desc = "Previous TODO",
      },
      {
        "]t",
        function() require("todo-comments").jump_next() end,
        desc = "Next TODO",
      },
      { "<Leader>xt", "<Cmd>TodoTrouble<CR>", desc = "Todo" },
      { "<Leader>xT", "<Cmd>TodoTrouble keywords=TODO,FIX,FIXME<CR>", desc = "Todo/Fix/Fixme" },
      { "<Leader>st", "<Cmd>TodoTelescope<CR>", desc = "Todo" },
      { "<Leader>sT", "<Cmd>TodoTelescope keywords=TODO,FIX,FIXME<CR>", desc = "Todo/Fix/Fixme" },
    },
    opts = { signs = false },
  },
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
      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", "<Cmd>Telescope find_files<CR>"),
        dashboard.button("r", " " .. " Recent files", "<Cmd>Telescope oldfiles cwd_only=true<CR>"),
        dashboard.button("/", " " .. " Find text", "<Cmd>Telescope live_grep<CR>"),
        dashboard.button("c", " " .. " Config", "<Cmd>e ~/.nvimrc<CR>"),
        dashboard.button("s", " " .. " Restore session", "<Cmd>SessionLoad<CR>"),
        dashboard.button("l", "󰒲 " .. " Lazy", "<Cmd>Lazy<CR>"),
        dashboard.button("q", " " .. " Quit", "<Cmd>qa<CR>"),
      }
      dashboard.opts.layout[1].val = 8
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
  {
    "akinsho/bufferline.nvim",
    config = function(_, opts)
      require("bufferline").setup(opts)
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function() pcall(nvim_bufferline) end)
        end,
      })
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
        desc = "Next buffer",
      },
      {
        "[b",
        function()
          for _ = 1, vim.v.count1 do
            vim.cmd("BufferLineCyclePrev")
          end
        end,
        desc = "Previous buffer",
      },
      { "g1", "<Cmd>BufferLineGoToBuffer 1<CR>", desc = "Go to buffer 1" },
      { "g2", "<Cmd>BufferLineGoToBuffer 2<CR>", desc = "Go to buffer 2" },
      { "g3", "<Cmd>BufferLineGoToBuffer 3<CR>", desc = "Go to buffer 3" },
      { "g4", "<Cmd>BufferLineGoToBuffer 4<CR>", desc = "Go to buffer 4" },
      { "g5", "<Cmd>BufferLineGoToBuffer 5<CR>", desc = "Go to buffer 5" },
      { "g6", "<Cmd>BufferLineGoToBuffer 6<CR>", desc = "Go to buffer 6" },
    },
    opts = {
      options = {
        numbers = "ordinal",
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = true,
        themable = true,
      },
    },
  },
  {
    "stevearc/dressing.nvim",
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
    lazy = true,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      vim.opt.laststatus = 3

      local function is_cmake_project()
        return package.loaded["cmake-tools"] and require("cmake-tools").is_cmake_project()
      end

      require("lualine").setup({
        options = { component_separators = "", section_separators = "" },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {
            { "branch", icon = "" },
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
            { "progress" },
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
          "trouble",
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
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      wk.register(opts.normal_group)
      wk.register(opts.visual_group, { mode = "v" })
      wk.register(opts.operator_group, { mode = "o" })
    end,
    event = "VeryLazy",
    opts = {
      window = { winblend = require("user").ui.blend },
      layout = { height = { max = 10 } },
      normal_group = {
        ["g"] = { name = "+goto" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<Leader><Tab>"] = { name = "+tab" },
        ["<Leader>b"] = { name = "+biquge" },
        ["<Leader>c"] = { name = "+code" },
        ["<Leader>d"] = { name = "+debug" },
        ["<Leader>dp"] = { name = "+debugprint" },
        ["<Leader>f"] = { name = "+file" },
        ["<Leader>g"] = { name = "+git" },
        ["<Leader>gx"] = { name = "+conflict" },
        ["<Leader>m"] = { name = "+cmake" },
        ["<Leader>q"] = { name = "+quit/sessions" },
        ["<Leader>s"] = { name = "+search" },
        ["<Leader>u"] = { name = "+ui" },
        ["<Leader>x"] = { name = "+diagnostics/quickfix" },
      },
      visual_group = {
        ["<Leader>c"] = { name = "+code" },
        ["<Leader>s"] = { name = "+search" },
      },
      operator_group = {
        ["g"] = { name = "+goto" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
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
    keys = {
      { "<Leader>xn", "<Cmd>NoiceAll<CR>", desc = "Message" },
      { "<Leader>un", "<Cmd>Noice dismiss<CR>", desc = "Dismiss all notifications" },
      {
        "<C-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<C-f>"
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
            return "<C-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = { "i", "n", "s" },
      },
    },
    opts = function()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(event)
          vim.schedule(function() require("noice.text.markdown").keys(event.buf) end)
        end,
        pattern = "markdown",
      })

      return {
        views = { split = { enter = true } },
        presets = {
          long_message_to_split = true,
          bottom_search = true,
          command_palette = true,
        },
        messages = { view_search = false },
        lsp = {
          hover = { enabled = false },
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
              any = { { find = "%d+L, %d+B" }, { find = "; after #%d+" }, { find = "; before #%d+" } },
            },
            view = "mini",
          },
        },
      }
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    branch = "0.10",
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        bt_ignore = excluded_buftypes,
        ft_ignore = excluded_filetypes,
        relculright = true,
        segments = {
          { sign = { name = { "Dap" } }, click = "v:lua.ScSa" },
          { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
          { sign = { namespace = { "gitsigns" } }, click = "v:lua.ScSa" },
        },
      })
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require("hlslens").setup({ calm_down = true })
      vim.api.nvim_create_autocmd("User", {
        callback = require("hlslens").start,
        pattern = "visual_multi_start",
      })
      vim.api.nvim_create_autocmd("User", {
        callback = require("hlslens").stop,
        pattern = "visual_multi_exit",
      })
    end,
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
        {
          ft = "trouble",
          filter = function(_, win)
            return vim.w[win].trouble
              and vim.w[win].trouble.position == "bottom"
              and vim.w[win].trouble.type == "split"
              and vim.w[win].trouble.relative == "editor"
              and not vim.w[win].trouble_preview
          end,
        },
        { ft = "qf", title = "QuickFix" },
        {
          ft = "help",
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
          ft = "trouble",
          filter = function(_, win)
            return vim.w[win].trouble
              and vim.w[win].trouble.position == "right"
              and vim.w[win].trouble.type == "split"
              and vim.w[win].trouble.relative == "editor"
              and not vim.w[win].trouble_preview
          end,
        },
        {
          title = "Treesitter",
          ft = "query",
          filter = function(buf, _) return vim.bo[buf].buftype ~= "" end,
          size = { width = 0.4 },
          wo = { number = false, relativenumber = false, stc = "" },
        },
        {
          title = "Clang AST",
          ft = "ClangdAST",
          size = { width = 0.4 },
        },
      },
      exit_when_last = true,
    },
  },
  {
    "echasnovski/mini.trailspace",
    event = events.enter_buffer,
    init = function()
      vim.api.nvim_set_hl(0, "MiniTrailspace", { bg = "LightGreen" })
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args) vim.b[args.buf].minitrailspace_disable = true end,
        pattern = excluded_filetypes,
      })
    end,
    opts = {},
  },
  {
    "b0o/incline.nvim",
    event = "LspAttach",
    opts = {
      render = function(props)
        local label = {}
        if #vim.lsp.get_clients({ bufnr = props.buf }) > 0 then
          local icons = require("utils.ui").icons.diagnostic
          for severity, icon in pairs(icons) do
            local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
            if n > 0 then
              if #label ~= 0 then
                table.insert(label, { " ", group = "Normal" })
              end
              table.insert(label, { icon .. " " .. n, group = "DiagnosticSign" .. severity })
            end
          end
        end
        return label
      end,
      ignore = { filetypes = excluded_filetypes },
      window = {
        margin = {
          vertical = { top = 3, bottom = 0 },
          horizontal = { left = 1, right = 5 },
        },
      },
    },
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "MeanderingProgrammer/markdown.nvim",
    main = "render-markdown",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = "markdown",
    opts = {},
  },
  {
    "mcauley-penney/visual-whitespace.nvim",
    event = "ModeChanged *:[vV\x16]*",
    opts = {},
  },
  {
    "hiphish/rainbow-delimiters.nvim",
    main = "rainbow-delimiters.setup",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = events.enter_buffer,
    opts = { highlight = require("utils.ui").rainbow_highlight },
  },
  {
    "v1nh1shungry/plantuml-preview.nvim",
    ft = "markdown",
    init = function()
      vim.api.nvim_create_autocmd(events.enter_buffer, {
        callback = function(args)
          require("utils.keymap")({
            "<Leader>up",
            function() require("plantuml-preview").toggle() end,
            buffer = args.buf,
            desc = "Toggle plantuml preview",
          })
        end,
        pattern = { "*.md", "*.puml" },
      })
    end,
    opts = {},
  },
  {
    "echasnovski/mini.files",
    keys = { { "<Leader>e", "<Cmd>lua MiniFiles.open()<CR>", desc = "Explorer" } },
    opts = {},
  },
}
