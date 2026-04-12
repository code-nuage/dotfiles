set tabstop=4
set shiftwidth=4
set autoindent

set rnu
set nu

syntax on

call plug#begin()

" Teal language support
Plug 'teal-language/vim-teal'

" Optional dependencies; will be loaded on-demand when editing Teal files
Plug 'dense-analysis/ale', { 'for': 'teal' }
Plug 'tpope/vim-endwise', { 'for': 'teal' }

" Go plugins
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()
