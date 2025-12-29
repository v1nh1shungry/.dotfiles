local M = {}

local dispatchers ---@type vim.lsp.rpc.Dispatchers

---@param id integer
---@param value lsp.WorkDoneProgressBegin|lsp.WorkDoneProgressEnd
local function send_progress(id, value)
  if dispatchers == nil then
    return
  end

  local token = "codecompanion-" .. id
  dispatchers.notification("$/progress", {
    token = token,
    value = value,
  })
end

function M.setup()
  vim.lsp.start({
    cmd = function(disp)
      dispatchers = disp

      return {
        is_closing = function() end,
        notify = function() end,
        request = function() end,
        terminate = function() end,
      }
    end,
    name = "codecompanion",
  })

  local augroup = vim.api.nvim_create_augroup("codecompanion._extensions.lsp", {})

  vim.api.nvim_create_autocmd("User", {
    callback = function(args)
      send_progress(args.data.id, {
        kind = "begin",
        title = "🤖 Requesting",
      })
    end,
    desc = "Send progress notification when CodeCompanion request starts",
    group = augroup,
    pattern = "CodeCompanionRequestStarted",
  })

  vim.api.nvim_create_autocmd("User", {
    callback = function(args)
      send_progress(args.data.id, {
        kind = "end",
      })
    end,
    desc = "Send progress notification when CodeCompanion request finishes",
    group = augroup,
    pattern = "CodeCompanionRequestFinished",
  })
end

return M
