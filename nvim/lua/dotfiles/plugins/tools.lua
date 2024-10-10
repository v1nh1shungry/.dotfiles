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
      { "<Leader>sb", "<Cmd>Telescope buffers<CR>", desc = "Buffers" },
    },
    opts = function()
      -- https://www.lazyvim.org/extras/editor/telescope#telescopenvim-1 {{{
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
      -- }}}

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
    "debugloop/telescope-undo.nvim",
    config = function() require("telescope").load_extension("undo") end,
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    keys = { { "<Leader>fu", "<Cmd>Telescope undo<CR>", desc = "Undotree" } },
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
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = { { "<Leader>s/", "<Cmd>GrugFar<CR>", desc = "Grep" } },
    opts = {},
  },
}
