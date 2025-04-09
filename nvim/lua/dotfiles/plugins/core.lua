---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_nomode = "i"
    end,
    event = "LazyFile",
  },
  {
    "nmac427/guess-indent.nvim",
    event = "LazyFile",
    ---@module "guess-indent.config"
    ---@type GuessIndentConfig
    opts = {},
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
    event = "LazyFile",
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
              if first_nonblank == 0 or last_nonblank == 0 then return { from = { line = start_line, col = 1 } } end
              start_line, end_line = first_nonblank, last_nonblank
            end
            local to_col = math.max(vim.fn.getline(end_line):len(), 1)
            return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
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
      local ensure_installed_parsers = vim.list_extend({
        "c",
        "lua",
        "markdown",
        "markdown_inline",
        "query",
        "vim",
        "vimdoc",
      }, require("nvim-treesitter.configs").get_ensure_installed_parsers() --[=[@as string[]]=])
      local unused_parsers = {}
      for _, parser in ipairs(require("nvim-treesitter.info").installed_parsers()) do
        if not vim.list_contains(ensure_installed_parsers, parser) then table.insert(unused_parsers, parser) end
      end
      if #unused_parsers > 0 then require("nvim-treesitter.install").uninstall(unused_parsers) end
    end,
    event = "LazyFile",
    -- https://github.com/LazyVim/LazyVim {{{
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    -- }}}
    opts = { ---@type TSConfig|{}
      ensure_installed = {
        "bash",
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
        "luadoc",
        "luap",
        "make",
        "printf",
        "regex",
        "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
      matchup = { enable = true, disable_virtual_text = true, include_match_words = true },
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
        swap = {
          enable = true,
          swap_next = { ["<C-l>"] = "@parameter.inner" },
          swap_previous = { ["<C-h>"] = "@parameter.inner" },
        },
      },
    },
    opts_extend = { "ensure_installed" },
  },
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { "w", "<Cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" }, desc = "Next Word" },
      { "e", "<Cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" }, desc = "Next End of Word" },
      { "b", "<Cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" }, desc = "Previous Word" },
      { "ge", "<Cmd>lua require('spider').motion('ge')<CR>", mode = { "n", "o", "x" }, desc = "Previous End of Word" },
    },
  },
  {
    "echasnovski/mini.operators",
    keys = {
      { "g=", mode = { "n", "v" }, desc = "Evaluate" },
      { "cx", mode = { "n", "v" }, desc = "Exchange" },
      { "gm", mode = { "n", "v" }, desc = "Dumplicate" },
      { "gr", mode = { "n", "v" }, desc = "Replace with Register" },
      { "gS", mode = { "n", "v" }, desc = "Sort" },
    },
    opts = {
      sort = { prefix = "gS" },
      exchange = { prefix = "cx" },
    },
  },
  {
    "lambdalisue/suda.vim",
    cmd = { "SudaRead", "SudaWrite" },
  },
  {
    "numToStr/Navigator.nvim",
    keys = {
      { "<M-h>", "<Cmd>NavigatorLeft<CR>", desc = "Left Window", mode = { "n", "t" } },
      { "<M-l>", "<Cmd>NavigatorRight<CR>", desc = "Right window", mode = { "n", "t" } },
      { "<M-j>", "<Cmd>NavigatorDown<CR>", desc = "Lower Window", mode = { "n", "t" } },
      { "<M-k>", "<Cmd>NavigatorUp<CR>", desc = "Upper Window", mode = { "n", "t" } },
    },
    ---@module "Navigator"
    ---@type Config|{}
    opts = {},
  },
  {
    "echasnovski/mini.jump",
    keys = vim.iter({ "f", "F", "t", "T", ",", ";" }):map(function(m) return { m, mode = { "n", "x" } } end):totable(),
    opts = {},
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
      { "<Leader><Space>", function() Snacks.picker.smart({ filter = { cwd = true } }) end, desc = "Smart Find Files" },
      { "<Leader>h", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<Leader>/", function() Snacks.picker.grep() end, desc = "Live Grep" },
      { "<Leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<C-q>", function() Snacks.bufdelete() end, desc = "Close Buffer" },
      { "<M-=>", function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "Terminal" },
      { "<C-w>z", function() Snacks.zen.zoom() end, desc = "Zoom" },
      { "<Leader>ut", function() Snacks.picker.undo() end, desc = "Undotree" },
      { "<Leader>p/", function() Snacks.profiler.pick() end, desc = "Check Profiler" },
      { "<Leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<Leader>u/", function() Snacks.picker.notifications() end, desc = "Notifications" },
      { "<Leader>gf", function() Snacks.gitbrowse() end, mode = { "n", "x" }, desc = "Git Browse" },
      { "<Leader>fs", function() Snacks.scratch() end, desc = "Open Scratch Buffer" },
      { "<Leader>ft", function() Snacks.picker.explorer() end, desc = "Explorer (Tree)" },
      { "<Leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<Leader>fr", function() Snacks.picker.recent({ filter = { cwd = true } }) end, desc = "Recent Files" },
      { "<Leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<Leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocommands" },
      { "<Leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<Leader>s,", function() Snacks.picker.resume() end, desc = "Resume Last Search" },
      { "<Leader>sh", function() Snacks.picker.highlights() end, desc = "Highlight Groups" },
      { "<Leader>sm", function() Snacks.picker.man() end, desc = "Manpages" },
      { "<Leader>sx", function() Snacks.picker.diagnostics_buffer() end, desc = "Document Diagnostics" },
      { "<Leader>sX", function() Snacks.picker.diagnostics() end, desc = "Workspace Diagnostics" },
      { "<Leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<Leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<Leader>sC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      { "<Leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<Leader>sp", function() Snacks.picker.lazy() end, desc = "Plugins" },
      { "<Leader>sz", function() Snacks.picker.zoxide() end, desc = "Zoxide" },
      { "<Leader>s:", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<Leader>gl", function() Snacks.picker.git_log_file() end, desc = "Log File" },
      { "<Leader>gL", function() Snacks.picker.git_log() end, desc = "Log" },
      { "<Leader>gs", function() Snacks.picker.git_status() end, desc = "Status" },
      { "<Leader>bb", function() Snacks.picker.buffers() end, desc = "Find Buffers" },
      { "<Leader>b/", function() Snacks.picker.grep_buffers() end, desc = "Grep" },
      { "<Leader>bo", function() Snacks.bufdelete.other() end, desc = "Only" },
    },
    opts = { ---@type snacks.Config
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
            { icon = " ", key = "f", desc = "Find File", action = "<Leader><Space>" },
            { icon = " ", key = "r", desc = "Recent Files", action = "<Leader>fr" },
            { icon = " ", key = "/", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
            { icon = " ", key = "c", desc = "Config", action = "<Leader>fc" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      picker = {
        layout = { preset = "ivy" },
        previewers = { git = { native = true } },
      },
      quickfile = { enabled = true },
      scope = { cursor = false },
      scratch = { autowrite = false },
      statuscolumn = { folds = { open = true, git_hl = true } },
      words = { enabled = true },
    },
    priority = 1000,
  },
}
