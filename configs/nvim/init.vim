
" Syntax highlighting
syntax on

" Enable mouse usage
set mouse=a

" Tab size
set tabstop=4
set shiftwidth=4
set expandtab

" VSCode-style selection indenting
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
inoremap <S-Tab> <C-D>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" VSCode-style shift-arrow for selection
set keymodel=startsel,stopsel

" Force VIM to use system clipboard
set clipboard=unnamedplus

" Enable per-project vimrc files
set exrc
set secure

" Autoload vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" This is where the plugins be
call plug#begin()

Plug 'github/copilot.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'airblade/vim-gitgutter'
Plug 'nathanaelkane/vim-indent-guides'

" And this is where the plugins no longer be
call plug#end()

" Enable filetype plugins
set nocompatible
filetype plugin on
syntax on

" Enable rainbow
let g:rainbow_active = 1

" Allow indent guides to show
let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  ctermbg=darkgrey
hi IndentGuidesEven ctermbg=lightgrey