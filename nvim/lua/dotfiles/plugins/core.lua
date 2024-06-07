local events = require("dotfiles.utils.events")

return {
  {
    "andymass/vim-matchup",
    config = function() vim.g.matchup_matchparen_offscreen = { method = "" } end,
    event = events.enter_buffer,
  },
  {
    "tpope/vim-sleuth",
    event = events.enter_buffer,
  },
  {
    "echasnovski/mini.ai",
    dependencies = {
      {
        "folke/which-key.nvim",
        config = function()
          local i = {
            [" "] = "Whitespace",
            ['"'] = 'Balanced "',
            ["'"] = "Balanced '",
            ["`"] = "Balanced `",
            ["("] = "Balanced (",
            [")"] = "Balanced ) including white-space",
            [">"] = "Balanced > including white-space",
            ["<lt>"] = "Balanced <",
            ["]"] = "Balanced ] including white-space",
            ["["] = "Balanced [",
            ["}"] = "Balanced } including white-space",
            ["{"] = "Balanced {",
            ["?"] = "User Prompt",
            _ = "Underscore",
            a = "Argument",
            b = "Balanced ), ], }",
            c = "Class",
            d = "Digit(s)",
            f = "Function",
            g = "Entire file",
            i = "Indent",
            o = "Block, conditional, loop",
            q = "Quote `, \", '",
            t = "Tag",
            u = "Use/call function & method",
            U = "Use/call without dot in name",
          }
          local a = vim.deepcopy(i)
          for k, v in pairs(a) do
            a[k] = v:gsub(" including.*", "")
          end
          local ic = vim.deepcopy(i)
          local ac = vim.deepcopy(a)
          for key, name in pairs({ n = "Next", l = "Last" }) do
            i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
            a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
          end
          require("which-key").register({
            mode = { "o", "x" },
            i = i,
            a = a,
          })
        end,
        optional = true,
      },
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
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = events.enter_buffer,
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "cuda",
        "diff",
        "doxygen",
        "fish",
        "git_rebase",
        "gitcommit",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
      },
      highlight = { enable = true, additional_vim_regex_highlighting = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-Space>",
          node_incremental = "<C-Space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      indent = { enable = true },
      matchup = { enable = true },
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
  },
  {
    "Wansmer/treesj",
    keys = {
      { "S", "<Cmd>TSJSplit<CR>", desc = "Split line" },
      { "J", "<Cmd>TSJJoin<CR>", desc = "Join line" },
    },
    opts = { use_default_keymaps = false },
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
    "echasnovski/mini.surround",
    keys = function(_, keys)
      local mappings = {
        { "sa", desc = "Add Surrounding", mode = { "n", "v" } },
        { "sd", desc = "Delete Surrounding" },
        { "sf", desc = "Find Right Surrounding" },
        { "sF", desc = "Find Left Surrounding" },
        { "sh", desc = "Highlight Surrounding" },
        { "sr", desc = "Replace Surrounding" },
        { "sn", desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {},
  },
  {
    "mg979/vim-visual-multi",
    config = function()
      vim.g.VM_silent_exit = true
      vim.g.VM_set_statusline = 0
      vim.g.VM_quit_after_leaving_insert_mode = true
      vim.g.VM_show_warnings = 0
    end,
    keys = { { "<C-n>", mode = { "n", "v" }, desc = "Multi cursors" } },
  },
  {
    "altermo/ultimate-autopair.nvim",
    event = events.enter_insert,
    opts = {},
  },
  {
    "LunarVim/bigfile.nvim",
    event = events.enter_buffer,
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
    "echasnovski/mini.bufremove",
    keys = { { "<C-q>", function() require("mini.bufremove").delete() end, desc = "Close buffer" } },
    opts = {},
  },
  {
    "RRethy/nvim-treesitter-endwise",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "InsertEnter",
    main = "nvim-treesitter.configs",
    opts = { endwise = { enable = true } },
  },
  {
    "chrisgrieser/nvim-recorder",
    opts = { mapping = { switchSlot = "<M-q>" } },
    keys = {
      "q",
      "Q",
      "<M-q>",
      { "cq", desc = "Edit macro" },
      { "dq", desc = "Delete all macros" },
      { "yq", desc = "Yank macro" },
    },
  },
  {
    "Wansmer/sibling-swap.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      keymaps = {
        ["<C-l>"] = "swap_with_right",
        ["<C-h>"] = "swap_with_left",
      },
    },
    keys = {
      { "<C-l>", desc = "Swap with right" },
      { "<C-h>", desc = "Swap with left" },
    },
  },
  {
    "tzachar/highlight-undo.nvim",
    keys = { "u", "<C-r>" },
    opts = {
      undo = { hlgroup = "IncSearch" },
      redo = { hlgroup = "IncSearch" },
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
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
