" Syntax highlighting
syntax on

" Enable modeline
set modeline

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

" Force VIM to use system clipboard
if has("macunix")
    set clipboard=unnamed
else
    set clipboard=unnamedplus
endif

" Enable per-project vimrc files
set exrc
set secure

" Enable filetype plugins
set nocompatible
filetype plugin on
syntax on

" Hide the intro message
set shortmess+=I

" Force help documents into new tabs
cnoreabbrev <expr> help getcmdtype() == ":" && getcmdline() == 'help' ? 'tab help' : 'help'
cnoreabbrev <expr> h getcmdtype() == ":" && getcmdline() == 'h' ? 'tab help' : 'h'

" Configure netrw
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 3

" Enable spell checking
if !exists('g:vscode')
    set spell
    set spelllang=en_ca,en_us

    " Note: This only works on vim 8.2.0953 or later (or nvim 0.5)
    if has('nvim-0.5') || v:version >= 802 || has('patch-8.2.0953')
        set spelloptions=camel
    endif
    
    " Hide spellcheck highlights I don't care about
    hi clear SpellCap
    hi clear SpellRare

    " Change the spellcheck highlight to an underline
    hi clear SpellBad
    hi SpellBad cterm=underline ctermfg=DarkRed

    " Disable spellcheck for some file formats
    autocmd FileType man setlocal nospell
    autocmd FileType diff setlocal nospell
    autocmd FileType usda setlocal nospell
endif

" Configure Diff rendering
hi DiffText         ctermfg=White       ctermbg=none
hi DiffFile         ctermfg=White       ctermbg=none cterm=bold
hi DiffIndexLine    ctermfg=White       ctermbg=none cterm=bold
hi DiffAdd          ctermfg=DarkGreen   ctermbg=none
hi DiffChange       ctermfg=DarkRed     ctermbg=none
hi DiffDelete       ctermfg=DarkRed     ctermbg=none
