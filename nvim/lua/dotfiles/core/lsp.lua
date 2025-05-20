---@param delta integer
---@return boolean
local function scroll(delta)
  if not vim.b.lsp_floating_preview then
    return false
  end
  require("noice.util.nui").scroll(vim.b.lsp_floating_preview, delta)
  return true
end

Dotfiles.lsp.on_attach(function(client, bufnr)
  local map = Dotfiles.map_with({ buffer = bufnr })
  local ms = vim.lsp.protocol.Methods

  -- TODO: separate plugin-driven mappings
  local mappings = { ---@type table<string, dotfiles.utils.map.Opts|dotfiles.utils.map.Opts[]>
    [ms.textDocument_rename] = { "<Leader>cr", vim.lsp.buf.rename, desc = "Rename" },
    [ms.textDocument_codeAction] = { "<Leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
    [ms.textDocument_documentSymbol] = {
      {
        "<Leader>ss",
        function() Snacks.picker.lsp_symbols({ tree = false }) end,
        desc = "LSP Symbols (Document)",
      },
      { "gO", "<Cmd>Outline<CR>", desc = "Symbol Outline" },
    },
    [ms.workspace_symbol] = {
      "<Leader>sS",
      function() Snacks.picker.lsp_workspace_symbols({ tree = false }) end,
      desc = "LSP Symbols (Workspace)",
    },
    [ms.textDocument_references] = {
      { "gR", vim.lsp.buf.references, desc = "Goto References" },
      { "<Leader>sR", function() Snacks.picker.lsp_references() end, desc = "LSP References" },
    },
    [ms.textDocument_definition] = {
      { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
      { "<Leader>sd", function() Snacks.picker.lsp_definitions() end, desc = "LSP Definitions" },
    },
    [ms.textDocument_declaration] = {
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "<Leader>sD", function() Snacks.picker.lsp_declarations() end, desc = "LSP Declarations" },
    },
    [ms.textDocument_typeDefinition] = {
      { "gy", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
      { "<Leader>sy", function() Snacks.picker.lsp_type_definitions() end, desc = "LSP Type Definitions" },
    },
    [ms.textDocument_implementation] = {
      { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
      { "<Leader>sI", function() Snacks.picker.lsp_implementations() end, desc = "LSP Implementations" },
    },
    [ms.callHierarchy_incomingCalls] = { "<Leader>ci", vim.lsp.buf.incoming_calls, desc = "Incoming Calls" },
    [ms.callHierarchy_outgoingCalls] = { "<Leader>co", vim.lsp.buf.outgoing_calls, desc = "Outgoing Calls" },
    [ms.typeHierarchy_subtypes] = {
      "<Leader>cs",
      function() vim.lsp.buf.typehierarchy("subtypes") end,
      desc = "LSP Subtypes",
    },
    [ms.typeHierarchy_supertypes] = {
      "<Leader>cS",
      function() vim.lsp.buf.typehierarchy("supertypes") end,
      desc = "LSP Supertypes",
    },
    [ms.textDocument_documentHighlight] = {
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference" },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Previous Reference" },
    },
    [ms.textDocument_hover] = {
      { "<C-f>", function() scroll(5) end, desc = "Scroll Down Document" },
      { "<C-b>", function() scroll(-5) end, desc = "Scroll Up Document" },
    },
  }

  for method, keys in pairs(mappings) do
    if client:supports_method(method) then
      if type(keys[1]) == "string" then
        map(keys)
      else
        for _, k in
          ipairs(keys --[=[@as dotfiles.utils.map.Opts[]]=])
        do
          map(k)
        end
      end
    end
  end

  if
    client:supports_method(ms.textDocument_inlayHint)
    and vim.api.nvim_buf_is_valid(bufnr)
    and vim.bo[bufnr].buftype == ""
  then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    Snacks.toggle.inlay_hints():map("<leader>uh", { buffer = bufnr })
  end
end)

vim.lsp.enable({
  "clangd",
  "jsonls",
  "lua_ls",
  "neocmake",
})
