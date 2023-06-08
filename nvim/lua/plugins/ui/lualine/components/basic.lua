local M = {}

M.diagnostics = {
  'diagnostics',
  symbols = { error = ' ', warn = ' ', info = ' ' },
  sections = { 'error', 'warn' },
  colored = false,
  update_in_insert = true,
  always_visible = true,
  on_click = function() vim.cmd['TroubleToggle'] 'document_diagnostics' end,
}

M.tab = {
  function() return 'Spaces: ' .. vim.bo.shiftwidth end,
  on_click = function()
    vim.ui.input({ prompt = 'Tab Size: ' }, function(input)
      vim.bo.shiftwidth = tonumber(input)
    end)
  end,
}

M.location = {
  function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    return string.format('Ln %s,Col %s', row, col + 1)
  end
}

M.fileformat = {
  'fileformat',
  icons_enabled = true,
  symbols = { unix = 'LF', dos = 'CRLF', mac = 'CR' },
  on_click = function()
    local table = { LF = 'unix', CRLF = 'dos', CR = 'mac' }
    vim.ui.select(
      { 'LF', 'CRLF', 'CR' },
      { prompt = 'Line Ending:' },
      function(choice)
        if choice ~= nil then
          vim.bo.fileformat = table[choice]
        end
      end
    )
  end,
}

return M

