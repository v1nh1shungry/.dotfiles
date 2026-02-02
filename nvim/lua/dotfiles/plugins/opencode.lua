local augroup = Dotfiles.augroup("plugins.opencode")

local focus = true
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

local function notify(msg)
  if not focus then
    vim.system({ "notify-send", "🤖 OpenCode", msg })
  end
end

return {
  {
    "sudo-tee/opencode.nvim",
    cmd = "Opencode",
    config = function(_, opts)
      local keymap = require("opencode.config").keymap
      keymap.input_window = {
        ["#"] = { "context_items", mode = "i" },
        ["/"] = { "slash_commands", mode = "i" },
        ["<C-c>"] = { "close" },
        ["<C-n>"] = { "next_prompt_history", mode = { "i", "n" } },
        ["<C-p>"] = { "prev_prompt_history", mode = { "i", "n" } },
        ["<C-s>"] = { "submit_input_prompt" },
        ["<C-w>z"] = { "toggle_zoom" },
        ["<CR>"] = { "submit_input_prompt" },
        ["<ESC>"] = { "cancel" },
        ["<M-v>"] = { "paste_image", mode = "i" },
        ["<Tab>"] = { "switch_mode" },
        ["@"] = { "mention", mode = "i" },
        ["~"] = { "mention_file", mode = "i" },
      }
      keymap.output_window = {
        ["<C-c>"] = { "close" },
        ["<C-w>z"] = { "toggle_zoom" },
        ["[["] = { "prev_message" },
        ["]]"] = { "next_message" },
        ["i"] = { "focus_input" },
      }

      require("opencode").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          Dotfiles.map({ "<C-c>", "<Cmd>stopinsert<CR>", buffer = args.buf, desc = "Enter Normal Mode", mode = "i" })
          Dotfiles.map({
            "<C-s>",
            function()
              require("opencode.api").submit_input_prompt()
              vim.cmd("stopinsert")
            end,
            buffer = args.buf,
            desc = "Submit Prompt",
            mode = "i",
          })
        end,
        group = augroup,
        pattern = "opencode",
      })
    end,
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
      legacy_commands = false,
      ui = {
        input = {
          text = {
            wrap = true,
          },
        },
        input_height = 0.2,
        window_width = 0.5,
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
