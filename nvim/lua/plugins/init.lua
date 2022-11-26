-- Disable builtin plugins
vim.g.did_install_default_menus = 1
vim.g.did_install_syntax_menu = 1
vim.g.loaded_syntax_completion = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_sql_completion = 1
vim.g.loaded_remote_plugins = 1

-- Bootstrap packer.nvim
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                    Basic Enhancement                     │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'andymass/vim-matchup',
    config = function() vim.cmd [[ let g:matchup_matchparen_offscreen = { 'method': '' } ]] end,
    event = { 'BufNewFile', 'BufReadPost' },
  }
  use { 'tpope/vim-unimpaired', event = { 'BufNewFile', 'BufReadPost' } }
  use { 'tpope/vim-sleuth', event = { 'BufNewFile', 'BufReadPost' } }
  use { 'wellle/targets.vim', event = { 'BufNewFile', 'BufReadPost' } }
  use { 'lewis6991/impatient.nvim', config = function() require('impatient').enable_profile() end }
  use {
    'nvim-treesitter/nvim-treesitter',
    config = require('plugins.nvim-treesitter'),
    event = { 'BufNewFile', 'BufReadPost' },
    requires = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', event = { 'BufNewFile', 'BufReadPost' } },
      {
        'nvim-treesitter/nvim-treesitter-context',
        config = function() require('treesitter-context').setup() end,
        event = { 'BufNewFile', 'BufReadPost' },
      },
    },
    run = ':TSUpdate',
  }
  use {
    'abecodes/tabout.nvim',
    after = 'nvim-cmp',
    config = require('plugins.tabout'),
    requires = 'nvim-treesitter',
  }
  use {
    'ethanholz/nvim-lastplace',
    config = function() require 'nvim-lastplace'.setup() end,
    event = { 'BufNewFile', 'BufReadPost' },
  }
  use {
    'nacro90/numb.nvim',
    config = function() require('numb').setup() end,
    event = { 'BufNewFile', 'BufReadPost' },
  }
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                     Edit Enhancement                     │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'ntpeters/vim-better-whitespace',
    config = require('plugins.vim-better-whitespace'),
    event = { 'BufNewFile', 'BufReadPost' },
  }
  use {
    'junegunn/vim-easy-align',
    config = require('plugins.vim-easy-align'),
    event = { 'BufNewFile', 'BufReadPost' },
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = require('plugins.indent-blankline'),
    event = { 'BufNewFile', 'BufReadPost' },
  }
  use {
    'numToStr/Comment.nvim',
    config = function() require('Comment').setup() end,
    event = { 'BufNewFile', 'BufReadPost' },
  }
  use {
    'windwp/nvim-autopairs',
    config = require('plugins.nvim-autopairs'),
    event = 'InsertEnter',
  }
  use {
    'kylechui/nvim-surround',
    config = function() require('nvim-surround').setup() end,
    event = { 'BufNewFile', 'BufReadPost' },
    tag = '*',
  }
  use { 'mbbill/undotree', cmd = 'UndotreeToggle' }
  use {
    'tversteeg/registers.nvim',
    config = function() require('registers').setup() end,
    event = { 'BufNewFile', 'BufReadPost' },
  }
  use {
    'AndrewRadev/splitjoin.vim',
    config = function() vim.g.splitjoin_quiet = 1 end,
    ft = { 'lua', 'rust' },
  }
  use { 'mg979/vim-visual-multi', event = { 'BufNewFile', 'BufReadPost' } }
  use { 'LudoPinelli/comment-box.nvim', cmd = 'CBcbox' }
  use { 'vim-scripts/ReplaceWithRegister', event = { 'BufNewFile', 'BufReadPost' } }
  use { 'tommcdo/vim-exchange', event = { 'BufNewFile', 'BufReadPost' } }
  use {
    'monaqa/dial.nvim',
    config = require('plugins.dial'),
    event = { 'BufNewFile', 'BufReadPost' },
  }
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                       Intellisense                       │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'hrsh7th/nvim-cmp',
    config = require('plugins.nvim-cmp'),
    event = { 'CmdlineEnter', 'InsertEnter' },
    requires = {
      {
        'L3MON4D3/LuaSnip',
        opt = true,
        requires = { { 'rafamadriz/friendly-snippets', opt = true } },
      },
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-emoji', after = 'nvim-cmp' },
      { 'onsails/lspkind.nvim', opt = true },
    },
  }
  use {
    'neovim/nvim-lspconfig',
    config = function() require('plugins.lspconfig') end,
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      {
        'glepnir/lspsaga.nvim',
        event = 'LspAttach',
        branch = 'main',
        config = require('plugins.lspsaga'),
      },
      {
        'lvimuser/lsp-inlayhints.nvim',
        branch = 'anticonceal',
        config = require('plugins.lsp-inlayhints'),
        event = 'LspAttach',
      },
      { 'ray-x/lsp_signature.nvim', event = 'LspAttach' },
      'folke/neodev.nvim',
      'p00f/clangd_extensions.nvim',
      'b0o/schemastore.nvim',
    },
  }
  use {
    'jose-elias-alvarez/null-ls.nvim',
    config = require('plugins.null-ls'),
    event = { 'BufNewFile', 'BufReadPost' },
    requires = 'nvim-lua/plenary.nvim',
  }
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                          Debug                           │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'mfussenegger/nvim-dap',
    cmd = { 'DapContinue', 'DapToggleBreakpoint' },
    config = require('plugins.nvim-dap'),
    requires = {
      { 'rcarriga/nvim-dap-ui', opt = true },
      {
        'theHamsta/nvim-dap-virtual-text',
        opt = true,
        requires = 'nvim-treesitter/nvim-treesitter',
      },
    },
  }
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                            UI                            │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'RRethy/vim-illuminate',
    config = function() require('illuminate').configure { providers = { 'lsp', 'treesitter' } } end,
    event = { 'BufNewFile', 'BufReadPost' },
  }
  use { 'machakann/vim-highlightedyank', event = 'TextYankPost' }
  use { 'romainl/vim-cool', event = 'CmdlineEnter' }
  use {
    'akinsho/toggleterm.nvim',
    cmd = 'ToggleTerm',
    config = function() require('toggleterm').setup { size = 10 } end,
  }
  use { 'folke/trouble.nvim', cmd = { 'TroubleToggle', 'TroubleRefresh', 'TodoTrouble' } }
  use { 'skywind3000/vim-quickui', config = require('plugins.vim-quickui') }
  use {
    'akinsho/bufferline.nvim',
    config = require('plugins.bufferline'),
    event = { 'BufNewFile', 'BufReadPost' },
    requires = 'kyazdani42/nvim-web-devicons',
    tag = 'v3.*',
  }
  use {
    'folke/todo-comments.nvim',
    config = function() require('todo-comments').setup { signs = false } end,
    event = { 'BufNewFile', 'BufReadPost' },
    requires = 'nvim-lua/plenary.nvim',
  }
  use {
    'lewis6991/gitsigns.nvim',
    config = function() require('gitsigns').setup() end,
    event = { 'BufReadPost', 'BufNewFile' },
  }
  use {
    'windwp/windline.nvim',
    config = require('plugins.windline'),
    event = { 'BufNewFile', 'BufReadPost' },
  }
  use {
    'goolord/alpha-nvim',
    config = function() require('alpha').setup(require('alpha.themes.theta').config) end,
    requires = 'kyazdani42/nvim-web-devicons',
  }
  use {
    'folke/noice.nvim',
    config = require('plugins.noice'),
    requires = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
  }
  use {
    'preservim/vim-pencil',
    config = require('plugins.vim-pencil'),
    ft = 'markdown',
  }
  use {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    requires = 'nvim-lua/plenary.nvim',
  }
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                          Tools                           │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    cmd = 'NeoTreeFocusToggle',
    config = require('plugins.neo-tree'),
    requires = { 'nvim-lua/plenary.nvim', 'kyazdani42/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
  }
  use {
    'brooth/far.vim',
    cmd = { 'Farf', 'Farr' },
    config = function() vim.g.enable_undo = true end,
  }
  use { 'dstein64/vim-startuptime', cmd = 'StartupTime' }
  use { 'metakirby5/codi.vim', cmd = 'Codi!!' }
  use {
    'phaazon/hop.nvim',
    cmd = { 'HopChar1', 'HopWord', 'HopLine' },
    config = function() require('hop').setup() end,
  }
  use {
    'rhysd/clever-f.vim',
    config = require('plugins.clever-f'),
    event = { 'BufNewFile', 'BufReadPost' },
  }
  use {
    'williamboman/mason.nvim',
    config = require('plugins.mason'),
    requires = { 'williamboman/mason-lspconfig.nvim', 'WhoIsSethDaniel/mason-tool-installer.nvim' },
  }
  use {
    'dhruvasagar/vim-table-mode',
    cmd = 'TableModeToggle',
    config = function() vim.g.table_mode_corner = '|' end,
  }
  use {
    'kkoomen/vim-doge',
    cmd = 'DogeGenerate',
    config = function() vim.g.doge_enable_mappings = false end,
    run = ':call doge#install()',
  }
  use {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    config = require('plugins.telescope'),
    requires = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-file-browser.nvim', opt = true },
    },
    tag = '0.1.0',
  }
  use { 'lambdalisue/suda.vim', cmd = { 'SudoRead', 'SudoWrite' } }
  use {
    'krady21/compiler-explorer.nvim',
    cmd = { 'CECompile', 'CECompileLive' },
    config = function() vim.cmd [[packadd dressing.nvim]] end,
    requires = { { 'stevearc/dressing.nvim', opt = true } },
  }
  use {
    'skywind3000/asynctasks.vim',
    cmd = { 'AsyncTask', 'AsyncTaskMacro', 'AsyncTaskList', 'AsyncTaskEdit' },
    config = require('plugins.asynctasks'),
    requires = { { 'skywind3000/asyncrun.vim', cmd = { 'AsyncRun', 'AsyncStop' } } },
  }
  use { 'skywind3000/vim-cppman', cmd = 'Cppman' }
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                          Themes                          │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'rebelot/kanagawa.nvim',
    cond = function() return require('plugins.colorscheme').colorscheme == 'kanagawa' end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'wuelnerdotexe/vim-enfocado',
    cond = function() return require('plugins.colorscheme').colorscheme == 'enfocado' end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'folke/tokyonight.nvim',
    cond = function() return string.find(require('plugins.colorscheme').colorscheme, 'tokyonight') ~= nil end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'EdenEast/nightfox.nvim',
    cond = function() return string.find(require('plugins.colorscheme').colorscheme, 'fox') ~= nil end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'savq/melange',
    cond = function() return require('plugins.colorscheme').colorscheme == 'melange' end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'Mofiqul/vscode.nvim',
    cond = function() return require('plugins.colorscheme').colorscheme == 'vscode' end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'shaunsingh/nord.nvim',
    cond = function() return require('plugins.colorscheme').colorscheme == 'nord' end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'Mofiqul/dracula.nvim',
    cond = function() return require('plugins.colorscheme').colorscheme == 'dracula' end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'bluz71/vim-moonfly-colors',
    cond = function() return require('plugins.colorscheme').colorscheme == 'moonfly' end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'bluz71/vim-nightfly-colors',
    cond = function() return require('plugins.colorscheme').colorscheme == 'nightfly' end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'luisiacc/gruvbox-baby',
    cond = function() return require('plugins.colorscheme').colorscheme == 'gruvbox-baby' end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'projekt0n/github-nvim-theme',
    cond = function() return string.find(require('plugins.colorscheme').colorscheme, 'github') ~= nil end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'rose-pine/neovim',
    as = 'rose-pine',
    cond = function() return require('plugins.colorscheme').colorscheme == 'rose-pine' end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'catppuccin/nvim',
    as = 'catppuccin',
    cond = function() return string.find(require('plugins.colorscheme').colorscheme, 'catppuccin') ~= nil end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'marko-cerovac/material.nvim',
    cond = function() return require('plugins.colorscheme').colorscheme == 'material' end,
    config = function() require('plugins.colorscheme').setup() end,
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
