return {
  'ggandor/leap.nvim',
  config = function()
    vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward)')
    vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Plug>(leap-backward)')
    vim.keymap.set({ 'n', 'x', 'o' }, '<leader>S', '<Plug>(leap-from-window)')

    require('leap').opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }

    vim.keymap.set({ 'n', 'x', 'o' }, 'ga', function()
      require('leap.treesitter').select()
    end)

    vim.keymap.set({ 'n', 'x', 'o' }, 'gA', 'V<cmd>lua require("leap.treesitter").select()<cr>')

    vim.keymap.set({ 'n', 'o' }, '<leader>s', function()
      require('leap.remote').action()
    end)
  end,
}
