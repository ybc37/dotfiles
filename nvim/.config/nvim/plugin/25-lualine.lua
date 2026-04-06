vim.pack.add({
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-lualine/lualine.nvim',
})

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
