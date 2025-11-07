-- Inspired by https://github.com/chrisgrieser/nvim-tinygit {{{
local function git_pickaxe()
  local root = Snacks.git.get_root()

  if not root then
    Snacks.notify.error("Aborting: not a git repository")
    return
  end

  vim.system({ "git", "rev-parse", "--is-shallow-repository" }, { text = true }, function(obj)
    if vim.trim(obj.stdout or "") == "true" then
      Snacks.notify.error("Aborting: repository is shallow")
      return
    end

    vim.schedule(function()
      vim.ui.input({ prompt = "Git Pickaxe" }, function(query)
        if not query then
          return
        end

        vim.schedule(function()
          Snacks.picker({
            finder = function(_, ctx)
              return require("snacks.picker.source.proc").proc({
                cmd = "git",
                args = { "-C", root, "log", "--pretty=oneline", "--abbrev-commit", "-G", query },
                cwd = root,
                transform = function(item)
                  local sha, msg = string.match(item.text, "([^ ]+) (.+)")
                  if not msg then
                    sha = item.text
                    msg = "<empty commit message>"
                  end

                  item.sha = sha
                  item.msg = msg
                  item.text = sha .. " " .. msg
                  return item
                end,
              }, ctx)
            end,
            format = function(item)
              return {
                { item.sha, "SnacksPickerLabel" },
                { " ", virtual = true },
                { item.msg, "SnacksPickerComment" },
              }
            end,
            confirm = function(picker, item)
              picker:close()
              assert(item)
              vim.cmd(("DiffviewFileHistory --base=%s -n=1 -G=%s"):format(item.sha, query))
            end,
            preview = function(ctx)
              local cmd = {
                "git",
                "-c",
                "delta." .. vim.o.background .. "=true",
                "-C",
                root,
                "show",
                ctx.item.sha,
                "-G",
                query,
              }
              Snacks.picker.preview.cmd(cmd, ctx)
            end,
            layout = {
              layout = {
                title = "Git Pickaxe",
              },
            },
          })
        end)
      end)
    end)
  end)
end
-- }}}

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
        group = Dotfiles.augroup("plugins.snacks.setup"),
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
      { "<Leader>bb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<Leader>bo", function() Snacks.bufdelete.other() end, desc = "Only" },
      { "<Leader>ff", function() Snacks.picker.files() end, desc = "Files" },
      { "<Leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
      { "<Leader>fs", function() Snacks.scratch() end, desc = "Open Scratch Buffer" },
      { "<Leader>g/", git_pickaxe, desc = "Pickaxe" },
      { "<Leader>gf", function() Snacks.gitbrowse() end, mode = { "n", "x" }, desc = "Browse" },
      { "<Leader>gh", function() Snacks.picker.git_diff() end, desc = "Hunks" },
      { "<Leader>gl", function() Snacks.picker.git_log_line() end, desc = "Log (line)" },
      { "<Leader>h", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<Leader>pP", function() Snacks.profiler.pick() end, desc = "Show Profiler Traces" },
      { "<Leader>s,", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<Leader>s:", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<Leader>sC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      { "<Leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocommands" },
      { "<Leader>sh", function() Snacks.picker.highlights() end, desc = "Highlight Groups" },
      { "<Leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<Leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<Leader>sm", function() Snacks.picker.man() end, desc = "Manpages" },
      { "<Leader>sy", function() Snacks.picker.cliphist() end, desc = "Clipboard" },
      { "<Leader>ut", function() Snacks.picker.undo() end, desc = "Undotree" },
    },
    opts = {
      bigfile = {
        enabled = true,
      },
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
      input = {
        enabled = true,
      },
      notifier = {
        enabled = true,
      },
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
          diff = {
            builtin = false,
          },
          git = {
            native = true,
          },
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
      quickfile = {
        enabled = true,
      },
      scope = {
        cursor = false,
      },
      scratch = {
        autowrite = false,
      },
      statuscolumn = {
        folds = {
          open = true,
          git_hl = true,
        },
      },
      words = {
        enabled = true,
      },
    },
    priority = 1000,
  },
}
