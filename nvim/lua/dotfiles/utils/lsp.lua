---@class dotfiles.utils.LSP
local M = {}

local AUGROUP = Dotfiles.augroup("lsp_on_attach")

---@param callback fun(client:vim.lsp.Client, buffer: integer)
function M.on_attach(callback)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        callback(client, args.buf)
      end
    end,
    group = AUGROUP,
  })
end

return M
