return {
  {
    "Wansmer/treesj",
    keys = {
      { "S", "<Cmd>TSJSplit<CR>", desc = "Split" },
      { "J", "<Cmd>TSJJoin<CR>", desc = "Join" },
    },
    opts = { use_default_keymaps = false },
  },
  {
    "echasnovski/mini.surround",
    keys = { { "s", mode = { "n", "x" } } },
    opts = { search_method = "cover_or_next" },
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
      { "gA", mode = { "n", "x" }, desc = "Align with Preview" },
    },
    opts = {},
  },
  {
    "dhruvasagar/vim-table-mode",
    config = function()
      vim.g.table_mode_corner = "|"
      vim.g.table_mode_disable_mappings = 1
    end,
    keys = { { "<Leader>ct", "<Cmd>TableModeToggle<CR>", desc = "Toggle Table Mode" } },
  },
  {
    "RRethy/nvim-treesitter-endwise",
    -- TODO: remove pin after #42 is merged
    build = "git pull origin refs/pull/42/head",
    commit = "8b34305ffc28bd75a22f5a0a9928ee726a85c9a6",
    event = "InsertEnter",
    main = "nvim-treesitter.configs",
    opts = { endwise = { enable = true } },
    pin = true,
  },
  -- Modified from https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/mini.lua {{{
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

        if o == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
          return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
        end

        if next ~= "" and next:match([=[[%w%%%'%[%"%.%`%$]]=]) then
          return o
        end

        local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
        for _, capture in ipairs(ok and captures or {}) do
          if vim.tbl_contains({ "string", "comment" }, capture.capture) then
            return o
          end
        end

        if next == c and c ~= o then
          local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
          local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
          if count_close > count_open then
            return o
          end
        end

        return open(pair, neigh_pattern)
      end

      local closeopen = pairs.closeopen
      pairs.closeopen = function(pair, neigh_pattern)
        if vim.fn.getcmdline() ~= "" then
          return closeopen(pair, neigh_pattern)
        end

        local o = pair:sub(1, 1)
        if vim.list_contains(MiniPairs.config.mappings[o].excluded_filetypes or {}, vim.bo.filetype) then
          return o
        end

        return closeopen(pair, neigh_pattern)
      end

      ---@param lhs string
      ---@param rhs string | fun(): string
      ---@param desc string
      local function map(lhs, rhs, desc)
        Dotfiles.map({ lhs, rhs, expr = true, mode = "i", replace_keycodes = false, desc = desc })
      end

      map("<C-h>", "v:lua.MiniPairs.bs()", "Backspace")
      map("<C-w>", 'v:lua.MiniPairs.bs("\23")', "Delete Word Before Cursor")
      map("<C-u>", 'v:lua.MiniPairs.bs("\21")', "Delete All Before Cursor")
      map("<C-j>", "v:lua.MiniPairs.cr()", "New Line")
    end,
    event = "InsertEnter",
    opts = {
      mappings = {
        [" "] = { action = "open", pair = "  ", neigh_pattern = "[%(%[{][%)%]}]" },
        ["'"] = { excluded_filetypes = { "rust" } },
      },
      modes = { command = true },
    },
  },
  -- }}}
}
