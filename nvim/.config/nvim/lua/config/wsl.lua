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
