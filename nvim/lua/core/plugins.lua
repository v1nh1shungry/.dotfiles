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

-- Bootstrap packer.nvim
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- Basic Enhancement
  use "nathom/filetype.nvim"
  use 'RRethy/vim-illuminate'
  use 'andymass/vim-matchup'
  use 'farmergreg/vim-lastplace'
  use 'lewis6991/impatient.nvim'
  use 'machakann/vim-highlightedyank'
  use 'michaeljsmith/vim-indent-object'
  use 'ntpeters/vim-better-whitespace'
  use 'romainl/vim-cool'
  use 'tpope/vim-unimpaired'
  use 'wellle/targets.vim'
  -- Edit Enhancement
  use "lukas-reineke/indent-blankline.nvim"
  use 'junegunn/vim-easy-align'
  use 'tommcdo/vim-exchange'
  use {'kylechui/nvim-surround', tag = '*', config = function() require('nvim-surround').setup() end}
  use {'numToStr/Comment.nvim', config = function() require('Comment').setup() end}
  use {'windwp/nvim-autopairs', config = function() require('nvim-autopairs').setup() end}
  -- Intellisense
  use 'L3MON4D3/LuaSnip'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/nvim-cmp'
  use 'neovim/nvim-lspconfig'
  use 'rafamadriz/friendly-snippets'
  use 'saadparwaiz1/cmp_luasnip'
  use 'williamboman/mason-lspconfig.nvim'
  use 'williamboman/mason.nvim'
  -- UI
  use 'akinsho/toggleterm.nvim'
  use 'folke/trouble.nvim'
  use 'mbbill/undotree'
  use 'ray-x/lsp_signature.nvim'
  use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'kyazdani42/nvim-web-devicons'}
  use {'folke/todo-comments.nvim', requires = 'nvim-lua/plenary.nvim'}
  use {'glepnir/lspsaga.nvim', branch = 'main'}
  use {'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup() end}
  use {'nvim-lualine/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true}}
  use {'nvim-tree/nvim-tree.lua', requires = {'nvim-tree/nvim-web-devicons'}, tag = 'nightly'}
  -- Tools
  use 'brooth/far.vim'
  use 'dstein64/vim-startuptime'
  use 'phaazon/hop.nvim'
  use 'rhysd/clever-f.vim'
  use 'simeji/winresizer'
  use 'tpope/vim-fugitive'
  -- Themes
  use 'lunarvim/darkplus.nvim'

  if packer_bootstrap then
    require('packer').sync()
  end
end)
