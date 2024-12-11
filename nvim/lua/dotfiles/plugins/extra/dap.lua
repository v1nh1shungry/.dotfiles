return {
  {
    "rcarriga/nvim-dap-ui",
    config = function()
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
}
