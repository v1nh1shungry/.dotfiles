local config = {
  options = { component_separators = '', section_separators = '' },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

local ins_left = function(component)
  table.insert(config.sections.lualine_c, component)
end

local ins_right = function(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left { 'branch', on_click = function() require('telescope.builtin').git_branches() end }

ins_left {
  'diagnostics',
  symbols = { error = ' ', warn = ' ', info = ' ' },
  sections = { 'error', 'warn' },
  colored = false,
  update_in_insert = true,
  always_visible = true,
  on_click = function() vim.cmd['TroubleToggle'] 'document_diagnostics' end,
}

ins_left { 'mode', fmt = function(str) return '-- ' .. str .. ' --' end }

ins_right { 'filename', on_click = function() require('telescope.builtin').find_files() end }

ins_right {
  function() return 'Spaces: ' .. vim.api.nvim_buf_get_option(0, 'shiftwidth') end,
  on_click = function()
    vim.ui.input({ prompt = 'Tab Size: ' }, function(input)
      vim.bo.shiftwidth = tonumber(input)
    end)
  end,
}

ins_right {
  function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    return string.format('Ln %s,Col %s', row, col + 1)
  end
}

ins_right { 'encoding' }

ins_right {
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

ins_right { 'filetype' }

return config
