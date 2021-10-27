" Vim-plug
call plug#begin('~/.config/nvim/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'mattn/efm-langserver'
Plug 'nvim-lua/completion-nvim'
Plug 'vimwiki/vimwiki'
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-jp/vim-cpp'
Plug 'gruvbox-community/gruvbox'
call plug#end()

" Colortheme
set termguicolors
color gruvbox

" LSP

autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

lua << EOF
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
    }
)
local servers = {'pylsp', 'clangd'}
for _, lsp in ipairs(servers) do
    require'lspconfig'[lsp].setup {
        on_attach = require'completion'.on_attach,
    }
end
require "lspconfig".efm.setup {
    on_attach = on_attach,
    cmd = {'efm-langserver', '-logfile', '/tmp/efm.log', '-loglevel', '5'},
    filetypes = { 'python' },
    init_options = {
        documentFormatting = true, 
        --hover = true, 
        --documentSymbol = true,
        --codeAction = true,
        --completion = true
    },
    settings = {
        languages = {
            python = {
                --[[{
                    lintCommand = "pylint --output-format text --score no --msg-template {path}:{line}:{column}:{C}:{msg} ${INPUT}",
                    lintStdin = true,
                    lintFormats = {'%f:%l:%c:%t:%m'},
                }]]--
                --[[{
                        lintCommand =  'flake8 ${INPUT} -',
                        lintStdin =  true,
                        lintFormats = {'%f:%l:%c: %m'}
                }]]--,
            },
        }
    }
}
EOF

set completeopt=menuone,noinsert,noselect
set signcolumn=yes:1
set updatetime=500


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

" Spellcheck
"autocmd BufRead,BufNewFile *.txt,*.md set spell
