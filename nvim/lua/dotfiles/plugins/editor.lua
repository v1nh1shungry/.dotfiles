local events = require("dotfiles.utils.events")
local map = require("dotfiles.utils.keymap")

return {
  {
    "Wansmer/treesj",
    keys = {
      { "S", "<Cmd>TSJSplit<CR>", desc = "Split line" },
      { "J", "<Cmd>TSJJoin<CR>", desc = "Join line" },
    },
    opts = { use_default_keymaps = false },
  },
  {
    "echasnovski/mini.surround",
    config = function(_, opts)
      require("mini.surround").setup(opts)
      vim.keymap.del("x", "ys")
    end,
    keys = function(_, keys)
      local mappings = {
        { "ys", desc = "Add surrounding" },
        { "ds", desc = "Delete surrounding" },
        { "cs", desc = "Replace surrounding" },
        { "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], mode = "x", desc = "Add surrounding" },
        { "yss", "ys_", remap = true, desc = "Add surrounding for line" },
      }
      mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        update_n_lines = "",
      },
      search_method = "cover_or_next",
    },
  },
  {
    "Wansmer/sibling-swap.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = { use_default_keymaps = false },
    keys = {
      { "<C-l>", function() require("sibling-swap").swap_with_right() end, desc = "Swap with right" },
      { "<C-h>", function() require("sibling-swap").swap_with_left() end, desc = "Swap with left" },
    },
  },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {
      lang = {
        c = { "// %s", "/* %s */" },
        cpp = { "// %s", "/* %s */" },
      },
    },
  },
  {
    "danymat/neogen",
    opts = { snippet_engine = "nvim" },
    keys = { { "<Leader>cg", "<Cmd>Neogen<CR>", desc = "Generate document comment" } },
  },
  {
    "echasnovski/mini.align",
    keys = {
      { "ga", mode = { "n", "x" }, desc = "Align" },
      { "gA", mode = { "n", "x" }, desc = "Align with preview" },
    },
    opts = {},
  },
  {
    "cshuaimin/ssr.nvim",
    keys = {
      {
        "<Leader>sr",
        function() require("ssr").open() end,
        mode = { "n", "x" },
        desc = "Structural replace",
      },
    },
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-telescope/telescope.nvim" },
    keys = "<Leader>cc",
    opts = { prefix = "<Leader>cc" },
  },
  {
    "dhruvasagar/vim-table-mode",
    config = function()
      vim.g.table_mode_corner = "|"
      vim.g.table_mode_disable_mappings = 1
    end,
    keys = { { "<Leader>ct", "<Cmd>TableModeToggle<CR>", desc = "Table mode" } },
  },
  -- https://www.lazyvim.org/extras/editor/dial {{{
  {
    "monaqa/dial.nvim",
    config = function(_, opts)
      local function dial(increment, g)
        local mode = vim.fn.mode(true)
        local is_visual = mode == "v" or mode == "V" or mode == "\22"
        local func = (increment and "inc" or "dec") .. (g and "_g" or "_") .. (is_visual and "visual" or "normal")
        local group = opts[vim.bo.filetype] and vim.bo.filetype or "default"
        return require("dial.map")[func](group)
      end

      require("dial.config").augends:register_group(opts)

      map({ "<C-a>", function() return dial(true) end, expr = true, mode = { "n", "v" } })
      map({ "<C-x>", function() return dial(false) end, expr = true, mode = { "n", "v" } })
      map({ "g<C-a>", function() return dial(true, true) end, expr = true, mode = { "n", "v" } })
      map({ "g<C-x>", function() return dial(false, true) end, expr = true, mode = { "n", "v" } })
    end,
    keys = {
      { "<C-a>", expr = true, mode = { "n", "v" } },
      { "<C-x>", expr = true, mode = { "n", "v" } },
      { "g<C-a>", expr = true, mode = { "n", "v" } },
      { "g<C-x>", expr = true, mode = { "n", "v" } },
    },
    opts = function()
      local augend = require("dial.augend")

      local and_or_alias = augend.constant.new({ elements = { "and", "or" } })

      local opts = {
        default = {
          augend.integer.alias.decimal,
          augend.constant.alias.bool,
        },
        markdown = {
          augend.misc.alias.markdown_header,
          augend.constant.new({
            elements = {
              "first",
              "second",
              "third",
              "fourth",
              "fifth",
              "sixth",
              "seventh",
              "eighth",
              "ninth",
              "tenth",
            },
            preserve_case = true,
          }),
          augend.constant.new({
            elements = {
              "Monday",
              "Tuesday",
              "Wednesday",
              "Thursday",
              "Friday",
              "Saturday",
              "Sunday",
            },
          }),
          augend.constant.new({
            elements = {
              "January",
              "February",
              "March",
              "April",
              "May",
              "June",
              "July",
              "August",
              "September",
              "October",
              "November",
              "December",
            },
          }),
        },
        json = {
          augend.integer.alias.decimal,
          augend.semver.alias.semver,
        },
        cmake = {
          augend.integer.alias.decimal,
          augend.semver.alias.semver,
          augend.constant.new({
            elements = { "ON", "OFF" },
            preserve_case = true,
          }),
        },
      }

      opts.c = vim.list_extend(vim.deepcopy(opts.default), {
        augend.integer.alias.hex,
        augend.constant.new({ elements = { "&&", "||" } }),
        augend.constant.new({ elements = { "==", "!=" } }),
        and_or_alias,
      })

      opts.cpp = vim.list_extend(vim.deepcopy(opts.c), {
        augend.constant.new({ elements = { "first", "second" } }),
        augend.constant.new({ elements = { "public", "protected", "private" } }),
        augend.constant.new({ elements = { "static_cast", "dynamic_cast", "reinterpret_cast", "const_cast" } }),
        augend.constant.new({ elements = { "int8_t", "int16_t", "int32_t", "int64_t" } }),
        augend.constant.new({ elements = { "uint8_t", "uint16_t", "uint32_t", "uint64_t" } }),
      })

      opts.lua = vim.list_extend(vim.deepcopy(opts.default), { and_or_alias })

      return opts
    end,
  },
  -- }}}
  {
    "RRethy/nvim-treesitter-endwise",
    -- TODO: remove pin after #42 is merged
    build = "git pull origin refs/pull/42/head",
    commit = "8b34305ffc28bd75a22f5a0a9928ee726a85c9a6",
    event = events.enter_insert,
    main = "nvim-treesitter.configs",
    opts = { endwise = { enable = true } },
    pin = true,
  },
  -- LazyVim {{{
  {
    "echasnovski/mini.pairs",
    config = function(_, opts)
      local pairs = require("mini.pairs")
      pairs.setup(opts)
      local open = pairs.open
      pairs.open = function(pair, neigh_pattern)
        if vim.fn.getcmdline() ~= "" then
          return open(pair, neigh_pattern)
        end
        local o, c = pair:sub(1, 1), pair:sub(2, 2)
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local next = line:sub(cursor[2] + 1, cursor[2] + 1)
        local before = line:sub(1, cursor[2])
        if opts.markdown and o == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
          return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
        end
        if opts.skip_next and next ~= "" and next:match(opts.skip_next) then
          return o
        end
        if opts.skip_ts and #opts.skip_ts > 0 then
          local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
          for _, capture in ipairs(ok and captures or {}) do
            if vim.tbl_contains(opts.skip_ts, capture.capture) then
              return o
            end
          end
        end
        if opts.skip_unbalanced and next == c and c ~= o then
          local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
          local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
          if count_close > count_open then
            return o
          end
        end
        return open(pair, neigh_pattern)
      end
    end,
    event = events.enter_insert,
    opts = {
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    },
  },
  -- }}}
}
