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

  use { 'neovim/nvim-lspconfig' }

  use {
      'nvim-treesitter/nvim-treesitter',
      run = function()
        local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
        ts_update()
      end,
  }

  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } },
  }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  use { 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/cmp-buffer' }
  use { 'hrsh7th/cmp-calc' }
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-path' }
  use { 'hrsh7th/cmp-cmdline' }

  use { 'L3MON4D3/LuaSnip' }
  use { 'saadparwaiz1/cmp_luasnip' }

  use { 'JoosepAlviste/nvim-ts-context-commentstring' }
  use { 'RRethy/vim-illuminate' }
  use { 'christoomey/vim-tmux-navigator' }
  use { 'ellisonleao/gruvbox.nvim' }
  use { 'junegunn/gv.vim' }
  use { 'lewis6991/gitsigns.nvim', tag = 'release' }
  use { 'mattn/emmet-vim' }
  use { 'norcalli/nvim-colorizer.lua' }
  use { 'nvim-lualine/lualine.nvim' }
  use { 'tpope/vim-commentary' }
  use { 'tpope/vim-eunuch' }
  use { 'tpope/vim-fugitive' }
  use { 'tpope/vim-repeat' }
  use { 'tpope/vim-surround' }
  use { 'tpope/vim-unimpaired' }
  use { 'wellle/targets.vim' }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
