return {
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs({
        Breakpoint = { "󰝥", "DiagnosticError" },
        BreakpointCondition = "",
        BreakpointRejected = { "", "DiagnosticError" },
        LogPoint = "",
        Stopped = { "󰁕", "DiagnosticWarn", "DapStoppedLine" },
      }) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.after.event_initialized.dapui_config = dapui.open
      dap.listeners.before.event_terminated.dapui_config = dapui.close
      dap.listeners.before.event_exited.dapui_config = dapui.close
    end,
    dependencies = {
      "nvim-neotest/nvim-nio",
      {
        "mfussenegger/nvim-dap",
        config = function()
          local dap = require("dap")

          dap.adapters.gdb = {
            type = "executable",
            command = "gdb",
            args = { "-i", "dap" },
          }
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        callback = function()
          Snacks.util.on_module("which-key", function()
            require("which-key").add({ "<Leader>d", group = "debug" })
          end)
        end,
        group = Dotfiles.augroup("dap_which_key"),
        pattern = "VeryLazy",
      })
    end,
    keys = {
      { "<Leader>db", "<Cmd>DapToggleBreakpoint<CR>", desc = "Toggle breakpoint" },
      { "<Leader>dc", "<Cmd>DapContinue<CR>", desc = "Continue" },
      {
        "<Leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to cursor",
      },
      { "<Leader>dn", "<Cmd>DapStepOver<CR>", desc = "Step over" },
      { "<Leader>ds", "<Cmd>DapStepInto<CR>", desc = "Step into" },
      { "<Leader>do", "<Cmd>DapStepOut<CR>", desc = "Step out" },
      {
        "<Leader>dd",
        function()
          require("dap").down()
        end,
        desc = "Go down in current stacktrace",
      },
      {
        "<Leader>du",
        function()
          require("dap").up()
        end,
        desc = "Go up in current stacktrace",
      },
      { "<Leader>dt", "<Cmd>DapTerminate<CR>", desc = "Terminate" },
      {
        "<Leader>dK",
        function()
          require("dapui").eval()
        end,
        desc = "Eval",
      },
    },
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = {
      bottom = {
        { ft = "dap-repl", title = "REPL" },
        { ft = "dapui_console", title = "Console" },
      },
      left = {
        {
          ft = "dapui_scopes",
          title = "Scopes",
          size = { height = 0.25 },
        },
        {
          ft = "dapui_breakpoints",
          title = "Breakpoints",
          size = { height = 0.25 },
        },
        {
          ft = "dapui_stacks",
          title = "Stacks",
          size = { height = 0.25 },
        },
        {
          ft = "dapui_watches",
          title = "Watches",
          size = { height = 0.25 },
        },
      },
    },
  },
}
