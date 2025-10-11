return {
  {
    "folke/snacks.nvim",
    -- https://github.com/LazyVim/LazyVim {{{
    config = function(_, opts)
      local notify = vim.notify
      require("snacks").setup(opts)
      -- HACK: Restore vim.notify after snacks setup and let noice.nvim take over.
      --       This is needed to have early notifications show up in noice history.
      vim.notify = notify
    end,
    -- }}}
    init = function()
      vim.g.snacks_animate = false

      vim.api.nvim_create_autocmd("User", {
        callback = function()
          vim.print = Snacks.debug.inspect

          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<Leader>ug")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<Leader>uc")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<Leader>uw")
          Snacks.toggle.line_number():map("<Leader>ul")

          Snacks.toggle.diagnostics():map("<Leader>ux")

          Snacks.toggle.profiler():map("<Leader>pp")
        end,
        desc = "Setup snacks.nvim when ready",
        group = Dotfiles.augroup("snacks.nvim"),
        once = true,
        pattern = "VeryLazy",
      })

      Dotfiles.lsp.register_mappings({
        ["textDocument/documentSymbol"] = {
          "<Leader>ss",
          function() Snacks.picker.lsp_symbols() end,
          desc = "LSP Symbols (Document)",
        },
        ["workspace/symbol"] = {
          "<Leader>sS",
          function() Snacks.picker.lsp_workspace_symbols() end,
          desc = "LSP Symbols (Workspace)",
        },
        ["textDocument/references"] = {
          "<Leader>sR",
          function() Snacks.picker.lsp_references() end,
          desc = "LSP References",
        },
        ["textDocument/definition"] = {
          "<Leader>sd",
          function() Snacks.picker.lsp_definitions() end,
          desc = "LSP Definitions",
        },
        ["textDocument/declaration"] = {
          "<Leader>sD",
          function() Snacks.picker.lsp_declarations() end,
          desc = "LSP Declarations",
        },
        ["textDocument/typeDefinition"] = {
          "<Leader>sy",
          function() Snacks.picker.lsp_type_definitions() end,
          desc = "LSP Type Definitions",
        },
        ["textDocument/implementation"] = {
          "<Leader>sI",
          function() Snacks.picker.lsp_implementations() end,
          desc = "LSP Implementations",
        },
        ["textDocument/documentHighlight"] = {
          { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference" },
          { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Previous Reference" },
        },
      })

      Dotfiles.lsp.on_supports_method(
        "textDocument/inlayHint",
        function(_, buffer) Snacks.toggle.inlay_hints():map("<leader>uh", { buffer = buffer }) end
      )
    end,
    lazy = false,
    keys = {
      { "<C-q>", function() Snacks.bufdelete() end, desc = "Close Buffer" },
      { "<C-w>z", function() Snacks.zen.zoom() end, desc = "Zoom" },
      { "<Leader>/", function() Snacks.picker.grep() end, desc = "Live Grep" },
      { "<Leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<Leader><Space>", function() Snacks.picker.smart() end, desc = "Files (Frecency)" },
      { "<Leader>h", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<Leader>b/", function() Snacks.picker.grep_buffers() end, desc = "Grep" },
      { "<Leader>bb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<Leader>bo", function() Snacks.bufdelete.other() end, desc = "Only" },
      { "<Leader>ff", function() Snacks.picker.files() end, desc = "Files" },
      { "<Leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
      { "<Leader>fs", function() Snacks.scratch() end, desc = "Open Scratch Buffer" },
      { "<Leader>gf", function() Snacks.gitbrowse() end, mode = { "n", "x" }, desc = "Git Browse" },
      { "<Leader>gg", function() Snacks.lazygit() end, desc = "LazyGit" },
      { "<Leader>gl", function() Snacks.picker.git_log_line() end, desc = "Log (line)" },
      { "<Leader>s,", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<Leader>s:", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<Leader>sC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      { "<Leader>sX", function() Snacks.picker.diagnostics() end, desc = "Workspace Diagnostics" },
      { "<Leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocommands" },
      { "<Leader>sh", function() Snacks.picker.highlights() end, desc = "Highlight Groups" },
      { "<Leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<Leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<Leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<Leader>sL", function() Snacks.picker.lsp_config() end, desc = "LSP Config" },
      { "<Leader>sm", function() Snacks.picker.man() end, desc = "Manpages" },
      { "<Leader>sx", function() Snacks.picker.diagnostics_buffer() end, desc = "Document Diagnostics" },
      { "<Leader>sp", function() Snacks.picker.lazy() end, desc = "Plugin Specs" },
      { "<Leader>sP", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<Leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<Leader>sz", function() Snacks.picker.zoxide() end, desc = "Zoxide" },
      { "<Leader>u/", function() Snacks.picker.notifications() end, desc = "Notifications" },
      { "<Leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<Leader>ut", function() Snacks.picker.undo() end, desc = "Undotree" },
    },
    opts = {
      bigfile = { enabled = true },
      indent = {
        scope = {
          hl = {
            "SnacksIndent1",
            "SnacksIndent2",
            "SnacksIndent3",
            "SnacksIndent4",
            "SnacksIndent5",
            "SnacksIndent6",
            "SnacksIndent7",
            "SnacksIndent8",
          },
        },
      },
      input = { enabled = true },
      notifier = { enabled = true },
      picker = {
        layout = {
          preset = "ivy",
        },
        layouts = {
          ivy = {
            layout = {
              height = 0.5,
            },
          },
        },
        previewers = {
          git = { native = true },
        },
        sources = {
          recent = {
            filter = { cwd = true },
          },
          smart = {
            filter = { cwd = true },
          },
        },
      },
      quickfile = { enabled = true },
      scope = { cursor = false },
      scratch = { autowrite = false },
      statuscolumn = {
        folds = {
          open = true,
          git_hl = true,
        },
      },
      words = { enabled = true },
    },
    priority = 1000,
  },
}
