return {
  {
    'nvim-telescope/telescope.nvim',
    enabled = false,
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local builtin = require('telescope.builtin')
      local config = require('telescope.config')

      telescope.load_extension('fzf')

      -- `vimgrep_arguments` will be used for `live_grep` and `grep_string` pickers.
      local vimgrep_arguments = { unpack(config.values.vimgrep_arguments) }
      table.insert(vimgrep_arguments, '--hidden')
      table.insert(vimgrep_arguments, '--glob')
      table.insert(vimgrep_arguments, '!**/.git/*')

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ['<Esc>'] = actions.close,
              ['<C-c>'] = function()
                vim.cmd.stopinsert()
              end,
            },
          },
          vimgrep_arguments = vimgrep_arguments,
          path_display = { 'smart' },
        },
        pickers = {
          find_files = {
            find_command = { 'fd', '--type', 'file', '--hidden', '--exclude', '.git/' },
            previewer = false,
          },
          buffers = {
            sort_mru = true,
            previewer = false,
          },
        },
      })

      vim.keymap.set('n', '<C-t>', builtin.find_files)
      vim.keymap.set('n', '<Leader>ff', builtin.find_files)
      vim.keymap.set('n', '<Leader><tab>', builtin.buffers)
      vim.keymap.set('n', '<Leader>fb', builtin.buffers)
      vim.keymap.set('n', '<Leader>gg', builtin.live_grep)
      vim.keymap.set('n', '<Leader>gs', builtin.grep_string)
      vim.keymap.set('n', '<Leader>go', function()
        builtin.live_grep({ grep_open_files = true })
      end)
      vim.keymap.set('n', '<Leader>f:', builtin.command_history)
      vim.keymap.set('n', '<Leader>f/', builtin.search_history)
      vim.keymap.set('n', '<Leader>fh', builtin.help_tags)
      vim.keymap.set('n', '<Leader>fk', builtin.keymaps)
      vim.keymap.set('n', '<Leader>fqq', builtin.quickfix)
      vim.keymap.set('n', '<Leader>fqh', builtin.quickfixhistory)
      vim.keymap.set('n', '<Leader>fl', builtin.loclist)
      vim.keymap.set('n', 'z=', builtin.spell_suggest)
      vim.keymap.set('n', '<Leader>fs', builtin.git_status)
      vim.keymap.set('n', '<Leader>ft', builtin.treesitter)
      vim.keymap.set({ 'n', 'v' }, '<C-p>', builtin.registers)

      local notes_dir = '~/documents/notes/'

      local notes = {}
      function notes.find()
        builtin.find_files({
          cwd = notes_dir,
        })
      end
      function notes.live_grep()
        builtin.live_grep({
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
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },
}
