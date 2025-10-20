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
        if opts[client.name] and type(opts[client.name].keys) == "table" then
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
        on_attach = function(client) vim.lsp.on_type_formatting.enable(false, { client_id = client.id }) end,
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
}
