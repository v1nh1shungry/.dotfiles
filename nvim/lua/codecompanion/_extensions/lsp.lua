local M = {}

local dispatchers ---@type vim.lsp.rpc.Dispatchers

---@param token string
---@param value lsp.WorkDoneProgressBegin|lsp.WorkDoneProgressEnd
local function notify_progress(token, value)
  if dispatchers == nil then
    return
  end

  dispatchers.notification("$/progress", {
    token = token,
    value = value,
  })
end

---@param token string
local function notify_begin(token)
  notify_progress(token, {
    kind = "begin",
    title = "🤖 Crafting",
  })
end

---@param token string
local function notify_end(token)
  notify_progress(token, {
    kind = "end",
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
    callback = function(args) notify_begin("codecompanion-" .. args.data.id) end,
    group = augroup,
    pattern = "CodeCompanionChatSubmitted",
  })

  vim.api.nvim_create_autocmd("User", {
    callback = function(args) notify_end("codecompanion-" .. args.data.id) end,
    group = augroup,
    pattern = "CodeCompanionChatDone",
  })

  vim.api.nvim_create_autocmd("User", {
    callback = function() notify_begin("codecompanion-inline") end,
    group = augroup,
    pattern = "CodeCompanionInlineStarted",
  })

  vim.api.nvim_create_autocmd("User", {
    callback = function() notify_end("codecompanion-inline") end,
    group = augroup,
    pattern = "CodeCompanionInlineFinished",
  })
end

return M
