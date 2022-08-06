" Vim-plug
call plug#begin('~/.config/nvim/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'mattn/efm-langserver'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts'
Plug 'ms-jpq/chadtree'
Plug 'vimwiki/vimwiki'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'morhetz/gruvbox'
Plug 'jwalton512/vim-blade'
Plug 'udalov/kotlin-vim'
call plug#end()

" Colortheme
set termguicolors
color gruvbox

" LSP
lua require('lsp')

autocmd CursorHold * lua vim.diagnostic.open_float()
set completeopt=menuone,noinsert,noselect
set signcolumn=yes:1
set updatetime=500

let g:coq_settings = { 'auto_start': 'shut-up' }
autocmd VimEnter * COQnow


" VimWiki
let g:vimwiki_list = [{'path': '~/Notes/src',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_ext2syntax = {}
let g:vimwiki_global_ext = 0

" Explorer
" autocmd VimEnter * CocCommand explorer --no-focus
" autocmd TabEnter * CocCommand explorer --no-focus
" autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif
set autochdir      

" Airline
set noshowmode
set laststatus=2
let g:airline_mode_map = {}
let g:airline_section_error = airline#section#create([])
let g:airline_section_warning = airline#section#create([])
let g:airline_mode_map['ic'] = 'INSERT'
let g:airline_powerline_fonts = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''

" Indent
set backspace=indent,eol,start
set tabstop=4 shiftwidth=4 expandtab
filetype plugin indent on

" Terminal mode
tnoremap <Esc> <C-\><C-n>
au TermOpen * setlocal nonumber norelativenumber

" Other stuff
set nowrap
set clipboard=unnamedplus "use system clipboard

set splitbelow
set splitright

set nu
set wildmenu

" Filetypes
autocmd BufNewFile,BufRead *.h set filetype=c
autocmd BufNewFile,BufRead *.inc set filetype=c

" Spellcheck
"autocmd BufRead,BufNewFile *.txt,*.md set spell
