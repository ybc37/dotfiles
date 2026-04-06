vim.pack.add({
  'https://github.com/RRethy/vim-illuminate',
  'https://github.com/brenoprata10/nvim-highlight-colors',
  'https://github.com/christoomey/vim-tmux-navigator',
  'https://github.com/ellisonleao/gruvbox.nvim',
  'https://github.com/famiu/bufdelete.nvim',
  'https://github.com/folke/ts-comments.nvim',
  'https://github.com/tpope/vim-repeat',
  'https://github.com/tpope/vim-surround',
  'https://github.com/tpope/vim-unimpaired',
  'https://github.com/wellle/targets.vim',
  'https://github.com/windwp/nvim-autopairs',
})

vim.cmd.colorscheme('gruvbox')

require('ts-comments').setup()
require('nvim-highlight-colors').setup()

vim.keymap.set('n', '<Leader>x', require('bufdelete').bufdelete, { silent = true })

local npairs = require('nvim-autopairs')
npairs.setup({
  -- https://github.com/windwp/nvim-autopairs?tab=readme-ov-file#fastwrap
  fast_wrap = {},
})
