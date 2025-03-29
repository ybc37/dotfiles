return {
  'saghen/blink.cmp',
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
  version = '1.*',
  opts = {
    completion = {
      menu = {
        max_height = 20,
      },

      documentation = {
        auto_show = true,
      },
    },

    cmdline = {
      enabled = false,
    },

    sources = {
      providers = {
        snippets = {
          opts = {
            global_snippets = { 'all', 'loremipsum' },
          },
        },
      },
    },

    signature = {
      enabled = true,
    },

    keymap = {
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },

      ['<C-n>'] = { 'show', 'select_next', 'fallback_to_mappings' },
      ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },

      ['<Tab>'] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        'snippet_forward',
        'fallback',
      },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

      ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },

      ['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },
  },
}
