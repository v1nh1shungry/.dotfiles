local ns = vim.api.nvim_create_namespace("dotfiles_lsp_lightbulb_ns")

local config = {
  icon = "💡",
  debounce = 10,
}

local previous_bufnr

local function update_virt_text(bufnr, row)
  if not (bufnr and vim.api.nvim_buf_is_valid(bufnr)) then
    return
  end
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  if not row then
    return
  end
  vim.api.nvim_buf_set_extmark(bufnr, ns, row, -1, {
    virt_text = { { config.icon, "" } },
    virt_text_pos = "overlay",
    hl_mode = "combine",
  })
  previous_bufnr = bufnr
end

local function render(bufnr)
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local params = vim.lsp.util.make_range_params()
  params.context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr) }
  vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function(_, result, _)
    if vim.api.nvim_get_current_buf() ~= bufnr then
      return
    end
    if result and #result > 0 then
      update_virt_text(bufnr, row)
    else
      update_virt_text(bufnr)
    end
  end)
end

local timer = vim.uv.new_timer()

local function update(bufnr)
  timer:stop()
  update_virt_text(previous_bufnr)
  timer:start(config.debounce, 0, function()
    timer:stop()
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_get_current_buf() == bufnr then
        render(bufnr)
      end
    end)
  end)
end

local name = "dotfiles_lsp_lightbulb_autocmds"
local augroup = vim.api.nvim_create_augroup(name, {})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end
    if not client.supports_method("textDocument/codeAction") then
      return
    end
    local bufnr = event.buf
    local group_name = name .. bufnr
    local ok = pcall(vim.api.nvim_get_autocmds, { group = group_name })
    if ok then
      return
    end
    local group = vim.api.nvim_create_augroup(group_name, {})
    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer = bufnr,
      callback = function() update(bufnr) end,
      group = group,
    })
    vim.api.nvim_create_autocmd("InsertEnter", {
      buffer = bufnr,
      callback = function() update_virt_text(bufnr) end,
      group = group,
    })
  end,
  group = augroup,
})

vim.api.nvim_create_autocmd("LspDetach", {
  callback = function(event) pcall(vim.api.nvim_del_augroup_by_name, name .. event.buf) end,
  group = augroup,
})
