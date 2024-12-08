local events = require("dotfiles.utils.events")

return {
  {
    "tpope/vim-sleuth",
    event = events.enter_buffer,
  },
  -- https://www.lazyvim.org/plugins/coding#miniai {{{
  -- https://www.lazyvim.org/plugins/treesitter#nvim-treesitter-textobjects
  {
    "echasnovski/mini.ai",
    config = function(_, opts)
      require("mini.ai").setup(opts)

      local ok, wk = pcall(require, "which-key")
      if not ok then
        return
      end
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

      local ret = { mode = { "o", "x" } }
      for prefix, name in pairs({
        i = "inside",
        a = "around",
        il = "last",
        ["in"] = "next",
        al = "last",
        an = "next",
      }) do
        ret[#ret + 1] = { prefix, group = name }
        for _, obj in ipairs(objects) do
          ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
        end
      end
      wk.add(ret, { notify = false })
    end,
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
    event = events.enter_buffer,
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
      for _, parser in ipairs(require("nvim-treesitter.info").installed_parsers()) do
        if not vim.list_contains(ensure_installed_parsers, parser) then
          vim.cmd("TSUninstall " .. parser)
        end
      end
    end,
    event = events.enter_buffer,
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "diff",
        "doxygen",
        "fish",
        "git_rebase",
        "gitcommit",
        "html",
        "http",
        "json",
        "just",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "markdown_inline",
        "query",
        "regex",
        "sql",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-Space>",
          node_incremental = "<C-Space>",
          scope_incremental = false,
          node_decremental = "<bs>",
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
    opts = { mapping = { switchSlot = "<M-q>" } },
    keys = {
      { "q", desc = "Record macro" },
      { "Q", desc = "Replay macro" },
      { "<M-q>", desc = "Change register slot" },
      { "cq", desc = "Edit macro" },
      { "dq", desc = "Delete all macros" },
      { "yq", desc = "Yank macro" },
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
      "/",
      "?",
      "f",
      "F",
      "t",
      "T",
      ",",
      ";",
      { "gs", function() require("flash").jump() end, desc = "Flash" },
      { "gt", function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      {
        "r",
        function() require("flash").remote() end,
        mode = "o",
        desc = "Remote Flash",
      },
      {
        "R",
        function() require("flash").treesitter_search() end,
        mode = { "o", "x" },
        desc = "Treesitter search",
      },
    },
    opts = {
      modes = { char = { highlight = { backdrop = false } } },
      prompt = { enabled = false },
    },
  },
  {
    "folke/snacks.nvim",
    -- https://www.lazyvim.org/ {{{
    config = function(_, opts)
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

          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<Leader>uw")
          Snacks.toggle.diagnostics():map("<Leader>ux")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<Leader>uc")
          Snacks.toggle.treesitter():map("<Leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<Leader>ug")

          Snacks.toggle.profiler():map("<Leader>pp")
          Snacks.toggle.profiler_highlights():map("<Leader>ph")
        end,
        pattern = "VeryLazy",
      })

      vim.api.nvim_create_autocmd("User", {
        callback = function(event) Snacks.rename.on_rename_file(event.data.from, event.data.to) end,
        pattern = "MiniFilesActionRename",
      })
    end,
    lazy = false,
    keys = {
      { "<Leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss all notifications" },
      { "<C-q>", function() Snacks.bufdelete() end, desc = "Delete buffer" },
      { "<Leader>gf", function() Snacks.gitbrowse() end, desc = "Git browse" },
      { "<M-=>", function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "Terminal" },
      { "<Leader>.", function() Snacks.scratch() end, desc = "Toggle scratch buffer" },
    },
    opts = {
      bigfile = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { folds = { open = true, git_hl = true } },
      words = { enabled = true },
      dashboard = {
        preset = {
          header = [[
 __    __ __     __ ______ __       __      __    __ ________ _______   ______  
|  \  |  \  \   |  \      \  \     /  \    |  \  |  \        \       \ /      \ 
| ▓▓\ | ▓▓ ▓▓   | ▓▓\▓▓▓▓▓▓ ▓▓\   /  ▓▓    | ▓▓  | ▓▓ ▓▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\
| ▓▓▓\| ▓▓ ▓▓   | ▓▓ | ▓▓ | ▓▓▓\ /  ▓▓▓    | ▓▓__| ▓▓ ▓▓__   | ▓▓__| ▓▓ ▓▓  | ▓▓
| ▓▓▓▓\ ▓▓\▓▓\ /  ▓▓ | ▓▓ | ▓▓▓▓\  ▓▓▓▓    | ▓▓    ▓▓ ▓▓  \  | ▓▓    ▓▓ ▓▓  | ▓▓
| ▓▓\▓▓ ▓▓ \▓▓\  ▓▓  | ▓▓ | ▓▓\▓▓ ▓▓ ▓▓    | ▓▓▓▓▓▓▓▓ ▓▓▓▓▓  | ▓▓▓▓▓▓▓\ ▓▓  | ▓▓
| ▓▓ \▓▓▓▓  \▓▓ ▓▓  _| ▓▓_| ▓▓ \▓▓▓| ▓▓    | ▓▓  | ▓▓ ▓▓_____| ▓▓  | ▓▓ ▓▓__/ ▓▓
| ▓▓  \▓▓▓   \▓▓▓  |   ▓▓ \ ▓▓  \▓ | ▓▓    | ▓▓  | ▓▓ ▓▓     \ ▓▓  | ▓▓\▓▓    ▓▓
 \▓▓   \▓▓    \▓    \▓▓▓▓▓▓\▓▓      \▓▓     \▓▓   \▓▓\▓▓▓▓▓▓▓▓\▓▓   \▓▓ \▓▓▓▓▓▓ 
          ]],
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            {
              icon = " ",
              key = "r",
              desc = "Recent Files",
              action = ":lua Snacks.dashboard.pick('oldfiles', { only_cwd = true })",
            },
            { icon = " ", key = "/", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "c", desc = "Config", action = ":e ~/.nvimrc" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      scratch = { autowrite = false },
    },
  },
}
