" Allow buffer switching without saving
set hidden

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

" options for insert mode completion (needed for hrsh7th/nvim-compe)
set completeopt=menuone,noselect

let mapleader="\<Space>"

" edit/source config
nnoremap <Leader>ce :e ~/.config/nvim/init.vim<CR>
nnoremap <Leader>cs :so ~/.config/nvim/init.vim<CR>

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
Plug 'honza/vim-snippets'
Plug 'hrsh7th/nvim-compe'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'justinmk/vim-sneak'
Plug 'lilyinstarlight/vim-sonic-pi'
Plug 'mattn/emmet-vim'
Plug 'mcchrish/nnn.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'ojroques/nvim-lspfuzzy'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'RRethy/vim-illuminate'
Plug 'SirVer/ultisnips'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'wellle/targets.vim'
call plug#end()

" morhetz/gruvbox
let g:gruvbox_invert_selection = 0
colorscheme gruvbox

" editorconfig/editorconfig-vim
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let g:EditorConfig_disable_rules = ['trim_trailing_whitespace']

" hrsh7th/nvim-compe
inoremap <silent><expr> <C-l> compe#complete()
inoremap <silent><expr> <CR> compe#confirm('<CR>')
inoremap <silent><expr> <C-e> compe#close('<C-e>')
inoremap <silent><expr> <C-A-d> compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-A-u> compe#scroll({ 'delta': -4 })

lua << EOF
require'compe'.setup {
  source = {
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    path = true;
    spell = true;
    treesitter = true;
    ultisnips = true;
  };
}
EOF

" itchyny/lightline.vim
let g:lightline = { 'colorscheme': 'gruvbox' }

" junegunn/fzf.vim
let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.7 } }

" mcchrish/nnn.vim
let g:nnn#layout = { 'window': { 'width': 0.7, 'height': 0.7 } }

" neovim/nvim-lspconfig, misc. lsp config
lua << EOF
local lspconfig = require 'lspconfig'

local custom_attach = function(client)
  local map = function(mode, key, result)
      vim.api.nvim_buf_set_keymap(0, mode, key, result, { noremap = true, silent = true })
  end

  map('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
  map('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
  map('n','K','<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n','gr','<cmd>lua vim.lsp.buf.references()<CR>')
  map('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>')
  map('i', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  map('n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
  map('n','gt','<cmd>lua vim.lsp.buf.type_definition()<CR>')
  map('n','<leader>ls','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
  map('n','<leader>lS','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
  map('n','<leader>la','<cmd>lua vim.lsp.buf.code_action()<CR>')
  map('n','<leader>lr','<cmd>lua vim.lsp.buf.rename()<CR>')
  map('n','<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  map('n','<leader>li','<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
  map('n','<leader>lo','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
  map('n',']d','<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  map('n','[d','<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  map('n','gS','<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
  map('n','<leader>lL','<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')

  illuminate = require'illuminate'
  illuminate.on_attach(client)
  vim.api.nvim_command [[ hi def link LspReferenceText CursorLine ]]
  vim.api.nvim_command [[ hi def link LspReferenceWrite CursorLine ]]
  vim.api.nvim_command [[ hi def link LspReferenceRead CursorLine ]]
  map('n', '<a-n>', '<cmd>lua illuminate.next_reference{ wrap=true }<CR>')
  map('n', '<a-p>', '<cmd>lua illuminate.next_reference{ reverse=true, wrap=true }<CR>')
end

-- `sudo pacman -S python-language-server`
lspconfig.pyls.setup{ on_attach = custom_attach }

-- `sudo pacman -S rust-analyzer` + `rustup component add rust-src`
lspconfig.rust_analyzer.setup{ on_attach = custom_attach }

-- `npm install -g vscode-css-languageserver-bin`
lspconfig.cssls.setup{ on_attach = custom_attach }

-- `npm install -g vscode-html-languageserver-bin`
lspconfig.html.setup{ on_attach = custom_attach }

-- `npm install -g vscode-json-languageserver`
lspconfig.jsonls.setup{ on_attach = custom_attach }

-- `npm install -g typescript-language-server`
lspconfig.tsserver.setup{ on_attach = custom_attach }

-- `npm install -g yaml-language-server`
lspconfig.yamlls.setup{ on_attach = custom_attach }

-- `sudo pacman -S clang`
lspconfig.clangd.setup{ on_attach = custom_attach }

-- `npm install -g intelephense`
-- https://github.com/bmewburn/intelephense-docs#configuration-options
-- https://github.com/php-stubs/wordpress-stubs
-- https://github.com/php-stubs/wordpress-globals
lspconfig.intelephense.setup{
  settings = {
    intelephense = {
      stubs = {
        "apache", "bcmath", "bz2", "calendar", "com_dotnet", "Core", "csprng",
        "ctype", "curl", "date", "dba", "dom", "enchant", "exif", "fileinfo",
        "filter", "fpm", "ftp", "gd", "hash", "iconv", "imap", "interbase",
        "intl", "json", "ldap", "libxml", "mbstring", "mcrypt", "mssql",
        "mysql", "mysqli", "oci8", "odcb", "openssl", "password", "pcntl",
        "pcre", "PDO", "pdo_ibm", "pdo_mysql", "pdo_pgsql", "pdo_sqlite",
        "pgsql", "Phar", "posix", "pspell", "readline", "recode", "Reflection",
        "regex", "session", "shmop", "SimpleXML", "snmp", "soap", "sockets",
        "sodium", "SPL", "sqlite3", "standard", "superglobals", "sybase",
        "sysvmsg", "sysvsem", "sysvshm", "tidy", "tokenizer", "wddx", "xml",
        "xmlreader", "xmlrpc", "xmlwriter", "Zend OPcache", "zip", "zlib",
        "wordpress"
      }
    }
  },
  on_attach = custom_attach
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
  }
)
EOF

" norcalli/nvim-colorizer.lua
lua << EOF
require 'colorizer'.setup {
  'css';
  'scss';
}
EOF

" nvim-treesitter/nvim-treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true -- init: `gnn`, node_inc: `grn`, scope_inc: `grc`, node_dec: `grm`
  },
  indent = {
    enable = true
  },
  playground = {
    enable = true
  }
}
EOF

" ojroques/nvim-lspfuzzy
lua << EOF
require('lspfuzzy').setup {}
EOF

" dermusikman/sonicpi.vim
let g:sonicpi_command = 'sonic-pi-tool'
let g:sonicpi_send = 'eval-stdin'
let g:sonicpi_stop = 'stop'
let g:vim_redraw = 1

" sirver/UltiSnips
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>" 
