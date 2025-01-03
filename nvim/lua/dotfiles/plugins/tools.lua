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
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
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
      { "<Leader>sb", "<Cmd>Telescope buffers<CR>", desc = "Buffers" },
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
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(arg)
          Dotfiles.map({
            "<CR>",
            function()
              require("kulala").run()
            end,
            buffer = arg.buf,
            desc = "Run the request",
          })
          Dotfiles.map({
            "]r",
            function()
              require("kulala").jump_next()
            end,
            buffer = arg.buf,
            desc = "Jump to the next request",
          })
          Dotfiles.map({
            "[r",
            function()
              require("kulala").jump_prev()
            end,
            buffer = arg.buf,
            desc = "Jump to the prev request",
          })
          Dotfiles.map({
            "yr",
            function()
              require("kulala").copy()
            end,
            buffer = arg.buf,
            desc = "Copy as curl command",
          })
          Dotfiles.map({
            "<Tab>",
            function()
              require("kulala").toggle_view()
            end,
            buffer = arg.buf,
            desc = "Toggle between body and headers",
          })
        end,
        group = Dotfiles.augroup("kulala_keymaps"),
        pattern = "http",
      })
    end,
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
}
