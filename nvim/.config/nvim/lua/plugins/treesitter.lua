return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = function()
      require('nvim-treesitter').install('unstable')
      require('nvim-treesitter').update()
    end,
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local filetype = args.match
          local lang = vim.treesitter.language.get_lang(filetype)
          if vim.treesitter.language.add(lang) then
            require('utils').set_win_foldexpr('v:lua.vim.treesitter.foldexpr()')
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.treesitter.start()
          end
        end,
      })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    config = function()
      require('nvim-treesitter-textobjects').setup({
        select = {
          lookahead = true,
          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'V',
            ['@class.outer'] = 'V',
          },
        },
        move = {
          set_jumps = true,
        },
      })

      local ts_exec = function(module, func_name, query_string)
        return function()
          require('nvim-treesitter-textobjects.' .. module)[func_name](query_string, 'textobjects')
        end
      end

      local ts_select = function(query_string)
        return ts_exec('select', 'select_textobject', query_string)
      end

      local ts_swap = function(func_name, query_string)
        return ts_exec('swap', func_name, query_string)
      end

      local ts_move = function(func_name, query_string)
        return ts_exec('move', func_name, query_string)
      end

      vim.keymap.set({ 'x', 'o' }, 'af', ts_select('@function.outer'))
      vim.keymap.set({ 'x', 'o' }, 'if', ts_select('@function.inner'))
      vim.keymap.set({ 'x', 'o' }, 'ac', ts_select('@class.outer'))
      vim.keymap.set({ 'x', 'o' }, 'ic', ts_select('@class.inner'))
      vim.keymap.set({ 'x', 'o' }, 'aa', ts_select('@parameter.outer'))
      vim.keymap.set({ 'x', 'o' }, 'ia', ts_select('@parameter.inner'))

      vim.keymap.set('n', '<leader>a', ts_swap('swap_next', '@parameter.inner'))
      vim.keymap.set('n', '<leader>A', ts_swap('swap_previous', '@parameter.outer'))

      vim.keymap.set({ 'n', 'x', 'o' }, ']m', ts_move('goto_next_start', '@function.outer'))
      vim.keymap.set({ 'n', 'x', 'o' }, ']]', ts_move('goto_next_start', '@class.outer'))
      vim.keymap.set({ 'n', 'x', 'o' }, ']a', ts_move('goto_next_start', '@parameter.outer'))

      vim.keymap.set({ 'n', 'x', 'o' }, ']M', ts_move('goto_next_end', '@function.outer'))
      vim.keymap.set({ 'n', 'x', 'o' }, '][', ts_move('goto_next_end', '@class.outer'))
      vim.keymap.set({ 'n', 'x', 'o' }, ']A', ts_move('goto_next_end', '@parameter.outer'))

      vim.keymap.set({ 'n', 'x', 'o' }, '[m', ts_move('goto_previous_start', '@function.outer'))
      vim.keymap.set({ 'n', 'x', 'o' }, '[[', ts_move('goto_previous_start', '@class.outer'))
      vim.keymap.set({ 'n', 'x', 'o' }, '[a', ts_move('goto_previous_start', '@parameter.outer'))

      vim.keymap.set({ 'n', 'x', 'o' }, '[M', ts_move('goto_previous_end', '@function.outer'))
      vim.keymap.set({ 'n', 'x', 'o' }, '[]', ts_move('goto_previous_end', '@class.outer'))
      vim.keymap.set({ 'n', 'x', 'o' }, '[A', ts_move('goto_previous_end', '@parameter.outer'))

      vim.keymap.set({ 'n', 'x', 'o' }, ']i', ts_move('goto_next', '@conditional.outer'))
      vim.keymap.set({ 'n', 'x', 'o' }, '[i', ts_move('goto_previous', '@conditional.outer'))

      -- Disable mappings of Python ftplugin (/usr/share/nvim/runtime/ftplugin/python.vim)
      vim.g.no_python_maps = true
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      local ts_context = require('treesitter-context')
      ts_context.setup({
        separator = '─',
        max_lines = '15%',
      })

      vim.keymap.set('n', 'gC', ts_context.go_to_context, { silent = true })
    end,
  },
}
