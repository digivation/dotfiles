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

" YouCompleteMe -- code completion https://github.com/Valloric/YouCompleteMe
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }

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

" YouCompleteMe Customization from RealPython
" https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Support for virtualenv in YCM
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF


" PEP8 Python Indentation
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |

" Flag python whitespace
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" WebDev Indentation Settings
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

