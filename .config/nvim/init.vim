" Vim-plug
call plug#begin('~/.config/nvim/plugged')
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'arcticicestudio/nord-vim'
"Plug 'itchyny/lightline.vim'
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'kiwec/vim-brainfuck'
Plug 'vimwiki/vimwiki'
call plug#end()

" VimWiki
let g:vimwiki_list = [{'path': '~/Notes/src',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_global_ext = 0

" Lang-specific
autocmd BufWinEnter * if expand('%:e') == 'asm' | set ft=nasm | endif
autocmd BufNewFile,BufRead,BufReadPost *.vs set syntax=javascript

" Explorer
autocmd VimEnter * CocCommand explorer --no-focus
autocmd TabEnter * CocCommand explorer --no-focus

autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif
set autochdir      

" Keybindings

autocmd VimEnter * AirlineToggleWhitespace | call feedkeys("\<C-l>")
let g:airline_mode_map = {}
let g:airline_mode_map['ic'] = 'INSERT'
" Lightline
set noshowmode
set laststatus=2
"let g:lightline = {
"      \ 'colorscheme': 'dracula',
"      \ }

" Colortheme
set termguicolors
source ~/.config/nvim/theme.vim

" Indents
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

" Text files
"autocmd BufRead,BufNewFile *.txt,*.md set spell
