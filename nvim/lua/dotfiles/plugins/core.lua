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
    "nvim-mini/mini.ai",
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

      -- clean unused parsers
      local resolved_ensure_installed = require("nvim-treesitter.config").norm_languages(opts.ensure_installed)
      for _, parser in ipairs(require("nvim-treesitter").get_installed()) do
        if not vim.list_contains(resolved_ensure_installed, parser) then
          require("nvim-treesitter").uninstall(parser)
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          if not pcall(vim.treesitter.start) then
            return
          end

          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
    event = "LazyFile",
    opts = {
      ensure_installed = {
        "bash",
        "cmake",
        "c",
        "cpp",
        "diff",
        "doxygen",
        "fish",
        "gitcommit",
        "html_tags", -- bundled with nvim-treesitter
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
        "vim",
        "vimdoc",
      },
    },
    opts_extend = { "ensure_installed" },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    config = function(_, opts)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if not pcall(vim.treesitter.get_parser) then
            return
          end

          for direction, actions in pairs(opts.move) do
            local desc_prefix = direction:gsub("_", " ") .. " "
            desc_prefix = desc_prefix:sub(1, 1):upper() .. desc_prefix:sub(2)
            for key, textobject in pairs(actions) do
              Dotfiles.map({
                key,
                function()
                  if vim.wo.diff and key:find("[%]%[][cC]") then
                    vim.cmd("normal! " .. key)
                  else
                    require("nvim-treesitter-textobjects.move")[direction](textobject, "textobjects")
                  end
                end,
                buffer = args.buf,
                desc = desc_prefix .. textobject,
                mode = { "n", "x", "o" },
              })
            end
          end
        end,
      })
    end,
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "LazyFile",
    opts = {
      move = {
        goto_next_start = { ["]a"] = "@parameter.inner", ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
        goto_previous_start = { ["[a"] = "@parameter.inner", ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
      },
    },
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
    "nvim-mini/mini.operators",
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
    "folke/flash.nvim",
    keys = {
      { "f", mode = { "n", "x", "o" } },
      { "F", mode = { "n", "x", "o" } },
      { "t", mode = { "n", "x", "o" } },
      { "T", mode = { "n", "x", "o" } },
      { ",", mode = { "n", "x", "o" } },
      { ";", mode = { "n", "x", "o" } },
      { "s", function() require("flash").jump() end, desc = "Flash", mode = { "n", "x", "o" } },
      { "r", function() require("flash").remote() end, desc = "Remote Flash", mode = "o" },
    },
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
      { "<C-q>", function() Snacks.bufdelete() end, desc = "Close Buffer" },
      { "<M-=>", function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "Terminal" },
      { "<C-w>z", function() Snacks.zen.zoom() end, desc = "Zoom" },
      { "<Leader>ut", function() Snacks.picker.undo() end, desc = "Undotree" },
      { "<Leader>pP", function() Snacks.profiler.pick() end, desc = "Check Profile Result" },
      { "<Leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<Leader>u/", function() Snacks.picker.notifications() end, desc = "Notifications" },
      { "<Leader>gf", function() Snacks.gitbrowse() end, mode = { "n", "x" }, desc = "Git Browse" },
      { "<Leader>fs", function() Snacks.scratch() end, desc = "Open Scratch Buffer" },
      { "<Leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<Leader>bo", function() Snacks.bufdelete.other() end, desc = "Only" },
    },
    opts = {
      bigfile = { enabled = true },
      image = { doc = { enabled = false } },
      -- NOTE: A bit buggy now. Use indent-blankline.nvim instead for now.
      -- indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      -- NOTE: A bit buggy now. Use fzf-lua instead for now.
      -- TODO: Completely remove picker dependencies.
      picker = {
        layout = { preset = "ivy" },
        previewers = { git = { native = true } },
        ui_select = false,
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
  {
    "m4xshen/hardtime.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
