return {
  'christoomey/vim-tmux-navigator',
  'onsails/lspkind.nvim',
  'RRethy/vim-illuminate',
  'tpope/vim-eunuch',
  'tpope/vim-repeat',
  'tpope/vim-surround',
  'tpope/vim-unimpaired',
  'wellle/targets.vim',

  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
  },

  {
    'famiu/bufdelete.nvim',
    config = function()
      vim.keymap.set('n', '<Leader>x', require('bufdelete').bufdelete, { silent = true })
    end,
  },

  {
    'folke/ts-comments.nvim',
    opts = {},
    event = 'VeryLazy',
  },

  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({
        filetypes = {
          '*',
          css = { css = true },
        },
        user_default_options = { names = false },
      })
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          component_separators = '',
          section_separators = { left = '🭀', right = '🭦' }, -- U+1FB40 / U+1FB66
        },
        sections = {
          lualine_b = {
            'branch',
            'diff',
            {
              'diagnostics',
              symbols = { error = '● ', warn = '● ', info = '● ', hint = '● ' },
            },
          },
          lualine_c = { { 'filename', path = 1 } },
          lualine_x = {
            { 'encoding' },
            { 'fileformat', icons_enabled = false },
            { 'filetype', icons_enabled = false },
          },
        },
      })
    end,
  },

  {
    'creativenull/efmls-configs-nvim',
    version = 'v1.x.x',
    dependencies = { 'neovim/nvim-lspconfig' },
  },

  {
    'ray-x/lsp_signature.nvim',
    config = function()
      require('lsp_signature').setup({
        hint_enable = false, -- hint doesn't disappear when triggered manually (<gs>) -> disable for now
        hint_prefix = '⮞ ',
      })
    end,
  },
}
