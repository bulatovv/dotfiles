" Vim-plug
call plug#begin('~/.config/nvim/plugged')
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-jp/vim-cpp'
"Plug 'sheerun/vim-polyglot'
"Plug 'wlangstroth/vim-racket'
"Plug 'kiwec/vim-brainfuck'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vimwiki/vimwiki'
"Plug 'mechatroner/rainbow_csv'
call plug#end()

" Commands
command Nicecsv :call Nicecsv()
function! Nicecsv()
    let save_pos = getpos(".")
    %!column -s, -o, -t
    call setpos('.', save_pos)
endfunction

" VimWiki
let g:vimwiki_list = [{'path': '~/Notes/src',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_ext2syntax = {}
let g:vimwiki_global_ext = 0

" Lang-specific
autocmd BufWinEnter * if expand('%:e') == 'asm' | set ft=nasm | endif

" Explorer
autocmd VimEnter * CocCommand explorer --no-focus
autocmd TabEnter * CocCommand explorer --no-focus
autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif
set autochdir      




" Airline
set noshowmode
set laststatus=2
let g:airline_mode_map = {}
let g:airline_section_error = airline#section#create([])
let g:airline_section_warning = airline#section#create([])
let g:airline#extensions#coc#enabled = 0
let g:airline_mode_map['ic'] = 'INSERT'
let g:airline_powerline_fonts = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''

" Colortheme
set termguicolors
color gruvbox

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
