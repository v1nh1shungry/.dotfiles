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
    keys = { { "s", mode = { "n", "x" } } },
    opts = { search_method = "cover_or_next" },
  },
  {
    "Wansmer/sibling-swap.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = { use_default_keymaps = false },
    keys = {
      {
        "<C-l>",
        function()
          require("sibling-swap").swap_with_right()
        end,
        desc = "Swap with right",
      },
      {
        "<C-h>",
        function()
          require("sibling-swap").swap_with_left()
        end,
        desc = "Swap with left",
      },
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
        function()
          require("ssr").open()
        end,
        mode = { "n", "x" },
        desc = "Structural Search & Replace",
      },
    },
  },
  {
    "dhruvasagar/vim-table-mode",
    config = function()
      vim.g.table_mode_corner = "|"
      vim.g.table_mode_disable_mappings = 1
    end,
    keys = { { "<Leader>ct", "<Cmd>TableModeToggle<CR>", desc = "Table mode" } },
  },
  {
    "RRethy/nvim-treesitter-endwise",
    -- TODO: remove pin after #42 is merged
    build = "git pull origin refs/pull/42/head",
    commit = "8b34305ffc28bd75a22f5a0a9928ee726a85c9a6",
    event = Dotfiles.events.enter_insert,
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
            if vim.list_contains(opts.skip_ts, capture.capture) then
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
    event = Dotfiles.events.enter_insert,
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
