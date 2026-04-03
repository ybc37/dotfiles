return {
  'https://codeberg.org/andyg/leap.nvim',
  config = function()
    vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward)')
    vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Plug>(leap-backward)')
    vim.keymap.set({ 'n', 'x', 'o' }, '<leader>S', '<Plug>(leap-from-window)')

    require('leap').opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }

    vim.keymap.set({ 'x', 'o' }, 'R', function()
      require('leap.treesitter').select({
        -- increase/decrease selection with traversal keys, e.g.: vRRRRrr
        opts = require('leap.user').with_traversal_keys('R', 'r'),
      })
    end)

    vim.keymap.set({ 'n', 'o' }, 'gs', function()
      require('leap.remote').action()
    end)

    vim.keymap.set({ 'n', 'o' }, 'g/', function()
      require('leap.remote').action({ jumper = '/' })
    end)

    vim.keymap.set({ 'n', 'o' }, 'g?', function()
      require('leap.remote').action({ jumper = '?' })
    end)
  end,
}
