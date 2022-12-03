local M = {}

M.colorscheme = 'darkplus'

function M.setup()
  -- nord.nvim
  vim.g.nord_contrast = true
  vim.g.nord_borders = true

  -- material.nvim
  vim.g.material_style = 'darker'
  local status_material_ok, material = pcall(require, 'material')
  if status_material_ok then
    material.setup {
      plugins = {
        'dap',
        'gitsigns',
        'hop',
        'indent-blankline',
        'lspsaga',
        'nvim-cmp',
        'nvim-web-devicons',
        'telescope',
        'trouble',
      }
    }
  end

  vim.opt.background = 'dark'
  vim.cmd('colorscheme ' .. M.colorscheme)
end

return M
