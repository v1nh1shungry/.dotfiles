-- HACK: Disable automatic inline completion refresh (annoying and wasteful).
local function enable_inline_completion(_, buffer)
  vim.lsp.inline_completion.enable(true, { bufnr = buffer })

  ---@type vim.lsp.inline_completion.Completor
  local completor = assert(require("vim.lsp._capability").all["inline_completion"].active[buffer])
  vim.api.nvim_clear_autocmds({
    group = completor.augroup,
    event = { "InsertEnter", "CursorMovedI", "TextChangedP" },
  })
end

---@param opts vim.lsp.inline_completion.select.Opts
local function manually_trigger_inline_completion(opts)
  local buffer = vim.api.nvim_get_current_buf()
  ---@type vim.lsp.inline_completion.Completor
  local completor = assert(require("vim.lsp._capability").all["inline_completion"].active[buffer])
  if not completor.current then
    ---@diagnostic disable-next-line: access-invisible
    completor:request(vim.lsp.protocol.InlineCompletionTriggerKind.Invoked)
  else
    vim.lsp.inline_completion.select(opts)
  end
end

return {
  {
    "coder/claudecode.nvim",
    cmd = { "ClaudeCode" },
    dependencies = {
      "folke/snacks.nvim",
      "ravitemer/mcphub.nvim",
    },
    keys = {
      { "<Leader>ac", "<Cmd>ClaudeCode<CR>", desc = "Claude Code" },
      { "<Leader>ac", "<Cmd>ClaudeCodeSend<CR>", desc = "Claude Code", mode = "x" },
    },
    opts = {
      diff_opts = {
        hide_terminal_in_new_tab = true,
        open_in_new_tab = true,
      },
      terminal = {
        snacks_win_opts = {
          keys = {
            hide_n = { "<C-c>", "hide" },
            hide_t = { "<C-q>", "hide", mode = "t" },
            term_normal = { "<C-c>", function() vim.cmd("stopinsert") end, mode = "t" },
          },
          position = "right",
        },
        split_width_percentage = 0.5,
      },
      terminal_cmd = "claude --mcp-config="
        .. vim.fs.joinpath(assert(vim.uv.os_homedir()), ".dotfiles", "claude", "mcp.json"),
    },
  },
  {
    "ravitemer/mcphub.nvim",
    build = "bundled_build.lua",
    cmd = "MCPHub",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
      config = vim.fs.joinpath(vim.fn.stdpath("config") --[[@as string]], "mcp.json"),
      ui = {
        window = {
          border = "rounded",
        },
      },
      use_bundled_binary = true,
    },
  },
  {
    "folke/sidekick.nvim",
    dependencies = {
      "folke/snacks.nvim",
      "ravitemer/mcphub.nvim",
      {
        "neovim/nvim-lspconfig",
        opts = {
          copilot = {
            keys = {
              {
                "<Tab>",
                function()
                  if not require("sidekick").nes_jump_or_apply() then
                    return "<Tab>"
                  end
                end,
                desc = "Next Edit Suggestion",
                expr = true,
              },
              {
                "<M-a>",
                function() require("sidekick.nes").update() end,
                desc = "Refresh Next Edit Suggestion",
                mode = { "i", "n" },
              },
              {
                "<M-]>",
                function() manually_trigger_inline_completion({ count = 1 }) end,
                desc = "Next Copilot Suggestion",
                mode = "i",
              },
              {
                "<M-[>",
                function() manually_trigger_inline_completion({ count = -1 }) end,
                desc = "Prev Copilot Suggestion",
                mode = "i",
              },
            },
            mason = "copilot-language-server",
            setup = enable_inline_completion,
          },
        },
      },
      {
        "saghen/blink.cmp",
        opts = {
          keymap = {
            ["<Tab>"] = {
              function(cmp)
                if cmp.snippet_active() then
                  return cmp.accept()
                else
                  return cmp.select_and_accept()
                end
              end,
              "snippet_forward",
              function() return require("sidekick").nes_jump_or_apply() end,
              function() return vim.lsp.inline_completion.get() end,
              "fallback",
            },
          },
        },
      },
    },
    event = "LspAttach",
    keys = {
      {
        "<Leader>ax",
        function() require("sidekick.cli").toggle({ name = "codex", focus = true }) end,
        desc = "Codex",
        mode = { "n", "x" },
      },
    },
    opts = {
      cli = {
        win = {
          keys = {
            hide_n = { "<C-c>", "hide", mode = "n" },
            stopinsert = { "<C-c>", "stopinsert" },
          },
        },
      },
    },
  },
}
