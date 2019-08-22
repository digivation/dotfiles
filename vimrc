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
"Plug 'tpope/vim-markdown'

" vim-vinegar -- File browsing assistance
Plug 'tpope/vim-vinegar'

" vim-markdown -- Beter Markdown support? Req. Tabular
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

" SimplyIFold -- python folding
Plug 'tmhedberg/SimpylFold'

" indentpython -- python indentions
Plug 'vim-scripts/indentpython.vim'

" YouCompleteMe -- code completion https://github.com/Valloric/YouCompleteMe
Plug 'Valloric/YouCompleteMe', { 'do': './install.py', 'for': 'python' }

" vim-hugo-helper -- for Hugo posts
Plug 'robertbasic/vim-hugo-helper', { 'for': 'markdown' }

call plug#end()

set t_Co=16                                                
set background=dark
" Enable Solarized Theme
colorscheme solarized                                      
set number
set cursorline
set ruler
"set expandtab
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

" YCM Customization from DjangoProject https://code.djangoproject.com/wiki/UsingVimWithDjango
let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure
let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
let g:ycm_complete_in_comments = 1 " Completion in comments
let g:ycm_complete_in_strings = 1 " Completion in string


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
    \ let python_highlight_all = 1 |

" Flag python whitespace
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" WebDev Indentation Settings
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set autoindent |

" Statusline
set statusline=%t           " tail of filename
"set statusline+=\ [%{strlen(&fenc)?&fenc:'none'}, " file encoding
"set statusline+=%{&ff}]     " file format
set statusline+=\ %y
set statusline+=\ %{fugitive#statusline()}

" vim-markdown config
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1

"" Netwr customizations
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 20
let g:netrw_altv = 1
"augroup ProjectDrawer
"    autocmd!
"    autocmd VimEnter * :Vexplore
"augroup END
