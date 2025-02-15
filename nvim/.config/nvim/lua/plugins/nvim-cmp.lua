return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require('cmp')
      local lspkind = require('lspkind')

      cmp.setup({
        formatting = {
          format = lspkind.cmp_format(),
        },

        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-l>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        }),

        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'calc' },
          { name = 'path' },
        }, {
          { name = 'buffer' },
        }),
      })
    end,
  },

  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()

      local ls = require('luasnip')
      ls.filetype_extend('ruby', { 'rails' })
      ls.filetype_extend('all', { 'loremipsum' })

      vim.keymap.set({ 'i' }, '<A-l>', function()
        ls.expand()
      end, { silent = true })
      vim.keymap.set({ 'i', 's' }, '<A-n>', function()
        ls.jump(1)
      end, { silent = true })
      vim.keymap.set({ 'i', 's' }, '<A-p>', function()
        ls.jump(-1)
      end, { silent = true })

      vim.keymap.set({ 'i', 's' }, '<A-j>', function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true })

      vim.keymap.set({ 'i', 's' }, '<C-e>', function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true })
    end,
  },
  { 'saadparwaiz1/cmp_luasnip' },
}
