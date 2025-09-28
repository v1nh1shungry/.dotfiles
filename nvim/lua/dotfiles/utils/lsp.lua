---@class dotfiles.utils.Lsp
local M = {}

local augroup = Dotfiles.augroup("lsp.on_attach")

---@param callback fun(client: vim.lsp.Client, buffer: integer)
function M.on_attach(callback)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        callback(client, args.buf)
      end
    end,
    group = augroup,
  })
end

---@param method vim.lsp.protocol.Method.ClientToServer
---@param callback fun(client: vim.lsp.Client, buffer: integer)
function M.on_supports_method(method, callback)
  M.on_attach(function(client, buffer)
    if client:supports_method(method, buffer) then
      callback(client, buffer)
    end
  end)
end

---@param mappings table<vim.lsp.protocol.Method.ClientToServer, dotfiles.utils.map.Opts|dotfiles.utils.map.Opts[]>
function M.register_mappings(mappings)
  M.on_attach(function(client, buffer)
    local map = Dotfiles.map_with({ buffer = buffer })
    for method, keys in pairs(mappings) do
      if client:supports_method(method) then
        if type(keys[1]) == "string" then
          map(keys --[[@as dotfiles.utils.map.Opts]])
        else
          for _, k in ipairs(keys) do
            map(k)
          end
        end
      end
    end
  end)
end

return M
