local events = require("dotfiles.utils.events")
local map = require("dotfiles.utils.keymap")

return {
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("live_grep_args")
      telescope.load_extension("frecency")
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-frecency.nvim",
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(event)
          map({
            "zf",
            function()
              vim.cmd("cclose")
              vim.cmd("Telescope quickfix")
            end,
            buffer = event.buf,
            desc = "Enter fzf mode",
          })
        end,
        pattern = "qf",
        group = vim.api.nvim_create_augroup("quickfix_to_telescope_keymap", {}),
      })
    end,
    keys = {
      { "<Leader>h", "<Cmd>Telescope help_tags<CR>", desc = "Help pages" },
      { "<Leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<Leader>fr", "<Cmd>Telescope frecency<CR>", desc = "Recent files" },
      { "<Leader>/", "<Cmd>Telescope live_grep_args<CR>", desc = "Live grep" },
      { "<Leader>sa", "<Cmd>Telescope autocommands<CR>", desc = "Autocommands" },
      { "<Leader>sk", "<Cmd>Telescope keymaps<CR>", desc = "Keymaps" },
      { "<Leader>s,", "<Cmd>Telescope resume<CR>", desc = "Last search" },
      { "<Leader>sh", "<Cmd>Telescope highlights<CR>", desc = "Highlight groups" },
      { "<Leader>sm", "<Cmd>Telescope man_pages<CR>", desc = "Manpages" },
      { "<Leader>sx", "<Cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
      { "<Leader>sq", "<Cmd>Telescope quickfix<CR>", desc = "Quickfix" },
    },
    opts = function()
      local function flash(prompt_bufnr)
        require("flash").jump({
          pattern = "^",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win) return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults" end,
            },
          },
          action = function(match)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
          end,
        })
      end

      return {
        defaults = {
          prompt_prefix = "🔎 ",
          selection_caret = "➤ ",
          layout_strategy = "bottom_pane",
          sorting_strategy = "ascending",
          layout_config = {
            bottom_pane = {
              height = 0.4,
            },
          },
          mappings = {
            i = { ["<C-s>"] = flash },
            n = { s = flash },
          },
        },
        extensions = {
          frecency = {
            default_workspace = "CWD",
            workspace_scan_cmd = "LUA",
            show_unindexed = false,
          },
        },
      }
    end,
  },
  {
    "kawre/leetcode.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = vim.fn.argv()[1] ~= "leetcode.nvim",
    opts = {
      cn = { enabled = true },
      injector = { cpp = { before = { "#include <bits/stdc++.h>", "using namespace std;" } } },
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<Leader>sg",
        function() require("telescope").extensions.refactoring.refactors() end,
        desc = "Refactoring",
        mode = { "n", "x" },
      },
    },
    opts = {},
  },
  {
    "v1nh1shungry/cppman.nvim",
    keys = {
      {
        "<Leader>sc",
        function() require("cppman").search() end,
        desc = "Cppman",
      },
    },
    opts = {},
  },
  {
    "v1nh1shungry/biquge.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      {
        "folke/which-key.nvim",
        opts = function(_, opts)
          opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
            ["<Leader>b"] = { name = "+biquge" },
          })
        end,
      },
      {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts) vim.list_extend(opts.ensure_installed, { "html" }) end,
      },
    },
    keys = {
      {
        "<Leader>b/",
        function() require("biquge").search() end,
        desc = "Search",
      },
      {
        "<Leader>bb",
        function() require("biquge").toggle() end,
        desc = "Toggle",
      },
      {
        "<Leader>bt",
        function() require("biquge").toc() end,
        desc = "Table of contents",
      },
      {
        "<Leader>bn",
        function() require("biquge").next_chap() end,
        desc = "Next chapter",
      },
      {
        "<Leader>bp",
        function() require("biquge").prev_chap() end,
        desc = "Previous chapter",
      },
      {
        "<Leader>bs",
        function() require("biquge").star() end,
        desc = "Star current book",
      },
      {
        "<Leader>bl",
        function() require("biquge").bookshelf() end,
        desc = "Bookshelf",
      },
      {
        "<M-d>",
        function() require("biquge").scroll(1) end,
        desc = "Scroll down",
      },
      {
        "<M-u>",
        function() require("biquge").scroll(-1) end,
        desc = "Scroll up",
      },
    },
    opts = { height = 5 },
  },
  {
    "nvim-telescope/telescope-symbols.nvim",
    dependencies = "nvim-telescope/telescope.nvim",
    keys = { { "<Leader>se", "<Cmd>Telescope symbols<CR>", desc = "Emoji" } },
  },
  {
    "debugloop/telescope-undo.nvim",
    config = function() require("telescope").load_extension("undo") end,
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    keys = { { "<Leader>fu", "<Cmd>Telescope undo<CR>", desc = "Undotree" } },
  },
  {
    "rafcamlet/nvim-luapad",
    cmd = "Luapad",
    opts = {
      on_init = function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.bo[bufnr].buflisted = false
        require("dotfiles.utils.keymap")({ "q", "<C-w>q", desc = "Quit", buffer = bufnr })
      end,
    },
  },
  {
    "v1nh1shungry/lyricify.nvim",
    keys = { { "<Leader>us", function() require("lyricify").toggle() end, desc = "Spotify" } },
    opts = {},
  },
  {
    "olimorris/persisted.nvim",
    cmd = "SessionLoad",
    config = function()
      require("persisted").setup({
        use_git_branch = true,
        should_autosave = function()
          local bufs = vim.tbl_filter(function(b)
            if vim.bo[b].buftype ~= "" then
              return false
            end
            if vim.bo[b].buflisted == false then
              return false
            end
            if vim.tbl_contains({ "gitcommit", "gitrebase" }, vim.bo[b].buftype) then
              return false
            end
            return vim.api.nvim_buf_get_name(b) ~= ""
          end, vim.api.nvim_list_bufs())
          return #bufs ~= 0
        end,
      })

      require("telescope").load_extension("persisted")

      vim.api.nvim_create_autocmd("User", {
        command = "ScopeSaveState",
        pattern = "PersistedSavePre",
      })
      vim.api.nvim_create_autocmd("User", {
        command = "ScopeLoadState",
        pattern = "PersistedLoadPost",
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "PersistedTelescopeLoadPre",
        callback = function(_)
          require("persisted").save({ session = vim.g.persisted_loaded_session })
          vim.api.nvim_input("<ESC>:%bd!<CR>")
        end,
      })
    end,
    dependencies = "nvim-telescope/telescope.nvim",
    event = events.enter_buffer,
    keys = {
      { "<Leader>qs", "<Cmd>SessionLoad<CR>", desc = "Restore current session" },
      { "<Leader>ql", "<Cmd>SessionLoadLast<CR>", desc = "Restore last session" },
      { "<Leader>q/", "<Cmd>Telescope persisted<CR>", desc = "Search sessions" },
      {
        "<Leader>qd",
        function()
          vim.cmd("SessionStop")
          vim.cmd("qa!")
        end,
        desc = "Quit without saving session",
      },
      { "<Leader>qc", "<Cmd>SessionDelete<CR>", desc = "Delete current session" },
    },
  },
  {
    "gbprod/yanky.nvim",
    keys = {
      {
        "<leader>sY",
        function() require("telescope").extensions.yank_history.yank_history({}) end,
        desc = "Open Yank History",
      },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
      { "[y", "<Plug>(YankyPreviousEntry)", desc = "Select previous entry through yank history" },
      { "]y", "<Plug>(YankyNextEntry)", desc = "Select next entry through yank history" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
      { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
      { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
    },
    opts = {},
  },
  {
    "NStefan002/screenkey.nvim",
    keys = { { "<Leader>uk", "<Cmd>Screenkey<CR>", desc = "Screen key" } },
  },
}