return {
  {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_nomode = "i"
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_treesitter_disable_virtual_text = true
    end,
    event = "LazyFile",
  },
  {
    "nmac427/guess-indent.nvim",
    event = "LazyFile",
    opts = {},
  },
  -- https://www.lazyvim.org/plugins/coding#miniai {{{
  {
    "echasnovski/mini.ai",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
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
              if first_nonblank == 0 or last_nonblank == 0 then
                return { from = { line = start_line, col = 1 } }
              end
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
    branch = "main",
    build = ":TSUpdate",
    config = function(_, opts)
      require("nvim-treesitter").install(opts.ensure_installed)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          vim.treesitter.start()
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

          ---@param direction "goto_next_start"|"goto_next_end"|"goto_previous_start"|"goto_previous_end"
          ---@param key string
          ---@param textobject string
          local function map_move(direction, key, textobject)
            local desc = direction:gsub("_", " ")
            desc = desc:sub(1, 1):upper() .. desc:sub(2) .. " " .. textobject

            Dotfiles.map({
              key,
              function()
                if vim.wo.diff and key:find("[%]%[][cC]") then
                  vim.cmd("normal! " .. key)
                else
                  require("nvim-treesitter-textobjects.move")[direction](textobject, "textobjects")
                end
              end,
              mode = { "n", "x", "o" },
              desc = desc,
              buffer = args.buf,
            })
          end

          for direction, mappings in pairs(opts.textobjects.move) do
            for key, textobject in pairs(mappings) do
              map_move(direction, key, textobject)
            end
          end
        end,
        pattern = vim.iter(opts.ensure_installed):map(vim.treesitter.language.get_filetypes):flatten():totable(),
      })

      -- clean unused parsers
      local ensure_installed_parsers = vim.list_extend({ -- bundled with Neovim
        "c",
        "html_tags", -- bundled with nvim-treesitter
        "lua",
        "markdown",
        "markdown_inline",
        "query",
        "vim",
        "vimdoc",
      }, opts.ensure_installed)

      local unused_parsers = {}
      for _, parser in ipairs(require("nvim-treesitter.config").get_installed()) do
        if not vim.list_contains(ensure_installed_parsers, parser) then
          table.insert(unused_parsers, parser)
        end
      end
      if #unused_parsers > 0 then
        require("nvim-treesitter").uninstall(unused_parsers)
      end
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
    },
    event = "LazyFile",
    opts = {
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
        "jsonc",
        "just",
        "luadoc",
        "luap",
        "make",
        "printf",
        "regex",
        "yaml",
      },
      textobjects = {
        move = {
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
    "mrjones2014/smart-splits.nvim",
    build = "./kitty/install-kittens.bash",
    event = "VeryLazy",
    keys = {
      { "<M-h>", function() require("smart-splits").move_cursor_left() end, desc = "Left Window", mode = { "n", "t" } },
      {
        "<M-l>",
        function() require("smart-splits").move_cursor_right() end,
        desc = "Right window",
        mode = { "n", "t" },
      },
      {
        "<M-j>",
        function() require("smart-splits").move_cursor_down() end,
        desc = "Lower Window",
        mode = { "n", "t" },
      },
      { "<M-k>", function() require("smart-splits").move_cursor_up() end, desc = "Upper Window", mode = { "n", "t" } },
      { "<M-Left>", function() require("smart-splits").resize_left() end, desc = "Shift Left" },
      { "<M-Right>", function() require("smart-splits").resize_right() end, desc = "Shift Right" },
      { "<M-Down>", function() require("smart-splits").resize_down() end, desc = "Shift Down" },
      { "<M-Up>", function() require("smart-splits").resize_up() end, desc = "Shift Up" },
    },
  },
  {
    "echasnovski/mini.jump",
    keys = vim.iter({ "f", "F", "t", "T" }):map(function(m) return { m, mode = { "n", "x" } } end):totable(),
    opts = {},
  },
  {
    "folke/snacks.nvim",
    -- https://github.com/LazyVim/LazyVim {{{
    config = function(_, opts)
      local notify = vim.notify
      require("snacks").setup(opts)
      -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
      -- this is needed to have early notifications show up in noice history
      vim.notify = notify
    end,
    -- }}}
    init = function()
      vim.g.snacks_animate = false

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
        once = true,
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
      { "<Leader>pP", function() Snacks.profiler.pick() end, desc = "Check Profile Result" },
      { "<Leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<Leader>u/", function() Snacks.picker.notifications() end, desc = "Notifications" },
      { "<Leader>gf", function() Snacks.gitbrowse() end, mode = { "n", "x" }, desc = "Git Browse" },
      { "<Leader>fs", function() Snacks.scratch() end, desc = "Open Scratch Buffer" },
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
            { icon = " ", key = "f", desc = "Find File", action = "<Leader><Space>" },
            { icon = " ", key = "r", desc = "Recent Files", action = "<Leader>fr" },
            { icon = " ", key = "/", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
            { icon = " ", key = "c", desc = "Config", action = "<Leader>fc" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      image = { doc = { enabled = false } },
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
  {
    "tiagovla/scope.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "mikesmithgh/kitty-scrollback.nvim",
    event = "User KittyScrollbackLaunch",
    opts = {},
  },
}
