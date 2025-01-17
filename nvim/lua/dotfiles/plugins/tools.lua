return {
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S . -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/telescope.lua {{{
        config = function(plugin)
          Snacks.util.on_module("telescope", function()
            local ok, err = pcall(require("telescope").load_extension, "fzf")
            if not ok then
              local lib = plugin.dir .. "/build/libfzf.so"
              if not vim.uv.fs_stat(lib) then
                Snacks.notify.warn("`telescope-fzf-native.nvim` not built. Rebuilding...")
                require("lazy").build({ plugins = { plugin }, show = false }):wait(function()
                  Snacks.notify.info("Rebuilding `telescope-fzf-native.nvim` done.\nPlease restart Neovim.")
                end)
              else
                Snacks.notify.error("Failed to load `telescope-fzf-native.nvim`:\n" .. err)
              end
            end
          end)
        end,
        -- }}}
      },
    },
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        layout_strategy = "bottom_pane",
        layout_config = { bottom_pane = { height = 0.4 } },
        sorting_strategy = "ascending",
        get_selection_window = function()
          require("edgy").goto_main()
          return 0
        end,
      },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = { { "<Leader>s/", "<Cmd>GrugFar<CR>", desc = "Grep" } },
    opts = {},
  },
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    keys = {
      {
        "<CR>",
        function()
          require("kulala").run()
        end,
        desc = "Send request",
        ft = "http",
      },
      {
        "]r",
        function()
          require("kulala").jump_next()
        end,
        desc = "Jump to next request",
        ft = "http",
      },
      {
        "[r",
        function()
          require("kulala").jump_prev()
        end,
        desc = "Jump to previvous request",
        ft = "http",
      },
      {
        "yr",
        function()
          require("kulala").copy()
        end,
        desc = "Copy as curl command",
        ft = "http",
      },
      {
        "<Tab>",
        function()
          require("kulala").toggle_view()
        end,
        desc = "Toggle headers/body",
        ft = "http",
      },
      {
        "<S-Tab>",
        function()
          require("kulala").show_stats()
        end,
        desc = "Show request stats",
        ft = "http",
      },
      {
        "<Leader>ur",
        function()
          Snacks.scratch.open({
            name = "Kulala Scratchpad",
            ft = "http",
          })
        end,
        desc = "Open kulala scratchpad",
      },
    },
    opts = { display_mode = "float" },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = "DBUI",
    dependencies = "tpope/vim-dadbod",
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "v1nh1shungry/cppman.nvim",
    cmd = "Cppman",
    enabled = vim.fn.executable("cppman") == 1,
    keys = { { "<Leader>sc", "<Cmd>Cppman<CR>", desc = "Cppman" } },
  },
}
