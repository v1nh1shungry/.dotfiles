local M = {}

M.alpha = function()
  local dashboard = require('alpha.themes.dashboard')
  local logo = [[
 __    __ __     __ ______ __       __      __    __ ________ _______   ______
|  \  |  \  \   |  \      \  \     /  \    |  \  |  \        \       \ /      \
| ▓▓\ | ▓▓ ▓▓   | ▓▓\▓▓▓▓▓▓ ▓▓\   /  ▓▓    | ▓▓  | ▓▓ ▓▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\
| ▓▓▓\| ▓▓ ▓▓   | ▓▓ | ▓▓ | ▓▓▓\ /  ▓▓▓    | ▓▓__| ▓▓ ▓▓__   | ▓▓__| ▓▓ ▓▓  | ▓▓
| ▓▓▓▓\ ▓▓\▓▓\ /  ▓▓ | ▓▓ | ▓▓▓▓\  ▓▓▓▓    | ▓▓    ▓▓ ▓▓  \  | ▓▓    ▓▓ ▓▓  | ▓▓
| ▓▓\▓▓ ▓▓ \▓▓\  ▓▓  | ▓▓ | ▓▓\▓▓ ▓▓ ▓▓    | ▓▓▓▓▓▓▓▓ ▓▓▓▓▓  | ▓▓▓▓▓▓▓\ ▓▓  | ▓▓
| ▓▓ \▓▓▓▓  \▓▓ ▓▓  _| ▓▓_| ▓▓ \▓▓▓| ▓▓    | ▓▓  | ▓▓ ▓▓_____| ▓▓  | ▓▓ ▓▓__/ ▓▓
| ▓▓  \▓▓▓   \▓▓▓  |   ▓▓ \ ▓▓  \▓ | ▓▓    | ▓▓  | ▓▓ ▓▓     \ ▓▓  | ▓▓\▓▓    ▓▓
 \▓▓   \▓▓    \▓    \▓▓▓▓▓▓\▓▓      \▓▓     \▓▓   \▓▓\▓▓▓▓▓▓▓▓\▓▓   \▓▓ \▓▓▓▓▓▓
  ]]
  dashboard.section.header.val = vim.split(logo, '\n')
  dashboard.section.buttons.val = {
    dashboard.button('r', ' ' .. ' Recent files', '<Cmd>Telescope oldfiles cwd_only=true<CR>'),
    dashboard.button('f', ' ' .. ' Find file', '<Cmd>Telescope find_files<CR>'),
    dashboard.button('p', ' ' .. ' Find text', '<Cmd>Telescope live_grep<CR>'),
    dashboard.button('c', ' ' .. ' Config', '<Cmd>e ~/.nvimrc<CR>'),
    dashboard.button('l', '鈴' .. ' Lazy', '<Cmd>Lazy<CR>'),
    dashboard.button('q', ' ' .. ' Quit', '<Cmd>qa<CR>'),
  }
  dashboard.opts.layout[1].val = 2
  require('alpha').setup(dashboard.opts)

  if vim.o.filetype == 'lazy' then
    vim.cmd.close()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'AlphaReady',
      callback = function() require('lazy').show() end,
    })
  end
  vim.api.nvim_create_autocmd('User', {
    pattern = 'LazyVimStarted',
    callback = function()
      local stats = require('lazy').stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      dashboard.section.footer.val = '⚡ Neovim loaded ' .. stats.count .. ' plugins in ' .. ms .. 'ms'
      pcall(vim.cmd.AlphaRedraw)
    end,
  })
end

M.lualine = function()
  vim.opt.laststatus = 3
  local theme = require('user').ui.statusline_theme
  local opts = require('plugins.ui.lualine.' .. theme)
  opts.extensions = { 'lazy', 'man', 'nvim-dap-ui', 'quickfix', 'toggleterm', 'trouble' }
  require('lualine').setup(opts)
end

M.dressing = function()
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.select = function(...)
    require('lazy').load({ plugins = { 'dressing.nvim' } })
    return vim.ui.select(...)
  end
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.input = function(...)
    require('lazy').load({ plugins = { 'dressing.nvim' } })
    return vim.ui.input(...)
  end
end

M.statuscol = function()
  local builtin = require('statuscol.builtin')
  require('statuscol').setup {
    bt_ignore = { 'terminal' },
    ft_ignore = require('utils.ui').excluded_filetypes,
    relculright = true,
    segments = {
      { sign = { name = { '.*' } },       click = 'v:lua.ScSa' },
      { text = { builtin.lnumfunc },      click = 'v:lua.ScLa', },
      { sign = { name = { 'GitSigns' } }, click = 'v:lua.ScSa' },
    },
  }
end

M.hlslens = function()
  require('hlslens').setup { calm_down = true }
  vim.api.nvim_create_autocmd('User', {
    callback = require('hlslens').start,
    pattern = 'visual_multi_start',
  })
  vim.api.nvim_create_autocmd('User', {
    callback = require('hlslens').stop,
    pattern = 'visual_multi_exit',
  })
end

M.indentscope = function()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function() vim.b.miniindentscope_disable = true end,
    pattern = require('utils.ui').excluded_filetypes,
  })
end

M.which_key = function()
  local wk = require('which-key')
  wk.setup {
    window = { winblend = require('user').ui.blend },
    layout = { height = { max = 10 } },
  }
  wk.register({
    ['<Leader><Tab>'] = { name = '+tab' },
    ['<Leader>c'] = { name = '+code' },
    ['<Leader>d'] = { name = '+debug' },
    ['<Leader>f'] = { name = '+file' },
    ['<Leader>g'] = { name = '+Git' },
    ['<Leader>s'] = { name = '+search' },
    ['<Leader>u'] = { name = '+UI' },
    ['<Leader>x'] = { name = '+diagnostics/quickfix' },
  })
end

return M
