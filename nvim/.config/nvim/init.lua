-- Highlight current line
vim.opt.cursorline = true

-- Abbrev. of messages (avoids 'hit enter')
vim.opt.shortmess = 'filmnrxoOtTIcF'

-- Start diff mode with vertical splits (unless explicitly specified otherwise).
vim.opt.diffopt:append({ 'vertical' })

-- Print the line number in front of each line.
vim.opt.number = true

-- Case insensitive search
vim.opt.ignorecase = true

-- Case sensitive when uc present
vim.opt.smartcase = true

-- Minimum lines to keep above and below cursor
vim.opt.scrolloff = 3

-- Folds based on tree-sitter (see workaround below)
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

-- Sets 'foldlevel' when starting to edit another buffer in a window.
vim.opt.foldlevelstart = 99

-- Highlight problematic whitespace
vim.opt.list = true
vim.opt.listchars = 'tab:› ,trail:•,extends:#,nbsp:.'

-- do not wrap long lines
vim.opt.wrap = false

-- Number of spaces to use for each step of (auto)indent.
vim.opt.shiftwidth = 4

-- Tabs are spaces, not tabs
vim.opt.expandtab = true

-- Number of spaces that a <Tab> in the file counts for.
vim.opt.tabstop = 4

-- Puts new split window to the right/bottom of the current
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Maximum width of text that is being inserted.
vim.opt.textwidth = 80

-- Highlight column after 'textwidth'
vim.opt.colorcolumn = '+1'

-- Don't auto-wrap text using textwidth
vim.opt.formatoptions:remove({ 't' })

-- nosplit: Shows the effects of a command incrementally, as you type.
-- split: Also shows partial off-screen results in a preview window.
vim.opt.inccommand = 'split'

-- Enables mouse support.
vim.opt.mouse = 'a'

-- Always draw the signcolumn.
vim.opt.signcolumn = 'yes'

-- use true color (24-bit) in the terminal
vim.opt.termguicolors = true

-- disable modeline
vim.opt.modeline = false

-- the following settings are used when `wrap` is on (e.g. by using
-- vim-unimpaired `yow`).
-- If on, Vim will wrap long lines at a character in 'breakat' rather than at
-- the last character that fits on the screen.
vim.opt.linebreak = true

-- Every wrapped line will continue visually indented (same amount of space as
-- the beginning of that line), thus preserving horizontal blocks of text.
vim.opt.breakindent = true

-- String to put at the start of lines that have been wrapped.
vim.opt.showbreak = '↳ '

-- Automatically save/restore undo history using an undo file.
-- undodir: default `$XDG_DATA_HOME/nvim/undo`
vim.opt.undofile = true

-- Don't show mode (insert, replace, visual) in last line.
vim.opt.showmode = false

vim.opt.spelllang = 'en_us,de_de'
vim.opt.spelloptions = 'camel'

vim.opt.winborder = 'single'

-- Prevent blinking curser in :terminal
vim.opt.guicursor:append('t:blinkon0')

--

vim.g.mapleader = ' '

vim.keymap.set('n', '<Leader>ce', ':e $MYVIMRC<CR>')
vim.keymap.set('n', '<Leader>cs', ':so $MYVIMRC<CR>')

vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('i', 'kj', '<Esc>')

vim.keymap.set('n', '<Leader>w', ':w<CR>', { silent = true })
vim.keymap.set('n', '<Leader>x', ':bd<CR>', { silent = true })
vim.keymap.set('n', '<Leader>q', ':q<CR>', { silent = true })
vim.keymap.set('n', '<Tab>', ':b#<CR>', { silent = true })

vim.keymap.set('n', '<Leader>v', ':vs<CR>')

-- " copy & paste to system clipboard
vim.keymap.set({ 'n', 'v' }, '<Leader>y', '"+y')
vim.keymap.set('n', '<Leader>Y', '"+y$')
vim.keymap.set({ 'n', 'v' }, '<Leader>d', '"+d')
vim.keymap.set({ 'n', 'v' }, '<Leader>p', '"+p')
vim.keymap.set({ 'n', 'v' }, '<Leader>P', '"+P')

--

local function copy_buffer_path(modifiers)
  local path = vim.fn.expand('%' .. (modifiers or ''))
  vim.fn.setreg('+', path)
end

-- copy relative path (src/foo.txt):
vim.keymap.set('n', '<Leader>cr', copy_buffer_path)

-- copy absolute path (/something/src/foo.txt):
vim.keymap.set('n', '<Leader>ca', function()
  copy_buffer_path(':p')
end)

-- copy filename (foo.txt):
vim.keymap.set('n', '<Leader>cf', function()
  copy_buffer_path(':t')
end)

-- copy directory name (/something/src):
vim.keymap.set('n', '<Leader>cd', function()
  copy_buffer_path(':p:h')
end)

--

vim.keymap.set('n', '<Leader>/', ':noh<CR>', { silent = true })

-- Wrapped lines goes down/up to next row, rather than next line in file.
vim.keymap.set({ 'n', 'v', 'o' }, 'j', 'gj')
vim.keymap.set({ 'n', 'v', 'o' }, 'k', 'gk')

-- HACK: close floating windows
-- Should be obsolete, once this feature is implemented:
-- https://github.com/neovim/neovim/issues/9663
vim.keymap.set('n', '<Esc>', function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= '' and config.focusable then -- `relative` is empty for normal windows.
      vim.api.nvim_win_close(win, false)
    end
  end
end)

-- Substitute
vim.keymap.set({ 'n', 'v' }, '<Leader>r', ':s/\\v')
vim.keymap.set('n', '<Leader>R', ':%s/\\v')

--

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  desc = 'Hightlight yanked text',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

--

if vim.fn.executable('trash') then
  -- vim-eunuch provides unix commands (`Delete`, `Move`,...) -> also add `Trash`
  -- via `trash-cli` (https://github.com/andreafrancia/trash-cli/)

  local trash = function()
    local file_path = vim.api.nvim_buf_get_name(0)
    local command = 'trash ' .. file_path
    os.execute(command)
    vim.cmd.bdelete()
  end

  vim.api.nvim_create_user_command('Trash', trash, {})
end

--

local function markdown_toggle_checkbox()
  local view = vim.fn.winsaveview()
  vim.cmd([[keeppatterns s/^\s*[*-]\s*\[\zs.\ze\]/\=get({" ": "x", "x": " "}, submatch(0), " ")/e]])
  vim.fn.winrestview(view)
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('filetype_markdown', {}),
  pattern = 'markdown',
  callback = function()
    vim.keymap.set('n', 'X', markdown_toggle_checkbox, { buffer = true, silent = true })
  end,
})

--

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins')

vim.cmd.colorscheme('gruvbox')
