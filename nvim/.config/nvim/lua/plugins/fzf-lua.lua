return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('fzf-lua').setup({
      'fzf-native',

      fzf_opts = {
        ['--border'] = 'none',
        ['--cycle'] = true,
      },

      winopts = {
        border = 'single',
        preview = {
          border = function(_, metadata)
            local border_location = {
              right = 'left',
              left = 'right',
              up = 'down',
              down = 'up',
            }
            return 'border-' .. border_location[metadata.layout]
          end,
          flip_columns = 180,
        },
      },

      hls = {
        backdrop = 'Normal',
      },

      keymap = {
        fzf = {
          true,
          ['ctrl-d'] = 'preview-page-down',
          ['ctrl-u'] = 'preview-page-up',
          ['ctrl-j'] = 'preview-down',
          ['ctrl-k'] = 'preview-up',
          ['ctrl-q'] = 'select-all+accept',
        },
      },

      defaults = {
        formatter = 'path.filename_first',
      },

      lsp = {
        jump1 = false,
      },

      grep = {
        rg_glob = true,
        glob_flag = '--iglob',
        glob_separator = '%s%-%-',
      },
    })

    local fzf_lua = require('fzf-lua')

    fzf_lua.register_ui_select()

    vim.keymap.set({ 'n', 'v' }, '<Leader><Leader>', fzf_lua.builtin)
    vim.keymap.set({ 'n', 'v' }, '<Leader><BS>', fzf_lua.resume)
    vim.keymap.set('n', '<C-t>', fzf_lua.files)
    vim.keymap.set('n', '<Leader><tab>', fzf_lua.buffers)
    vim.keymap.set('n', '<Leader>gg', fzf_lua.live_grep)
    vim.keymap.set('n', '<Leader>gq', fzf_lua.grep_quickfix)
    vim.keymap.set('n', '<Leader>gs', fzf_lua.grep_cword)
    vim.keymap.set('n', 'z=', fzf_lua.spell_suggest)
    vim.keymap.set('n', '<Leader>fs', fzf_lua.git_status)

    -- TODO: Move notes in separate config?
    local notes_dir = '~/documents/notes/'

    local notes = {}
    function notes.find()
      fzf_lua.files({
        cwd = notes_dir,
      })
    end
    function notes.live_grep()
      fzf_lua.live_grep({
        cwd = notes_dir,
      })
    end

    vim.keymap.set('n', '<Leader>ee', notes.find)
    vim.api.nvim_create_user_command('Notes', notes.find, {})

    vim.keymap.set('n', '<Leader>eg', notes.live_grep)
    vim.api.nvim_create_user_command('NotesGrep', notes.live_grep, {})

    vim.keymap.set('n', '<Leader>ef', ':e ' .. notes_dir)
    vim.keymap.set('n', '<Leader>ed', ':!mkdir -p ' .. notes_dir)
  end,
}
