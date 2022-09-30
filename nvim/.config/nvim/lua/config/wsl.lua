-- https://superuser.com/questions/1291425/windows-subsystem-linux-make-vim-use-the-clipboard
-- https://github.com/equalsraf/win32yank
vim.g.clipboard = {
  name = 'win32yank',
  copy = {
    ['+'] = 'win32yank.exe -i --crlf',
    ['*'] = 'win32yank.exe -i --crlf',
  },
  paste = {
     ['+'] = 'win32yank.exe -o --lf',
     ['*'] = 'win32yank.exe -o --lf',
  },
  cache_enabled = true,
}

-- workaround: on windows nvim doesn't show spelling errors with underline when
-- `TERM=alacritty`.
-- Needs to be set after `vim.cmd.colorscheme('gruvbox')` (or in an autocmd:
-- `vim.api.nvim_create_autocmd('ColorScheme', { [...]`).
vim.api.nvim_set_hl(0, 'SpellBad', { underline = true })
