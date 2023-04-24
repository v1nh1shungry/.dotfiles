local source = {}

function source.new()
  return setmetatable({}, { __index = source })
end

source.is_available = function()
  return string.find(vim.fn.bufname(), 'xmake.lua') ~= nil
end

source.complete = function(_, _, callback)
  local t = {}
  for _, item in pairs(require('plugins.ide.cmp.xmake.items')) do
    table.insert(t, { label = item, kind = require('cmp').lsp.CompletionItemKind.Function })
  end
  callback(t)
end

return source
