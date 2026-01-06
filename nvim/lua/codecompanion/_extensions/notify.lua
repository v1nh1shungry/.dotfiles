local M = {}

function M.setup()
  if vim.fn.executable("notify-send") == 0 then
    return
  end

  local focus = true
  local augroup = vim.api.nvim_create_augroup("codecompanion._extensions.notify", {})

  vim.api.nvim_create_autocmd("FocusGained", {
    callback = function() focus = true end,
    group = augroup,
  })

  vim.api.nvim_create_autocmd("FocusLost", {
    callback = function() focus = false end,
    group = augroup,
  })

  vim.api.nvim_create_autocmd("User", {
    callback = function()
      if not focus then
        vim.system({
          "notify-send",
          "🤖 Code Companion",
          "🥳 Done!",
        })
      end
    end,
    group = augroup,
    pattern = "CodeCompanionChatDone",
  })

  vim.api.nvim_create_autocmd("User", {
    callback = function()
      if not focus then
        vim.system({
          "notify-send",
          "🤖 Code Companion",
          "🥺 Waiting for your approval...",
        })
      end
    end,
    pattern = { "CodeCompanionApprovalRequested", "CodeCompanionDiffAttached" },
  })
end

return M
