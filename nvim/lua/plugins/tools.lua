local events = require("utils.events")
local map = require("utils.keymap")

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = "nvim-lua/plenary.nvim",
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

      local open_with_trouble = require("trouble.sources.telescope").open

      return {
        defaults = {
          prompt_prefix = "🔎 ",
          selection_caret = "➤ ",
          layout_strategy = "bottom_pane",
          layout_config = {
            bottom_pane = {
              height = 0.4,
              preview_cutoff = 100,
              prompt_position = "bottom",
            },
          },
          mappings = {
            i = {
              ["<C-t>"] = open_with_trouble,
              ["<M-t>"] = open_with_trouble,
              ["<C-s>"] = flash,
            },
            n = { s = flash },
          },
        },
      }
    end,
  },
  {
    "krady21/compiler-explorer.nvim",
    cmd = { "CECompile", "CECompileLive" },
    dependencies = "stevearc/dressing.nvim",
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
    "akinsho/git-conflict.nvim",
    config = function(_, opts)
      require("git-conflict").setup(opts)
      vim.api.nvim_create_autocmd("User", {
        callback = function(args)
          local map_local = function(key)
            key.buffer = args.buf
            map(key)
          end
          map_local({ "<Leader>gxo", "<Plug>(git-conflict-ours)", desc = "Choose ours" })
          map_local({ "<Leader>gxt", "<Plug>(git-conflict-theirs)", desc = "Choose theirs" })
          map_local({ "<Leader>gxb", "<Plug>(git-conflict-both)", desc = "Choose both" })
          map_local({ "<Leader>gx0", "<Plug>(git-conflict-none)", desc = "Choose none" })
        end,
        pattern = "GitConflictDetected",
      })
    end,
    event = events.enter_buffer,
    opts = { default_mappings = false },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewFileHistory", "DiffviewOpen" },
    keys = { { "<Leader>gD", "<Cmd>DiffviewOpen<CR>", desc = "Open git diff pane" } },
  },
  {
    "Civitasv/cmake-tools.nvim",
    ft = "cmake",
    init = function()
      local loaded = false
      local function check()
        local cwd = vim.uv.cwd()
        if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
          require("lazy").load({ plugins = { "cmake-tools.nvim" } })
          loaded = true
        end
      end
      check()
      vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
          if not loaded then
            check()
          end
        end,
      })
    end,
    keys = {
      { "<Leader>mg", "<Cmd>CMakeGenerate<CR>", desc = "Configure" },
      { "<Leader>mb", "<Cmd>CMakeBuild<CR>", desc = "Build" },
      { "<Leader>mr", "<Cmd>CMakeRun<CR>", desc = "Run executable" },
      { "<Leader>md", "<Cmd>CMakeDebug<CR>", desc = "Debug" },
      { "<Leader>ma", ":CMakeLaunchArgs ", desc = "Set launch arguments" },
      { "<Leader>ms", "<Cmd>CMakeTargetSettings<CR>", desc = "Summary" },
      { "<Leader>mc", "<Cmd>CMakeClean<CR>", desc = "Clean" },
    },
    opts = {
      cmake_generate_options = {
        "-G",
        "Ninja",
        "-DCMAKE_EXPORT_COMPILE_COMMANDS=On",
        "-DCMAKE_CXX_COMPILER_LAUNCHER=ccache",
      },
      cmake_build_directory = "build",
      cmake_soft_link_compile_commands = false,
      cmake_runner = { name = "toggleterm", opts = { direction = "horizontal" } },
    },
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = "nvim-telescope/telescope.nvim",
    keys = "<Leader>cc",
    opts = { prefix = "<Leader>cc" },
  },
  {
    "folke/flash.nvim",
    keys = {
      "/",
      "?",
      "f",
      "F",
      "t",
      "T",
      ",",
      ";",
      {
        "gs",
        function() require("flash").jump() end,
        desc = "Flash",
      },
      {
        "gt",
        function() require("flash").treesitter() end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        function() require("flash").remote() end,
        mode = "o",
        desc = "Remote Flash",
      },
      {
        "R",
        function() require("flash").treesitter_search() end,
        mode = { "o", "x" },
        desc = "Treesitter search",
      },
    },
    opts = {
      modes = { char = { multi_line = false, highlight = { backdrop = false } } },
      prompt = { enabled = false },
    },
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
    "gabrielpoca/replacer.nvim",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          map({
            "<Leader>xr",
            function() require("replacer").run() end,
            desc = "Quickfix replacer",
            buffer = args.buf,
          })
        end,
        pattern = "qf",
      })
    end,
    ft = "qf",
  },
  {
    "ThePrimeagen/refactoring.nvim",
    cmd = "Refactor",
    keys = {
      {
        "<Leader>sR",
        function() require("refactoring").select_refactor() end,
        desc = "Refactoring",
        mode = { "n", "x" },
      },
    },
    opts = {},
  },
  {
    "dhruvasagar/vim-table-mode",
    config = function()
      vim.g.table_mode_corner = "|"
      vim.g.table_mode_disable_mappings = 1
    end,
    keys = { { "<Leader>ft", "<Cmd>TableModeToggle<CR>", desc = "Table mode" } },
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
    dependencies = "nvim-telescope/telescope.nvim",
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
        desc = "TOC",
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
    "v1nh1shungry/cppinsights.nvim",
    cmd = "CppInsights",
    opts = {
      standard = "cpp2c",
      more_transformations = {
        ["edu-show-coroutines"] = true,
        ["use-libcpp"] = true,
      },
    },
  },
  {
    "chrisgrieser/nvim-tinygit",
    ft = { "gitcommit", "git_rebase" },
    keys = {
      { "<Leader>gc", function() require("tinygit").smartCommit() end, desc = "Commit" },
      { "<Leader>gP", function() require("tinygit").push({}) end, desc = "Push" },
      { "<Leader>ga", function() require("tinygit").amendNoEdit() end, desc = "Amend" },
      { "<Leader>gu", function() require("tinygit").undoLastCommitOrAmend() end, desc = "Undo last commit" },
      { "<Leader>gF", function() require("tinygit").searchFileHistory() end, desc = "Search file history" },
      { "<Leader>gf", function() require("tinygit").functionHistory() end, desc = "Search function history" },
    },
  },
  {
    "debugloop/telescope-undo.nvim",
    config = function() require("telescope").load_extension("undo") end,
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    keys = { { "<Leader>fu", "<Cmd>Telescope undo<CR>", desc = "Undotree" } },
  },
}
