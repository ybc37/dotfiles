" When set to "dark", Vim will try to use colors that look good on a dark background.
" -> might become default in neovim: https://github.com/neovim/neovim/issues/2676
set background=dark

" Allow buffer switching without saving
set hidden

" Highlight current line
set cursorline

" Abbrev. of messages (avoids 'hit enter')
set shortmess+=filmnrxoOtTI

" Start diff mode with vertical splits (unless explicitly specified otherwise).
set diffopt+=vertical

" Print the line number in front of each line.
set number

" Changes the displayed number to be relative to the cursor.
set relativenumber

" Case insensitive search
set ignorecase

" Case sensitive when uc present
set smartcase

" make command line always ignore case
augroup dynamic_smartcase
    autocmd!
    autocmd CmdLineEnter : set nosmartcase
    autocmd CmdLineLeave : set smartcase
augroup END

" Minimum lines to keep above and below cursor
set scrolloff=3

" Syntax highlighting items specify folds.
set foldmethod=syntax

" Sets 'foldlevel' when starting to edit another buffer in a window.
set foldlevelstart=99

" Highlight problematic whitespace
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.

" do not wrap long lines
set nowrap

" Number of spaces to use for each step of (auto)indent.
set shiftwidth=4

" Tabs are spaces, not tabs
set expandtab

" Number of spaces that a <Tab> in the file counts for.
set tabstop=4

" Prevents inserting two spaces after punctuation on a join (J)
set nojoinspaces

" Puts new split window to the right/bottom of the current
set splitright
set splitbelow

" Maximum width of text that is being inserted.
set textwidth=80

" Don't auto-wrap text using textwidth
set formatoptions-=t

" If this many milliseconds nothing is typed the swap file will be written to disk
" (default 4000 -> decreased for vim-gitgutter, so it updates faster)
set updatetime=250

" nosplit: Shows the effects of a command incrementally, as you type.
" split  : Also shows partial off-screen results in a preview window.
set inccommand=split

" Enables mouse support.
set mouse=a

" Whether or not to draw the signcolumn.
" (default: auto, no, yes)
set signcolumn=yes

" use true color (24-bit) in the terminal
set termguicolors

" disable modeline
set nomodeline

" the following settings are used when `wrap` is on (e.g. by using
" vim-unimpaired `yow`)
"
" If on, Vim will wrap long lines at a character in 'breakat' rather than at the
" last character that fits on the screen.
set linebreak
" Every wrapped line will continue visually indented (same amount of space as
" the beginning of that line), thus preserving horizontal blocks of text.
set breakindent
" String to put at the start of lines that have been wrapped.
set showbreak=↳\ 

" automatically save/restore undo history using an undo file
" undodir: default `$XDG_DATA_HOME/nvim/undo`
set undofile

" don't show mode (insert, replace, visual) in last line
set noshowmode

let mapleader="\<Space>"

inoremap jk <Esc>
inoremap kj <Esc>

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

nnoremap <silent> <Leader>w :w<CR>
nnoremap <silent> <Leader>x :bd<CR>
nnoremap <silent> <Leader>q :q<CR>
nnoremap <silent> <Tab> :b#<CR>

" splits
nnoremap <silent> <Leader>v :vs<CR>

" copy & paste to system clipboard
vnoremap <Leader>y "+y
nnoremap <Leader>y "+y
nnoremap <Leader>Y "+y$
vnoremap <Leader>d "+d
nnoremap <Leader>d "+d
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>p "+p
vnoremap <Leader>P "+P

" copy relative path (src/foo.txt):
nnoremap <Leader>cr :let @+=expand("%")<CR>
" copy absolute path (/something/src/foo.txt):
nnoremap <Leader>ca :let @+=expand("%:p")<CR>
" copy filename (foo.txt):
nnoremap <Leader>cf :let @+=expand("%:t")<CR>
" copy directory name (/something/src):
nnoremap <Leader>cd :let @+=expand("%:p:h")<CR>

nnoremap <silent> <Leader>/ :noh<CR>

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

" Use Leader+ESC to exit insert mode in :term
tnoremap <Leader><Esc> <C-\><C-n>

" fzf.vim
nnoremap <C-p> :Files<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>g :Rg 
nnoremap <Leader>s :GitFiles?<CR>
nnoremap <Leader><Tab> :Buffers<CR>
nnoremap <Leader>t :Tags 
nnoremap <Leader>T :BTags 
imap <c-x><c-f> <plug>(fzf-complete-path)


" notes
let s:note_path = "~/documents/notes/"
command! -bang -nargs=* RgNotes call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case " . shellescape(<q-args>), 1, {"dir": s:note_path}, <bang>0)
command! -bang -nargs=0 Notes call fzf#vim#files(<q-args>, {"dir": s:note_path}, <bang>0)
nnoremap <Leader>ee :Notes<CR>
nnoremap <Leader>eE :Notes!<CR>
nnoremap <Leader>eg :RgNotes 
nnoremap <Leader>eG :RgNotes! 
execute "nnoremap <Leader>ef :e " . s:note_path
execute "nnoremap <Leader>ed :!mkdir -p " . s:note_path


" Plugins
call plug#begin("~/.local/share/nvim/plugged")
Plug 'RRethy/vim-illuminate'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'airblade/vim-gitgutter'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
Plug 'christoomey/vim-tmux-navigator'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mattn/emmet-vim'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth' " disabled for md, see ~/.config/nvim/after/ftplugin/markdown.vim
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'wellle/targets.vim'

" languages
Plug 'sheerun/vim-polyglot'
Plug 'amadeus/vim-mjml'

" clojure plugins for live coding with overtone
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-classpath'

" colorscheme
Plug 'joshdick/onedark.vim'
call plug#end()

" autozimu/LanguageClient-neovim
let g:LanguageClient_serverCommands = {
    \ 'javascript': ['~/dev/language-servers/js/node_modules/.bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['~/dev/language-servers/js/node_modules/.bin/javascript-typescript-stdio'],
    \ 'php': ['php', '~/dev/language-servers/php/vendor/bin/php-language-server.php'],
    \ 'css': ['~/dev/language-servers/css/node_modules/.bin/css-languageserver', '--stdio'],
    \ 'scss': ['~/dev/language-servers/css/node_modules/.bin/css-languageserver', '--stdio'],
    \ }

" apply mappings only for buffers with supported filetypes
function! LC_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    nnoremap <buffer> <F5> :call LanguageClient_contextMenu()<CR>
    nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>
    nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <buffer> <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
  endif
endfunction

augroup langClient
  autocmd!
  autocmd FileType * call LC_maps()
augroup END

" Shougo/deoplete.nvim
let g:deoplete#enable_at_startup = 1

" joshdick/onedark.vim
" override: Don't set a background color when running in a terminal; just use
" the terminal's background color
" `gui` is the hex color code used in GUI mode/nvim true-color mode
" `cterm` is the color code used in 256-color mode
" `cterm16` is the color code used in 16-color mode
if (has("autocmd") && !has("gui_running"))
  augroup colorset
    autocmd!
    let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16": "7" }
    autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
  augroup END
endif

if (has("autocmd"))
  augroup colorextend
    autocmd!
    autocmd ColorScheme * call onedark#extend_highlight("CursorLine", { "bg": { "gui": "#2f2f2f" } })

    " set background for highlight groups used by LanguageClient-neovim in virtual texts (showing errors/warnings)
    autocmd ColorScheme * call onedark#extend_highlight("Error", { "bg": { "gui": "#3E4452" } })
    autocmd ColorScheme * call onedark#extend_highlight("Todo", { "bg": { "gui": "#3E4452" } })
  augroup END
endif

colorscheme onedark

" itchyny/lightline.vim
let g:lightline = { 'colorscheme': 'onedark' }

" RRethy/vim-illuminate
hi link illuminatedWord Visual " use highlight group `Visual` for highlighting words
let g:Illuminate_highlightUnderCursor = 0 " Don't highlight word under cursor (default: 1)

" Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_file_list_command = 'rg --files'
let g:gutentags_ctags_tagfile = '.git/tags'
