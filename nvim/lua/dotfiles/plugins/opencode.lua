local focus = true

do
  local augroup = Dotfiles.augroup("utils.focus")

  vim.api.nvim_create_autocmd("FocusGained", {
    callback = function() focus = true end,
    desc = "Watch if Neovim gains focus",
    group = augroup,
  })

  vim.api.nvim_create_autocmd("FocusLost", {
    callback = function() focus = false end,
    desc = "Watch if Neovim gains focus",
    group = augroup,
  })
end

local function notify(msg)
  if not focus then
    vim.system({ "notify-send", "🤖 OpenCode", msg })
  end
end

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
      hooks = {
        on_done_thinking = function() notify("🥳 Done!") end,
        on_permission_requested = function() notify("🥺 Waiting for your approval...") end,
      },
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
