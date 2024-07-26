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
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
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
      { "<Leader>fr", "<Cmd>Telescope oldfiles cwd_only=true<CR>", desc = "Recent files" },
      { "<Leader>/", "<Cmd>Telescope live_grep<CR>", desc = "Live grep" },
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
          layout_config = { bottom_pane = { height = 0.4 } },
          mappings = {
            i = { ["<C-s>"] = flash },
            n = { s = flash },
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
    },
    lazy = vim.fn.argv()[1] ~= "leetcode.nvim",
    opts = {
      cn = { enabled = true },
      injector = { cpp = { before = { "#include <bits/stdc++.h>", "using namespace std;" } } },
    },
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
  {
    "stevearc/profile.nvim",
    config = function()
      local should_profile = os.getenv("NVIM_PROFILE")
      if should_profile then
        require("profile").instrument_autocmds()
        if should_profile:lower():match("^start") then
          require("profile").start("*")
        else
          require("profile").instrument("*")
        end
      end
      local function toggle_profile()
        local prof = require("profile")
        if prof.is_recording() then
          prof.stop()
          vim.ui.input(
            { prompt = "Save profile to:", completion = "file", default = "profile.json" },
            function(filename)
              if filename then
                prof.export(filename)
                vim.notify(string.format("Wrote %s", filename))
              end
            end
          )
        else
          prof.start("*")
        end
      end
      map({ "<Leader>up", toggle_profile, desc = "Toggle profile" })
    end,
    lazy = not os.getenv("NVIM_PROFILE"),
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = { { "<Leader>s/", "<Cmd>GrugFar<CR>", desc = "Grep" } },
    opts = {},
  },
  {
    "AndrewRadev/linediff.vim",
    cmd = "Linediff",
    config = function()
      vim.g.linediff_buffer_type = "scratch"
      vim.g.linediff_modify_statusline = 0
    end,
  },
}
