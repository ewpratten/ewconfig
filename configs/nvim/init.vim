
" Enable mouse usage
set mouse=a

" Tab size
set tabstop=4
set shiftwidth=4
set expandtab

" Force VIM to use system clipboard
set clipboard=unnamedplus

" Enable per-project vimrc files
set exrc
set secure

" This is where the plugins be
call plug#begin()

Plug 'github/copilot.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

" And this is where the plugins no longer be
call plug#end()

" Enable filetype plugins
set nocompatible
filetype plugin on
syntax on

" Enable rainbow
let g:rainbow_active = 1