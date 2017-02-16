set nocompatible                                           
filetype off

" Activate vim-plug https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

" Solarized color scheme
Plug 'altercation/vim-colors-solarized'

" vim-sensible -- sensible defaults
Plug 'tpope/vim-sensible'

" vim-fugitive -- Git integration
Plug 'tpope/vim-fugitive'

" vim-markdown -- Highlighting and filetype for Markdown
Plug 'tpope/vim-markdown'

" vim-vinegar -- File browsing assistance
Plug 'tpope/vim-vinegar'

" SimplyIFold -- python folding
Plug 'tmhedberg/SimpylFold'

" indentpython -- python indentions
Plug 'vim-scripts/indentpython.vim'

call plug#end()

set t_Co=16                                                
set background=dark
" Enable Solarized Theme
colorscheme solarized                                      
set number
set cursorline
set ruler
set expandtab
set shiftwidth=4
set softtabstop=4

" Set UTF-8 support
set encoding=utf-8

" SimplyIFold Settings
let g:SimpylFold_docstring_preview = 1  " Preview fold

" PEP8 Python Indentation
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

" Flag python whitespace
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" WebDev Indentation Settings
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

