---@class dotfiles.utils.LSP
local M = {}

local AUGROUP = Dotfiles.augroup("lsp.utils")

---@param callback fun(client: vim.lsp.Client, bufnr: integer)
---@param name? string
function M.on_attach(callback, name)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (not name or client.name == name) then
        callback(client, args.buf)
      end
    end,
    group = AUGROUP,
  })
end

return M
