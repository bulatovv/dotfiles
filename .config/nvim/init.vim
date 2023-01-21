call plug#begin('~/.config/nvim/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'mattn/efm-langserver'
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'arcticicestudio/nord-vim'
Plug 'jwalton512/vim-blade'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'andweeb/presence.nvim'
Plug 'github/copilot.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': 'markdown', 'on': 'MarkdownPreview'}
call plug#end()


" Copilot
let g:copilot_node_command = "~/.nvm/versions/node/v17.0.1/bin/node"
let g:copilot_assume_mapped = v:true
let g:copilot_filetypes = {
    \ 'markdown': v:true,
    \ }

" Markdown Preview
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
let g:mkdp_port = 9999
let g:mkdp_theme = 'light'
let g:mkdp_page_title = '${name}'
function OpenMarkdownPreview (url)
    execute "silent ! $BROWSER --new-window " . a:url
endfunction
let g:mkdp_browserfunc = 'OpenMarkdownPreview'


" Colortheme
set termguicolors
color nord

" LSP
lua require('lsp')

autocmd CursorHold * lua vim.diagnostic.open_float()
set completeopt=menuone,noinsert,noselect
set signcolumn=yes:1
set updatetime=500


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
