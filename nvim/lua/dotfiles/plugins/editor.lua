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
    keys = {
      { "gsa", mode = { "n", "x" }, desc = "Add Surrounding" },
      { "gsd", desc = "Delete Surrounding" },
      { "gsf", desc = "Find Right Surrounding" },
      { "gsF", desc = "Find Left Surrounding" },
      { "gsh", desc = "Highlight Surrounding" },
      { "gsr", desc = "Replace Surrounding" },
      { "gsn", desc = "Update `MiniSurround.config.n_lines`" },
    },
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
      search_method = "cover_or_next",
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
    event = "InsertEnter",
  },
  -- Modified from https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/mini.lua {{{
  {
    "echasnovski/mini.pairs",
    config = function(_, opts)
      local pairs = require("mini.pairs")
      pairs.setup(opts)

      local open = pairs.open
      ---@diagnostic disable-next-line: duplicate-set-field
      pairs.open = function(pair, neigh_pattern)
        if vim.fn.getcmdline() ~= "" then return open(pair, neigh_pattern) end

        local o, c = pair:sub(1, 1), pair:sub(2, 2)
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local next = line:sub(cursor[2] + 1, cursor[2] + 1)
        local before = line:sub(1, cursor[2])

        if o == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
          return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
        end

        if next ~= "" and next:match([=[[%w%%%'%[%"%.%`%$]]=]) then return o end

        local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
        for _, capture in ipairs(ok and captures or {}) do
          if vim.tbl_contains({ "string", "comment" }, capture.capture) then return o end
        end

        if next == c and c ~= o then
          local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
          local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
          if count_close > count_open then return o end
        end

        return open(pair, neigh_pattern)
      end

      local closeopen = pairs.closeopen
      ---@diagnostic disable-next-line: duplicate-set-field
      pairs.closeopen = function(pair, neigh_pattern)
        if vim.fn.getcmdline() ~= "" then return closeopen(pair, neigh_pattern) end

        local o = pair:sub(1, 1)
        if MiniPairs.config.mappings[o].condition and not MiniPairs.config.mappings[o].condition() then return o end

        return closeopen(pair, neigh_pattern)
      end

      local map = Dotfiles.map_with({ expr = true, mode = "i", replace_keycodes = false })
      map({ "<C-h>", "v:lua.MiniPairs.bs()", desc = "Backspace" })
      map({ "<C-w>", 'v:lua.MiniPairs.bs("\23")', desc = "Delete Word Before Cursor" })
      map({ "<C-u>", 'v:lua.MiniPairs.bs("\21")', desc = "Delete All Before Cursor" })
      map({ "<C-j>", "v:lua.MiniPairs.cr()", desc = "New Line" })
    end,
    -- NOTE: #1585
    event = "VeryLazy",
    opts = {
      mappings = {
        [" "] = { action = "open", pair = "  ", neigh_pattern = "[%(%[{][%)%]}]" },
        ["'"] = { condition = function() return not vim.list_contains({ "rust" }, vim.bo.filetype) end },
      },
      modes = { command = true },
    },
  },
  -- }}}
  {
    "cshuaimin/ssr.nvim",
    keys = {
      { "<Leader>sr", function() require("ssr").open() end, mode = { "n", "x" }, desc = "Structural Search & Replace" },
    },
  },
}
