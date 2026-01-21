---@class dotfiles.plugins.nvim_lspconfig.ServerOpts
---@field keys? dotfiles.utils.map.Opts[]
---@field mason? string|{ [1]?: string, version?: string }
---@field on_attach? fun(client: vim.lsp.Client, buffer: integer)

return {
  {
    "neovim/nvim-lspconfig",
    config = function(_, opts)
      local log_path = vim.lsp.log.get_filename()
      local stat = vim.uv.fs_stat(log_path)
      if stat and stat.size and stat.size > 20 * 1024 * 1024 then
        vim.uv.fs_unlink(log_path)
      end

      Dotfiles.lsp.on_attach(function(client, buffer)
        local map = Dotfiles.map_with({ buffer = buffer })
        if opts[client.name] and type(opts[client.name].keys) == "table" then
          for _, key in ipairs(opts[client.name].keys) do
            map(key)
          end
        end

        if client:supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
        end

        if opts[client.name] and type(opts[client.name].on_attach) == "function" then
          opts[client.name].on_attach(client, buffer)
        end
      end)

      Dotfiles.lsp.register_mappings({
        ["textDocument/rename"] = { "<Leader>cr", vim.lsp.buf.rename, desc = "Rename" },
        ["textDocument/codeAction"] = { "<Leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
        ["textDocument/references"] = { "gR", vim.lsp.buf.references, desc = "Go to References" },
        ["textDocument/definition"] = { "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
        ["textDocument/declaration"] = { "gD", vim.lsp.buf.declaration, desc = "Go to Declaration" },
        ["textDocument/typeDefinition"] = { "gy", vim.lsp.buf.type_definition, desc = "Go to Type Definition" },
        ["textDocument/implementation"] = { "gI", vim.lsp.buf.implementation, desc = "Go to Implementation" },
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
      })

      local mr = require("mason-registry")
      for name, settings in pairs(opts) do
        local version = nil
        if type(settings.mason) == "string" then
          name = settings.mason
        elseif type(settings.mason) == "table" then
          name = settings.mason[1] and settings.mason[1] or name
          version = settings.mason.version
        end

        local p = mr.get_package(name)
        if not p:is_installed() then
          Snacks.notify("Installing package " .. p.name)
          p:install({ version = version })
        end
      end

      vim.lsp.enable(vim.tbl_keys(opts))

      vim.api.nvim_create_user_command("LspLog", function()
        vim.cmd("tabnew " .. log_path)
        vim.cmd("$")
      end, { desc = "Opens the Nvim LSP client log." })
    end,
    dependencies = "mason-org/mason.nvim",
    event = "VeryLazy",
    opts = { ---@type table<string, dotfiles.plugins.nvim_lspconfig.ServerOpts>
      basedpyright = {},
      clangd = {
        keys = {
          { "<Leader>ch", "<Cmd>LspClangdSwitchSourceHeader<CR>", desc = "Switch Source/Header" },
        },
      },
      jsonls = {
        mason = "json-lsp",
      },
      lua_ls = {
        mason = "lua-language-server",
      },
      neocmake = {
        mason = "neocmakelsp",
      },
      ruff = {},
    },
  },
}
