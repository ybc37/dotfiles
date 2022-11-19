require('telescope').load_extension('fzf')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-t>', builtin.find_files)
vim.keymap.set('n', '<Leader>ff', builtin.find_files)
vim.keymap.set('n', '<Leader><tab>', builtin.buffers)
vim.keymap.set('n', '<Leader>fb', builtin.buffers)
vim.keymap.set('n', '<Leader>frg', builtin.live_grep)
vim.keymap.set('n', '<Leader>f:', builtin.command_history)
vim.keymap.set('n', '<Leader>f/', builtin.search_history)
vim.keymap.set('n', '<Leader>fh', builtin.help_tags)
vim.keymap.set('n', '<Leader>fk', builtin.keymaps)
vim.keymap.set('n', '<Leader>fqq', builtin.quickfix)
vim.keymap.set('n', '<Leader>fqh', builtin.quickfixhistory)
vim.keymap.set('n', '<Leader>fl', builtin.loclist)
vim.keymap.set('n', 'z=', builtin.spell_suggest)
vim.keymap.set('n', '<Leader>fgs', builtin.git_status)
vim.keymap.set('n', '<Leader>ft', builtin.treesitter)


local notes_dir = '~/documents/notes/'

function find_notes()
  builtin.find_files {
    cwd = notes_dir
  }
end

function live_grep_notes()
  builtin.live_grep {
    cwd = notes_dir
  }
end

vim.keymap.set('n', '<Leader>ee', find_notes)
vim.api.nvim_create_user_command('Notes', 'lua find_notes()', {})

vim.keymap.set('n', '<Leader>eg', live_grep_notes)
vim.api.nvim_create_user_command('NotesGrep', 'lua live_grep_notes()', {})

vim.keymap.set('n', '<Leader>ef', ':e ' .. notes_dir)
vim.keymap.set('n', '<Leader>ed', ':!mkdir -p ' .. notes_dir)
