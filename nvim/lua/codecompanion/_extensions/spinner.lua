local M = {
  spinner_index = 0,
  namespace_id = Dotfiles.ns("codecompanion.spinner"),
  timer = nil,
  spinner_symbols = {
    "⠋",
    "⠙",
    "⠹",
    "⠸",
    "⠼",
    "⠴",
    "⠦",
    "⠧",
    "⠇",
    "⠏",
  },
}

---@param buf integer
function M:update_spinner(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    self:stop_spinner(buf)
    return
  end

  self.spinner_index = (self.spinner_index % #self.spinner_symbols) + 1

  vim.api.nvim_buf_clear_namespace(buf, self.namespace_id, 0, -1)

  local last_line = vim.api.nvim_buf_line_count(buf) - 1
  vim.api.nvim_buf_set_extmark(buf, self.namespace_id, last_line, 0, {
    virt_lines = { { { self.spinner_symbols[self.spinner_index] .. " Processing...", "Comment" } } },
    virt_lines_above = true,
  })
end

---@param buf integer
function M:start_spinner(buf)
  self.spinner_index = 0

  if self.timer then
    self.timer:stop()
    self.timer:close()
    self.timer = nil
  end

  self.timer = assert(vim.uv.new_timer())
  self.timer:start(0, 100, vim.schedule_wrap(function() self:update_spinner(buf) end))
end

---@param buf integer
function M:stop_spinner(buf)
  if self.timer then
    self.timer:stop()
    self.timer:close()
    self.timer = nil
  end

  if vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_clear_namespace(buf, self.namespace_id, 0, -1)
  end
end

function M.setup()
  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionRequest*",
    group = Dotfiles.augroup("codecompanion.spinner"),
    callback = function(args)
      if args.match == "CodeCompanionRequestStarted" then
        M:start_spinner(args.buf)
      elseif args.match == "CodeCompanionRequestFinished" then
        M:stop_spinner(args.buf)
      end
    end,
  })
end

return M
