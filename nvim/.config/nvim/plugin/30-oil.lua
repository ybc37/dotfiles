vim.pack.add({
  'https://nvim-tree/nvim-web-devicons',
  'https://github.com/stevearc/oil.nvim',
})

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
