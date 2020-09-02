" Vim-plug
call plug#begin('~/.config/nvim/plugged')
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'itchyny/lightline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'kiwec/vim-brainfuck'
call plug#end()

" Lang-specific
autocmd BufWinEnter * if expand('%:e') == 'asm' | set ft=nasm | endif


" NERDTree
autocmd VimEnter * NERDTree | wincmd w
autocmd TabEnter * NERDTreeMirror | wincmd w

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
set autochdir

" Keybindings

" Lightline
set noshowmode
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'dracula',
      \ }

" Colortheme
color dracula

" Indents
set backspace=indent,eol,start
set tabstop=4 shiftwidth=4 expandtab
filetype plugin indent on

" Terminal mode
tnoremap <Esc> <C-\><C-n>
au TermOpen * setlocal nonumber norelativenumber

" Other stuff
set nowrap
set clipboard+=unnamedplus "use system clipboard

set splitbelow
set splitright

set nu
set wildmenu

" Text files
"autocmd BufRead,BufNewFile *.txt,*.md set spell
