return {
  {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_nomode = "i"
      vim.g.matchup_delim_noskips = 2
      vim.g.matchup_matchparen_pumvisible = 0
    end,
    event = Dotfiles.events.enter_buffer,
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "tpope/vim-sleuth",
    event = Dotfiles.events.enter_buffer,
  },
  -- https://www.lazyvim.org/plugins/coding#miniai {{{
  -- https://www.lazyvim.org/plugins/treesitter#nvim-treesitter-textobjects
  {
    "echasnovski/mini.ai",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          local move = require("nvim-treesitter.textobjects.move")
          local configs = require("nvim-treesitter.configs")
          for name, fn in pairs(move) do
            if name:find("goto") == 1 then
              move[name] = function(q, ...)
                if vim.wo.diff then
                  local config = configs.get_module("textobjects.move")[name]
                  for key, query in pairs(config or {}) do
                    if q == query and key:find("[%]%[][cC]") then
                      vim.cmd("normal! " .. key)
                      return
                    end
                  end
                end
                return fn(q, ...)
              end
            end
          end
        end,
        dependencies = "nvim-treesitter/nvim-treesitter",
      },
    },
    event = Dotfiles.events.enter_buffer,
    opts = function()
      local ai = require("mini.ai")

      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          d = { "%f[%d]%d+" },
          g = function(ai_type)
            local start_line, end_line = 1, vim.fn.line("$")
            if ai_type == "i" then
              local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
              if first_nonblank == 0 or last_nonblank == 0 then
                return { from = { line = start_line, col = 1 } }
              end
              start_line, end_line = first_nonblank, last_nonblank
            end
            local to_col = math.max(vim.fn.getline(end_line):len(), 1)
            return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
          end,
          i = function(ai_type)
            local spaces = (" "):rep(vim.o.tabstop)
            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            local indents = {}
            for l, line in ipairs(lines) do
              if not line:find("^%s*$") then
                indents[#indents + 1] = { line = l, indent = #line:gsub("\t", spaces):match("^%s*"), text = line }
              end
            end
            local ret = {}
            for i = 1, #indents do
              if i == 1 or indents[i - 1].indent < indents[i].indent then
                local from, to = i, i
                for j = i + 1, #indents do
                  if indents[j].indent < indents[i].indent then
                    break
                  end
                  to = j
                end
                from = ai_type == "a" and from > 1 and from - 1 or from
                to = ai_type == "a" and to < #indents and to + 1 or to
                ret[#ret + 1] = {
                  indent = indents[i].indent,
                  from = { line = indents[from].line, col = ai_type == "a" and 1 or indents[from].indent + 1 },
                  to = { line = indents[to].line, col = #indents[to].text },
                }
              end
            end
            return ret
          end,
          u = ai.gen_spec.function_call(),
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
          w = {
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
        },
      }
    end,
    specs = {
      {
        "folke/which-key.nvim",
        opts = function()
          local objects = {
            { " ", desc = "whitespace" },
            { '"', desc = 'balanced "' },
            { "'", desc = "balanced '" },
            { "(", desc = "balanced (" },
            { ")", desc = "balanced ) including white-space" },
            { "<", desc = "balanced <" },
            { ">", desc = "balanced > including white-space" },
            { "?", desc = "user prompt" },
            { "U", desc = "use/call without dot in name" },
            { "[", desc = "balanced [" },
            { "]", desc = "balanced ] including white-space" },
            { "_", desc = "underscore" },
            { "`", desc = "balanced `" },
            { "a", desc = "argument" },
            { "b", desc = "balanced )]}" },
            { "c", desc = "class" },
            { "d", desc = "digit(s)" },
            { "f", desc = "function" },
            { "g", desc = "entire file" },
            { "i", desc = "indent" },
            { "o", desc = "block, conditional, loop" },
            { "q", desc = "quote `\"'" },
            { "t", desc = "tag" },
            { "u", desc = "use/call function & method" },
            { "{", desc = "balanced {" },
            { "}", desc = "balanced } including white-space" },
          }

          local spec = { mode = { "o", "x" } }
          for prefix, name in pairs({
            i = "inside",
            a = "around",
            il = "last",
            ["in"] = "next",
            al = "last",
            an = "next",
          }) do
            spec[#spec + 1] = { prefix, group = name }
            for _, obj in ipairs(objects) do
              spec[#spec + 1] = { prefix .. obj[1], desc = obj.desc }
            end
          end

          return { spec = { spec } }
        end,
      },
    },
  },
  -- }}}
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = { "TSInstall", "TSUpdate" },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- clean unused parsers
      local ensure_installed_parsers = require("nvim-treesitter.configs").get_ensure_installed_parsers()
      local unused_parsers = {}
      for _, parser in ipairs(require("nvim-treesitter.info").installed_parsers()) do
        if not vim.list_contains(ensure_installed_parsers, parser) then
          table.insert(unused_parsers, parser)
        end
      end
      if #unused_parsers > 0 then
        vim.cmd("TSUninstall " .. table.concat(unused_parsers, " "))
      end
    end,
    event = Dotfiles.events.enter_buffer,
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "diff",
        "doxygen",
        "fish",
        "gitcommit",
        "html",
        "http",
        "json",
        "just",
        "lua",
        "luadoc",
        "luap",
        "make",
        "markdown",
        "markdown_inline",
        "printf",
        "query",
        "regex",
        "sql",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
      matchup = {
        enable = true,
        disable_virtual_text = true,
        include_match_words = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-Space>",
          node_incremental = "<C-Space>",
          scope_incremental = false,
          node_decremental = "<BS>",
        },
      },
      textobjects = {
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = { ["]a"] = "@parameter.inner", ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[a"] = "@parameter.inner", ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
    },
    opts_extend = { "ensure_installed" },
  },
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { "w", "<Cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" }, desc = "Next word" },
      { "e", "<Cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" }, desc = "Next end of word" },
      { "b", "<Cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" }, desc = "Previous word" },
      { "ge", "<Cmd>lua require('spider').motion('ge')<CR>", mode = { "n", "o", "x" }, desc = "Previous end of word" },
    },
  },
  {
    "echasnovski/mini.operators",
    keys = {
      { "g=", mode = { "n", "v" }, desc = "Evaluate" },
      { "cx", mode = { "n", "v" }, desc = "Exchange" },
      { "gm", mode = { "n", "v" }, desc = "Dumplicate" },
      { "gr", mode = { "n", "v" }, desc = "Replace with register" },
      { "gS", mode = { "n", "v" }, desc = "Sort" },
    },
    opts = {
      sort = { prefix = "gS" },
      exchange = { prefix = "cx" },
    },
  },
  {
    "chrisgrieser/nvim-recorder",
    opts = {
      mapping = { switchSlot = "<M-q>" },
      useNerdfontIcons = false,
    },
    keys = {
      { "q", desc = "Start/Stop Recording" },
      { "Q", desc = "Play Macro" },
      { "<M-q>", desc = "Switch Macro Slot" },
      { "cq", desc = "Edit Macro" },
      { "dq", desc = "Delete All Macros" },
      { "yq", desc = "Yank Macro" },
    },
  },
  {
    "lambdalisue/suda.vim",
    cmd = { "SudaRead", "SudaWrite" },
  },
  {
    "numToStr/Navigator.nvim",
    keys = {
      { "<M-h>", "<Cmd>NavigatorLeft<CR>", desc = "Go to left window", mode = { "i", "n", "t" } },
      { "<M-l>", "<Cmd>NavigatorRight<CR>", desc = "Go to right window", mode = { "i", "n", "t" } },
      { "<M-j>", "<Cmd>NavigatorDown<CR>", desc = "Go to lower window", mode = { "i", "n", "t" } },
      { "<M-k>", "<Cmd>NavigatorUp<CR>", desc = "Go to upper window", mode = { "i", "n", "t" } },
    },
    opts = {},
  },
  {
    "folke/flash.nvim",
    keys = {
      "f",
      "F",
      "t",
      "T",
      ",",
      ";",
      {
        "gs",
        function()
          require("flash").jump()
        end,
        mode = { "n", "x", "o" },
        desc = "Jump",
      },
      {
        "r",
        function()
          require("flash").remote()
        end,
        mode = "o",
        desc = "Jump",
      },
      {
        "<C-s>",
        function()
          require("flash").toggle()
        end,
        mode = "c",
        desc = "Toggle search jump",
      },
    },
    opts = { modes = { char = { highlight = { backdrop = false } } } },
  },
  {
    "folke/snacks.nvim",
    -- https://www.lazyvim.org/ {{{
    config = function(_, opts)
      vim.g.snacks_animate = false

      local notify = vim.notify
      require("snacks").setup(opts)
      -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
      -- this is needed to have early notifications show up in noice history
      vim.notify = notify
    end,
    -- }}}
    init = function()
      vim.api.nvim_create_autocmd("User", {
        callback = function()
          vim.print = Snacks.debug.inspect

          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<Leader>ug")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<Leader>uc")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<Leader>uw")

          Snacks.toggle.option("relativenumber", { name = "Relative number" }):map("<Leader>uL")
          Snacks.toggle.line_number():map("<Leader>ul")

          Snacks.toggle.diagnostics():map("<Leader>ux")
          Snacks.toggle.treesitter():map("<Leader>uT")

          Snacks.toggle.profiler():map("<Leader>pp")
        end,
        pattern = "VeryLazy",
      })
    end,
    lazy = false,
    keys = {
      {
        "<Leader>un",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss all notifications",
      },
      {
        "<C-q>",
        function()
          Snacks.bufdelete()
        end,
        desc = "Close buffer",
      },
      {
        "<Leader>gf",
        function()
          Snacks.gitbrowse()
        end,
        mode = { "n", "x" },
        desc = "Git browse",
      },
      {
        "<M-=>",
        function()
          Snacks.terminal.toggle()
        end,
        mode = { "n", "t" },
        desc = "Terminal",
      },
      {
        "<Leader>fs",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle scratch buffer",
      },
      {
        "<C-w>z",
        function()
          Snacks.zen.zoom()
        end,
        desc = "Zoom",
      },
      {
        "<Leader>h",
        function()
          Snacks.picker.help()
        end,
        desc = "Help pages",
      },
      {
        "<Leader>ff",
        function()
          Snacks.picker.smart({ filter = { cwd = true } })
        end,
        desc = "Smartly find files",
      },
      {
        "<Leader>fF",
        function()
          Snacks.picker.files()
        end,
        desc = "Find files",
      },
      {
        "<Leader>fr",
        function()
          Snacks.picker.recent({ filter = { cwd = true } })
        end,
        desc = "Recent files",
      },
      {
        "<Leader>/",
        function()
          Snacks.picker.grep()
        end,
        desc = "Live grep",
      },
      {
        "<Leader>sa",
        function()
          Snacks.picker.autocmds()
        end,
        desc = "Autocommands",
      },
      {
        "<Leader>sk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<Leader>s,",
        function()
          Snacks.picker.resume()
        end,
        desc = "Last search",
      },
      {
        "<Leader>sh",
        function()
          Snacks.picker.highlights()
        end,
        desc = "Highlight groups",
      },
      {
        "<Leader>sm",
        function()
          Snacks.picker.man()
        end,
        desc = "Manpages",
      },
      {
        "<Leader>sx",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Document diagnostics",
      },
      {
        "<Leader>sX",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Workspace diagnostics",
      },
      {
        "<Leader>sq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix",
      },
      {
        "<Leader>sl",
        function()
          Snacks.picker.loclist()
        end,
        desc = "Loclist",
      },
      {
        "<Leader>sb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<Leader>sC",
        function()
          Snacks.picker.colorschemes()
        end,
        desc = "Colorschemes",
      },
      {
        "<Leader>sj",
        function()
          Snacks.picker.jumps()
        end,
        desc = "Jumplist",
      },
      {
        "<Leader>si",
        function()
          Snacks.picker.icons()
        end,
        desc = "Icons",
      },
      {
        "<Leader>sp",
        function()
          Snacks.picker.lazy()
        end,
        desc = "Plugin specs",
      },
      {
        "<Leader>sz",
        function()
          Snacks.picker.zoxide()
        end,
        desc = "Zoxide",
      },
      {
        "<Leader>sP",
        function()
          Snacks.picker.projects()
        end,
        desc = "Projects",
      },
      {
        "<Leader>gl",
        function()
          Snacks.picker.git_log_file()
        end,
        desc = "Git log (current file)",
      },
      {
        "<Leader>gL",
        function()
          Snacks.picker.git_log()
        end,
        desc = "Git log",
      },
      {
        "<Leader>gs",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Git status",
      },
      {
        "<Leader>ut",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undotree",
      },
    },
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        preset = {
          header = [[
 __    __ __     __ ______ __       __  ______  _______   ______  ________ ________ 
|  \  |  \  \   |  \      \  \     /  \/      \|       \ /      \|        \        \
| ▓▓\ | ▓▓ ▓▓   | ▓▓\▓▓▓▓▓▓ ▓▓\   /  ▓▓  ▓▓▓▓▓▓\ ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\ ▓▓▓▓▓▓▓▓\▓▓▓▓▓▓▓▓
| ▓▓▓\| ▓▓ ▓▓   | ▓▓ | ▓▓ | ▓▓▓\ /  ▓▓▓ ▓▓   \▓▓ ▓▓__| ▓▓ ▓▓__| ▓▓ ▓▓__      | ▓▓   
| ▓▓▓▓\ ▓▓\▓▓\ /  ▓▓ | ▓▓ | ▓▓▓▓\  ▓▓▓▓ ▓▓     | ▓▓    ▓▓ ▓▓    ▓▓ ▓▓  \     | ▓▓   
| ▓▓\▓▓ ▓▓ \▓▓\  ▓▓  | ▓▓ | ▓▓\▓▓ ▓▓ ▓▓ ▓▓   __| ▓▓▓▓▓▓▓\ ▓▓▓▓▓▓▓▓ ▓▓▓▓▓     | ▓▓   
| ▓▓ \▓▓▓▓  \▓▓ ▓▓  _| ▓▓_| ▓▓ \▓▓▓| ▓▓ ▓▓__/  \ ▓▓  | ▓▓ ▓▓  | ▓▓ ▓▓        | ▓▓   
| ▓▓  \▓▓▓   \▓▓▓  |   ▓▓ \ ▓▓  \▓ | ▓▓\▓▓    ▓▓ ▓▓  | ▓▓ ▓▓  | ▓▓ ▓▓        | ▓▓   
 \▓▓   \▓▓    \▓    \▓▓▓▓▓▓\▓▓      \▓▓ \▓▓▓▓▓▓ \▓▓   \▓▓\▓▓   \▓▓\▓▓         \▓▓   
          ]],
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = "<Leader>ff" },
            { icon = " ", key = "r", desc = "Recent Files", action = "<Leader>fr" },
            { icon = " ", key = "/", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
            { icon = " ", key = "c", desc = "Config", action = "<Leader>fc" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      image = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      picker = { layout = { preset = "ivy" } },
      quickfile = { enabled = true },
      scope = { cursor = false },
      scratch = { autowrite = false },
      statuscolumn = { folds = { open = true, git_hl = true } },
      words = { enabled = true },
    },
    priority = 1000,
    specs = {
      {
        "folke/lazydev.nvim",
        opts = { library = { { path = "snacks.nvim", words = { "Snacks" } } } },
      },
    },
  },
}
