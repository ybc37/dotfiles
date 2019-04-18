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

nnoremap <silent> <leader>/ :noh<CR>

" toggle line wrapping
nmap <F10> :set wrap! linebreak!<CR>

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
imap <c-x><c-f> <plug>(fzf-complete-path)



" Plugins
call plug#begin("~/.local/share/nvim/plugged")
Plug 'RRethy/vim-illuminate'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'airblade/vim-gitgutter'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
Plug 'christoomey/vim-tmux-navigator'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
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

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

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
    let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
    autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting

    " optimize visual color -> maybe use g:onedark_color_overrides (https://github.com/joshdick/onedark.vim/#global-color-overrides)?
    let s:visual_grey = { "gui": "#3E4452", "cterm": "238", "cterm16": "15" } " cterm: 237 -> 238
    autocmd ColorScheme * call onedark#set_highlight("Visual", { "bg": s:visual_grey })
  augroup END
endif

colorscheme onedark

" set background for highlight groups used by LanguageClient-neovim in virtual
" texts (showing errors/warnings)
hi Error ctermbg=238
hi Todo ctermbg=238

" itchyny/lightline.vim
let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ }

" oni specific config
if exists("g:gui_oni")
    set noswapfile

    " Turn off statusbar, because it is externalized
    set noshowmode
    set noruler
    set laststatus=0
    set noshowcmd

    " Enable GUI mouse behavior
    set mouse=a
endif
