
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

" VSCode-style word deletion
inoremap <C-BS> <C-W>
inoremap <C-Del> <Esc>lcw
nnoremap <C-Del> cw<Esc>l

" VSCode-style comment toggling
nnoremap <C-_> :Commentary<CR>
vnoremap <C-_> :Commentary<CR>
inoremap <C-_> <C-O>:Commentary<CR>

" Force VIM to use system clipboard
set clipboard=unnamedplus

" Enable per-project vimrc files
set exrc
set secure

" Enable filetype plugins
set nocompatible
filetype plugin on
syntax on

" Disable the gitgutter background
let g:gitgutter_override_sign_column_highlight = 1
highlight clear SignColumn

" Make gitgutter update on file save
autocmd BufWritePost * GitGutter

" Enable Leap
lua require('leap').add_default_mappings()