---@class dotfiles.utils.LSP
local M = {}

local AUGROUP = Dotfiles.augroup("lsp.utils")

---@param event string
---@return fun(callback: fun(client: vim.lsp.Client, buffer: integer))
local function on(event)
  return function(callback)
    vim.api.nvim_create_autocmd(event, {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
          callback(client, args.buf)
        end
      end,
      group = AUGROUP,
    })
  end
end

M.on_attach = on("LspAttach")

M.on_detach = on("LspDetach")

return M
