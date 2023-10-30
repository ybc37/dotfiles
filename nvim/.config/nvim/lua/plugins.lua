return {
  { 'RRethy/vim-illuminate' },
  { 'christoomey/vim-tmux-navigator' },
  { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true },

  {
    'junegunn/gv.vim',
    dependencies = { 'tpope/vim-fugitive' },
  },

  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({
        'css';
        'scss';
      })
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = false,
          component_separators = '|',
          section_separators = '',
        },
        sections = {
          lualine_c = {{'filename', path = 1}}
        }
      }
    end,
  },

  { 'tpope/vim-commentary' },
  { 'tpope/vim-eunuch' },
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-unimpaired' },
  { 'wellle/targets.vim' },

  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.prettier,
        },
      })
    end
  }
}
