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
  use {
    'wbthomason/packer.nvim',
  }
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                    Basic Enhancement                     │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'andymass/vim-matchup',
    after = 'nvim-treesitter',
    config = function() vim.cmd [[ let g:matchup_matchparen_offscreen = { 'method': '' } ]] end,
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
      { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' },
      { 'JoosepAlviste/nvim-ts-context-commentstring', after = 'nvim-treesitter' },
      { 'windwp/nvim-ts-autotag', after = 'nvim-treesitter' },
      { 'p00f/nvim-ts-rainbow', after = 'nvim-treesitter' },
      {
        'nvim-treesitter/nvim-treesitter-context',
        after = 'nvim-treesitter',
        config = function() require('treesitter-context').setup() end,
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
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                     Edit Enhancement                     │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'ntpeters/vim-better-whitespace',
    config = require('plugins.vim-better-whitespace'),
    event = { 'BufNewFile', 'BufReadPost' },
  }
  use { 'junegunn/vim-easy-align', cmd = 'EasyAlign' }
  use { 'lukas-reineke/indent-blankline.nvim', event = { 'BufNewFile', 'BufReadPost' } }
  use {
    'numToStr/Comment.nvim',
    after = 'nvim-ts-context-commentstring',
    config = require('plugins.Comment'),
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
  use { 'AndrewRadev/splitjoin.vim', event = { 'BufNewFile', 'BufReadPost' } }
  use { 'mg979/vim-visual-multi', event = { 'BufNewFile', 'BufReadPost' } }
  use { 'LudoPinelli/comment-box.nvim', cmd = { 'CBcbox' } }
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
        after = 'nvim-cmp',
        config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
        requires = { { 'rafamadriz/friendly-snippets', after = 'nvim-cmp' } },
      },
      { 'onsails/lspkind.nvim', opt = true },
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
    },
  }
  use {
    'neovim/nvim-lspconfig',
    config = function() require('plugins.lspconfig') end,
    event = { 'BufNewFile', 'BufReadPre' },
    requires = {
      { 'lukas-reineke/lsp-format.nvim', after = 'nvim-lspconfig' },
      { 'ray-x/lsp_signature.nvim', after = 'nvim-lspconfig' },
      {
        'glepnir/lspsaga.nvim',
        after = 'nvim-lspconfig',
        branch = 'main',
        config = require('plugins.lspsaga'),
      },
    },
  }
  use { 'folke/neodev.nvim', ft = 'lua' }
  use { 'simrat39/rust-tools.nvim', ft = 'rust' }
  use { 'p00f/clangd_extensions.nvim', ft = { 'c', 'cpp' } }
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                            UI                            │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'RRethy/vim-illuminate',
    config = require('plugins.vim-illuminate'),
    event = { 'BufNewFile', 'BufReadPost' },
  }
  use { 'machakann/vim-highlightedyank', event = 'TextYankPost' }
  use { 'romainl/vim-cool', event = 'CmdlineEnter' }
  use {
    'akinsho/toggleterm.nvim',
    cmd = 'ToggleTerm',
    config = function() require('toggleterm').setup { size = 10 } end,
  }
  use { 'folke/trouble.nvim', cmd = { 'Trouble', 'TroubleToggle', 'TroubleRefresh' } }
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
    config = function() require('todo-comments').setup() end,
    event = { 'BufNewFile', 'BufReadPost' },
    requires = 'nvim-lua/plenary.nvim',
  }
  use {
    'lewis6991/gitsigns.nvim',
    config = function() require('gitsigns').setup() end,
    event = { 'BufReadPost', 'BufNewFile' },
  }
  use {
    'norcalli/nvim-colorizer.lua',
    config = function() require('colorizer').setup() end,
    event = { 'BufNewFile', 'BufReadPost' },
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
  use { 'rcarriga/nvim-notify', config = function() vim.notify = require('notify') end }
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                          Tools                           │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    cmd = 'NeoTreeFocusToggle',
    config = require('plugins.neo-tree'),
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      { 'MunifTanjim/nui.nvim', opt = true },
    },
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
  use { 'simeji/winresizer', cmd = 'WinResizerStartResize' }
  use { 'tpope/vim-fugitive', cmd = { 'Git', 'Gvdiffsplit', 'Gvsplit' } }
  use {
    'williamboman/mason.nvim',
    config = function() require('mason').setup() end,
    requires = {
      {
        'williamboman/mason-lspconfig.nvim',
        after = 'mason.nvim',
        config = require('plugins.mason-lspconfig'),
      },
    },
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
    requires = { { 'stevearc/dressing.nvim', after = 'compiler-explorer.nvim' } },
  }
  use {
    'skywind3000/asynctasks.vim',
    cmd = { 'AsyncTask', 'AsyncTaskMacro', 'AsyncTaskList', 'AsyncTaskEdit' },
    config = require('plugins.asynctasks'),
    requires = { { 'skywind3000/asyncrun.vim', cmd = { 'AsyncRun', 'AsyncStop' } } },
  }
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                          Themes                          │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'Mofiqul/vscode.nvim',
    cond = function() return require('plugins.colorscheme').colorscheme == 'vscode' end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'ellisonleao/gruvbox.nvim',
    cond = function() return require('plugins.colorscheme').colorscheme == 'gruvbox' end,
    config = function() require('plugins.colorscheme').setup() end,
  }
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

  if packer_bootstrap then
    require('packer').sync()
  end
end)
