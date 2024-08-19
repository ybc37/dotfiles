return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('fzf-lua').setup({
      'fzf-native',

      fzf_opts = {
        ['--cycle'] = true,
      },

      winopts = {
        preview = {
          flip_columns = 180,
        },
      },

      hls = {
        backdrop = 'Normal',
      },

      keymap = {
        fzf = {
          ['alt-a'] = 'select-all+accept',
        },
      },
    })

    local fzf_lua = require('fzf-lua')

    fzf_lua.register_ui_select()

    vim.keymap.set({ 'n', 'v' }, '<Leader><Leader>', fzf_lua.builtin)
    vim.keymap.set('n', '<C-t>', fzf_lua.files)
    vim.keymap.set('n', '<Leader><tab>', fzf_lua.buffers)
    vim.keymap.set('n', '<Leader>gg', fzf_lua.live_grep)
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
