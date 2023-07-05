local components = { basic = require('plugins.ui.lualine.components.basic') }

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

ins_left (components.basic.diagnostics)

ins_left { 'mode', fmt = function(str) return '-- ' .. str .. ' --' end }

ins_right { function() return '%S' end }

ins_right (components.basic.location)

ins_right (components.basic.tab)

ins_right { 'encoding' }

ins_right (components.basic.fileformat)

ins_right { 'filetype' }

return config
