---@param delta integer
---@return boolean
local function scroll(delta)
  if not vim.b.lsp_floating_preview or not vim.api.nvim_win_is_valid(vim.b.lsp_floating_preview) then
    return false
  end

  vim.api.nvim_win_call(
    vim.b.lsp_floating_preview,
    function() vim.fn.winrestview({ topline = vim.fn.winsaveview().topline + delta }) end
  )

  return true
end

return {
  -- https://www.lazyvim.org/plugins/lsp#masonnvim-1 {{{
  {
    "mason-org/mason.nvim",
    config = function(_, opts)
      require("mason").setup(opts)

      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(
          function()
            require("lazy.core.handler.event").trigger({
              event = "FileType",
              buf = vim.api.nvim_get_current_buf(),
            })
          end,
          100
        )
      end)
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            Dotfiles.notify("Installing package " .. p.name)
            p:install()
          end
        end
      end)
    end,
    event = "VeryLazy",
    keys = { { "<Leader>pm", "<Cmd>Mason<CR>", desc = "Mason" } },
    opts = {
      ensure_installed = {},
    },
    opts_extend = { "ensure_installed" },
  },
  -- }}}
  {
    "neovim/nvim-lspconfig",
    config = function(_, opts)
      local log_path = vim.lsp.log.get_filename()
      local stat = vim.uv.fs_stat(log_path)
      if stat and stat.size and stat.size > 50 * 1024 * 1024 then
        vim.uv.fs_unlink(log_path)
      end

      Dotfiles.lsp.on_attach(function(client, buffer)
        local map = Dotfiles.map_with({ buffer = buffer })
        if type(opts[client.name].keys) == "table" then
          for _, key in ipairs(opts[client.name].keys) do
            map(key)
          end
        end

        if client:supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
        end

        if client:supports_method("textDocument/onTypeFormatting") then
          vim.lsp.on_type_formatting.enable(true, { client_id = client.id })
        end

        if type(opts[client.name].setup) == "function" then
          opts[client.name].setup(client, buffer)
        end
      end)

      Dotfiles.lsp.register_mappings({
        ["textDocument/rename"] = { "<Leader>cr", vim.lsp.buf.rename, desc = "Rename" },
        ["textDocument/codeAction"] = { "<Leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
        ["textDocument/references"] = { "gR", vim.lsp.buf.references, desc = "Goto References" },
        ["textDocument/definition"] = { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
        ["textDocument/declaration"] = { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
        ["textDocument/typeDefinition"] = { "gy", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
        ["textDocument/implementation"] = { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
        ["callHierarchy/incomingCalls"] = { "<Leader>ci", vim.lsp.buf.incoming_calls, desc = "Incoming Calls" },
        ["callHierarchy/outgoingCalls"] = { "<Leader>co", vim.lsp.buf.outgoing_calls, desc = "Outgoing Calls" },
        ["typeHierarchy/subtypes"] = {
          "<Leader>cs",
          function() vim.lsp.buf.typehierarchy("subtypes") end,
          desc = "LSP Subtypes",
        },
        ["typeHierarchy/supertypes"] = {
          "<Leader>cS",
          function() vim.lsp.buf.typehierarchy("supertypes") end,
          desc = "LSP Supertypes",
        },
        ["textDocument/hover"] = {
          {
            "<C-f>",
            function()
              if not scroll(5) then
                return "<C-f>"
              end
            end,
            desc = "Scroll Down Document",
            expr = true,
          },
          {
            "<C-b>",
            function()
              if not scroll(-5) then
                return "<C-b>"
              end
            end,
            desc = "Scroll Up Document",
            expr = true,
          },
        },
      })

      local mr = require("mason-registry")
      for name, settings in pairs(opts) do
        local p = mr.get_package(settings.mason or name)
        if not p:is_installed() then
          Dotfiles.notify("Installing package " .. p.name)
          p:install()
        end
      end

      vim.lsp.enable(vim.tbl_keys(opts))
    end,
    dependencies = "mason-org/mason.nvim",
    event = "VeryLazy",
    opts = {
      clangd = {
        keys = {
          { "<Leader>ch", "<Cmd>LspClangdSwitchSourceHeader<CR>", desc = "Switch Source/Header" },
        },
        -- FIXME: clang-format can't format all projects well.
        setup = function(client) vim.lsp.on_type_formatting.enable(false, { client_id = client.id }) end,
      },
      emmylua_ls = {},
      jsonls = {
        mason = "json-lsp",
      },
      neocmake = {
        mason = "neocmakelsp",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
    dependencies = {
      "williamboman/mason.nvim",
      opts = { ensure_installed = vim.version.cmp(vim.g.glibc_version, "2.31") > 0 and { "stylua" } or {} },
    },
    keys = {
      { "<Leader>cf", function() require("conform").format() end, desc = "Format Document", mode = { "n", "x" } },
    },
    opts = {
      default_format_opts = { lsp_format = "fallback" },
      formatters_by_ft = {
        fish = { "fish_indent" },
        json = { "jq" },
        just = { "just" },
        markdown = { "injected" },
        query = { "format-queries" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    },
  },
  -- https://www.lazyvim.org/plugins/linting {{{
  {
    "mfussenegger/nvim-lint",
    config = function(_, opts)
      local lint = require("lint")

      for name, linter in pairs(opts.linters or {}) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name] --[[@as lint.Linter]], linter)
        else
          lint.linters[name] = linter
        end
      end

      lint.linters_by_ft = opts.linters_by_ft

      ---@class dotfiles.plugins.dev.lint.Linter: lint.Linter
      ---@field condition fun(): boolean

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          local names = vim
            .iter(lint._resolve_linter_by_ft(vim.bo.filetype))
            :filter(function(name)
              local linter = lint.linters[name] ---@as dotfiles.plugins.dev.lint.Linter
              if not linter then
                Dotfiles.notify.warn("Linter not found: " .. name)
                return false
              end
              return not (type(linter) == "table" and linter.condition and not linter.condition())
            end)
            :totable()

          if #names > 0 then
            lint.try_lint(names)
          end
        end,
        desc = "Run linter automatically",
        group = Dotfiles.augroup("lint"),
      })
    end,
    event = "LazyFile",
    opts = {
      linters_by_ft = {
        bash = { "bash" },
        fish = { "fish" },
        sh = { "bash" },
      },
    },
  },
  -- }}}
  {
    "hedyhli/outline.nvim",
    cmd = "Outline",
    init = function()
      Dotfiles.lsp.register_mappings({
        ["textDocument/documentSymbol"] = { "gO", "<Cmd>Outline<CR>", desc = "Symbol Outline" },
      })
    end,
    opts = {
      outline_window = { hide_cursor = true },
      preview_window = { border = "rounded" },
      keymaps = {
        peek_location = {},
        goto_and_close = { "o" },
        up_and_jump = "<C-p>",
        down_and_jump = "<C-n>",
      },
      symbols = { icon_fetcher = function(kind, _) return require("mini.icons").get("lsp", kind) end },
    },
  },
}
