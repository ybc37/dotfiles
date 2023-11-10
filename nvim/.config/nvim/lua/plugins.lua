return {
  { 'RRethy/vim-illuminate' },
  { 'christoomey/vim-tmux-navigator' },

  { "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = true,
    config = function()
      require("gruvbox").setup({
        overrides = {
          ['@text.todo.checked'] = { fg = '#fe8019', bg = '#3c3836' },
          ['@text.todo.unchecked'] = { fg = '#fe8019', bg = '#3c3836' },
        }
      })
    end,
  },

  {
    'junegunn/gv.vim',
    dependencies = { 'tpope/vim-fugitive' },
  },

  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = false,
          component_separators = '',
          section_separators = { left = '🭀', right = '🭦' }, -- U+1FB40 / U+1FB66
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
    'creativenull/efmls-configs-nvim',
    version = 'v1.x.x',
    dependencies = { 'neovim/nvim-lspconfig' },
  }
}
