return {
  {
    "sudo-tee/opencode.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "saghen/blink.cmp",
      "folke/snacks.nvim",
    },
    keys = {
      { "<Leader>ao", "<Cmd>Opencode<CR>", desc = "OpenCode" },
      { "<Leader>aO", "<Cmd>Opencode session select<CR>", desc = "OpenCode (Resume)" },
    },
    opts = {
      default_global_keymaps = false,
      default_mode = "plan",
      keymap = {
        input_window = {
          ["<C-c>"] = false,
          ["<C-n>"] = { "next_prompt_history", mode = { "i", "n" } },
          ["<C-p>"] = { "prev_prompt_history", mode = { "i", "n" } },
          ["<C-s>"] = { "submit_input_prompt", mode = "i" },
          ["<CR>"] = { "submit_input_prompt" },
          ["<M-m>"] = false,
          ["<M-r>"] = false,
          ["<S-cr>"] = false,
          ["<down>"] = false,
          ["<esc>"] = { "cancel" },
          ["<tab>"] = { "switch_mode" },
          ["<up>"] = false,
        },
        output_window = {
          ["<C-c>"] = false,
          ["<M-r>"] = false,
          ["<esc>"] = { "cancel" },
          ["<leader>oD"] = false,
          ["<leader>oO"] = false,
          ["<leader>oS"] = false,
          ["<leader>ods"] = false,
          ["<tab>"] = false,
        },
      },
      ui = {
        input = {
          text = {
            wrap = true,
          },
        },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "opencode_output",
    opts = {
      file_types = { "opencode_output" },
    },
  },
}
