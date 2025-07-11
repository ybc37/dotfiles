return {
  'christoomey/vim-tmux-navigator',
  'RRethy/vim-illuminate',
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
    'brenoprata10/nvim-highlight-colors',
    opts = {},
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          component_separators = '',
          section_separators = { left = '🭀', right = '🭦' }, -- U+1FB40 / U+1FB66
          always_show_tabline = false,
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
        tabline = {
          lualine_a = {
            { 'tabs', mode = 2 },
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
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },

  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local oil = require('oil')

      oil.setup({
        delete_to_trash = true,

        -- Enhances to default keymaps
        keymaps = {
          ['<C-h>'] = false,
          ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
          ['<C-s>'] = { 'actions.select', opts = { horizontal = true } },
          ['<Esc>'] = { 'actions.close', mode = 'n' },
          ['<C-l>'] = false,
          ['<C-r>'] = 'actions.refresh',
        },
      })

      vim.keymap.set('n', '-', oil.open, { noremap = true })
    end,
  },
}
