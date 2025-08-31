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
    "nvim-mini/mini.surround",
    keys = {
      { "gs", "", mode = { "n", "x" }, desc = "+surround" },
      { "gsa", mode = { "n", "x" }, desc = "Add Surrounding" },
      { "gsd", desc = "Delete Surrounding" },
      { "gsf", desc = "Find Right Surrounding" },
      { "gsF", desc = "Find Left Surrounding" },
      { "gsh", desc = "Highlight Surrounding" },
      { "gsr", desc = "Replace Surrounding" },
    },
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "",
      },
      search_method = "cover_or_next",
    },
  },
  {
    "nvim-mini/mini.align",
    keys = {
      { "ga", mode = { "n", "x" }, desc = "Align" },
      { "gA", mode = { "n", "x" }, desc = "Align with Preview" },
    },
    opts = {},
  },
  {
    "dhruvasagar/vim-table-mode",
    ft = "markdown",
    keys = { { "<Leader>t", "", desc = "+table-mode", ft = "markdown" } },
  },
  {
    "RRethy/nvim-treesitter-endwise",
    event = "LazyFile",
  },
  -- Modified from https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/mini.lua {{{
  {
    "nvim-mini/mini.pairs",
    config = function(_, opts)
      local pairs = require("mini.pairs")
      pairs.setup(opts)

      local open = pairs.open
      ---@diagnostic disable-next-line: duplicate-set-field
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

      local map = Dotfiles.map_with({ expr = true, mode = "i", replace_keycodes = false })
      map({ "<C-h>", "v:lua.MiniPairs.bs()", desc = "Backspace" })
      map({ "<C-w>", 'v:lua.MiniPairs.bs("\23")', desc = "Delete Word Before Cursor" })
      map({ "<C-u>", 'v:lua.MiniPairs.bs("\21")', desc = "Delete All Before Cursor" })
      map({ "<C-j>", "v:lua.MiniPairs.cr()", desc = "New Line" })
    end,
    -- NOTE: #1585
    event = "VeryLazy",
    opts = {
      mappings = { [" "] = { action = "open", pair = "  ", neigh_pattern = "[%(%[{][%)%]}]" } },
      modes = { command = true },
    },
  },
  -- }}}
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      { "<Leader>sg", "<Cmd>GrugFar<CR>", desc = "Search & Replace" },
      { "<Leader>sg", "<Cmd>GrugFarWithin<CR>", desc = "Search & Replace", mode = "x" },
    },
    opts = {},
  },
  {
    "Wansmer/sibling-swap.nvim",
    keys = {
      { "<C-h>", function() require("sibling-swap").swap_with_left() end, desc = "Swap with left" },
      { "<C-l>", function() require("sibling-swap").swap_with_right() end, desc = "Swap with right" },
    },
    opts = { use_default_keymaps = false },
  },
  {
    "ibhagwan/fzf-lua",
    config = function(_, opts)
      require("fzf-lua").setup(opts)
      vim.cmd("FzfLua register_ui_select")
    end,
    dependencies = {
      "nvim-mini/mini.icons",
      "folke/snacks.nvim",
    },
    keys = {
      { "<Leader><Space>", "<Cmd>FzfLua files<CR>", desc = "Files" },
      { "<Leader>h", "<Cmd>FzfLua helptags<CR>", desc = "Help Pages" },
      { "<Leader>/", "<Cmd>FzfLua live_grep_native<CR>", desc = "Live Grep" },
      { "<Leader>:", "<Cmd>FzfLua command_history<CR>", desc = "Command History" },
      { "<Leader>fr", "<Cmd>FzfLua oldfiles<CR>", desc = "Recent Files" },
      { "<Leader>sa", "<Cmd>FzfLua autocmds<CR>", desc = "Autocommands" },
      { "<Leader>sk", "<Cmd>FzfLua keymaps<CR>", desc = "Keymaps" },
      { "<Leader>s,", "<Cmd>FzfLua resume<CR>", desc = "Resume" },
      { "<Leader>sh", "<Cmd>FzfLua highlights<CR>", desc = "Highlight Groups" },
      { "<Leader>sm", "<Cmd>FzfLua manpages<CR>", desc = "Manpages" },
      { "<Leader>sx", "<Cmd>FzfLua diagnostics_document<CR>", desc = "Document Diagnostics" },
      { "<Leader>sX", "<Cmd>FzfLua diagnostics_workspace<CR>", desc = "Workspace Diagnostics" },
      { "<Leader>sq", "<Cmd>FzfLua quickfix<CR>", desc = "Quickfix List" },
      { "<Leader>sQ", "<Cmd>FzfLua quickfix_stack<CR>", desc = "Quickfix Stack" },
      { "<Leader>sl", "<Cmd>FzfLua loclist<CR>", desc = "Location List" },
      { "<Leader>sL", "<Cmd>FzfLua loclist_stack<CR>", desc = "Location Stack" },
      { "<Leader>sC", "<Cmd>FzfLua colorschemes<CR>", desc = "Colorschemes" },
      { "<Leader>s:", "<Cmd>FzfLua commands<CR>", desc = "Commands" },
      { "<Leader>sz", "<Cmd>FzfLua zoxide<CR>", desc = "Zoxide" },
      { "<Leader>gl", "<Cmd>FzfLua git_bcommits<CR>", desc = "Git Log (File)" },
      { "<Leader>gL", "<Cmd>FzfLua git_commits<CR>", desc = "Git Log" },
      { "<Leader>gh", "<Cmd>FzfLua git_hunks<CR>", desc = "Hunks" },
      { "<Leader>bb", "<Cmd>FzfLua buffers<CR>", desc = "Buffers" },
    },
    opts = {
      "ivy",
      files = {
        cwd_prompt = false,
      },
      fzf_colors = true,
      fzf_opts = {
        ["--cycle"] = true,
      },
      lsp = {
        code_actions = {
          previewer = "codeaction_native",
        },
      },
      keymap = {
        builtin = {
          ["<C-f>"] = "preview-page-down",
          ["<C-b>"] = "preview-page-up",
        },
        fzf = {
          ["ctrl-d"] = "half-page-down",
          ["ctrl-u"] = "half-page-up",
          ["ctrl-f"] = "preview-page-down",
          ["ctrl-b"] = "preview-page-up",
          ["ctrl-q"] = "select-all+accept",
          -- Not a real keymap. `--bind 'change:first'` to select the first item when query changes.
          ["change"] = "first",
        },
      },
      oldfiles = {
        cwd_only = true,
      },
    },
  },
}
