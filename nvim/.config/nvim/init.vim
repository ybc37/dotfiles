" Highlight current line
set cursorline

" Abbrev. of messages (avoids 'hit enter')
set shortmess=filmnrxoOtTIcF

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

" TODO: check for treesitter or overwrite when treesitter config is executed?
" Folds based on tree-sitter
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

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

" Puts new split window to the right/bottom of the current
set splitright
set splitbelow

" Maximum width of text that is being inserted.
set textwidth=80

" Don't auto-wrap text using textwidth
set formatoptions-=t

" If this many milliseconds nothing is typed the swap file will be written to disk
" (default 4000 -> decreased for vim-gitgutter, so it updates faster)
set updatetime=100

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

" options for insert mode completion (needed for hrsh7th/nvim-comp)
set completeopt=menu,menuone,noselect

set spelllang=en_us,de_de

let mapleader="\<Space>"

" edit/source config
nnoremap <Leader>ce :e $MYVIMRC<CR>
nnoremap <Leader>cs :so $MYVIMRC<CR>

inoremap jk <Esc>
inoremap kj <Esc>

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

" Close other windows
nnoremap <Leader><Esc> <C-w><C-o>

" fzf.vim
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <Leader>f :Files<CR>
nnoremap <silent> <Leader>F :Files!<CR>
nnoremap <Leader>g :Rg 
nnoremap <Leader>G :Rg! 
nnoremap <silent> <Leader>s :GitFiles?<CR>
nnoremap <silent> <Leader><Tab> :Buffers<CR>
nnoremap <silent> <Leader>h: :History:<CR>
nnoremap <silent> <Leader>h/ :History/<CR>
nnoremap <silent> <Leader>?? :Helptags<CR>
nnoremap <silent> <Leader>?M :Maps<CR>
imap <c-x><c-f> <plug>(fzf-complete-path)

" Substitute
nnoremap <Leader>r :s/\v
vnoremap <Leader>r :s/\v
nnoremap <Leader>R :%s/\v

" notes
let s:note_path = "~/documents/notes/"
command! -bang -nargs=* RgNotes call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case " . shellescape(<q-args>), 1, {"dir": s:note_path}, <bang>0)
command! -bang -nargs=0 Notes call fzf#vim#files(<q-args>, {"dir": s:note_path}, <bang>0)
nnoremap <silent> <Leader>ee :Notes<CR>
nnoremap <silent> <Leader>eE :Notes!<CR>
nnoremap <Leader>eg :RgNotes 
nnoremap <Leader>eG :RgNotes! 
execute "nnoremap <Leader>ef :e " . s:note_path
execute "nnoremap <Leader>ed :!mkdir -p " . s:note_path

if executable('trash')
  " vim-eunuch provides unix commands (`Delete`, `Move`,...) -> also add `Trash`
  " via `trash-cli` (https://github.com/andreafrancia/trash-cli/)
  command! -bar -bang Trash :call system('trash ' . expand('%')) | bdelete<bang>
endif


" markdown
function! s:markdown_toggle_task()
  let view = winsaveview()
  execute 'keeppatterns s/^\s*[*-]\s*\[\zs.\ze\]/\=get({" ": "x", "x": " "}, submatch(0), " ")/e'
  call winrestview(view)
endfunction

augroup filetype_markdown
  autocmd!
  autocmd FileType markdown nnoremap <buffer> <silent> - :call <SID>markdown_toggle_task()<cr>
augroup END


" highlight yanked text for e.g. 250ms
augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank { timeout=250 }
augroup END


" Plugins
call plug#begin("~/.local/share/nvim/plugged")

Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'editorconfig/editorconfig-vim'
Plug 'gruvbox-community/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'justinmk/vim-sneak'
Plug 'lilyinstarlight/vim-sonic-pi'
Plug 'mattn/emmet-vim'
Plug 'psf/black', { 'branch': 'stable' } " if broken, remove `~/.local/share/nvim/black` + re-install
Plug 'RRethy/vim-illuminate'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'wellle/targets.vim'

" Lua plugins
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-calc'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'neovim/nvim-lspconfig'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'ojroques/nvim-lspfuzzy'

call plug#end()

" gruvbox-community/gruvbox
if has_key(g:plugs, "gruvbox")
    let g:gruvbox_invert_selection = 0
    colorscheme gruvbox
endif

" editorconfig/editorconfig-vim
if has_key(g:plugs, "editorconfig-vim")
    let g:EditorConfig_exclude_patterns = ['fugitive://.*']
    let g:EditorConfig_disable_rules = ['trim_trailing_whitespace']
endif

" itchyny/lightline.vim
if has_key(g:plugs, "lightline.vim")
    let g:lightline = { 'colorscheme': 'gruvbox' }
endif

" junegunn/fzf.vim
if has_key(g:plugs, "fzf.vim")
    let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.7 } }
endif

lua require 'plugins'
