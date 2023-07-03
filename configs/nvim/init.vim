
" Syntax highlighting
syntax on

" Enable mouse usage
set mouse=a

" Configure the right-click menu
if !exists('g:vscode')
    aunmenu PopUp
    vnoremenu PopUp.Cut                         "+x
    vnoremenu PopUp.Copy                        "+y
    anoremenu PopUp.Paste                       "+gP
    vnoremenu PopUp.Paste                       "+P
    vnoremenu PopUp.Delete                      "_x
    nnoremenu PopUp.Select\ All>                ggVG
    vnoremenu PopUp.Select\ All>                gg0oG$
    inoremenu PopUp.Select\ All                 <C-Home><C-O>VG
endif

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

" Hide the intro message
set shortmess+=I

" Force help documents into new tabs
cnoreabbrev <expr> help getcmdtype() == ":" && getcmdline() == 'help' ? 'tab help' : 'help'
cnoreabbrev <expr> h getcmdtype() == ":" && getcmdline() == 'h' ? 'tab help' : 'h'

" Enable spell checking
if !exists('g:vscode')
    set spell
    set spelllang=en_ca,en_us
    set spelloptions=camel
    hi clear SpellCap
    hi clear SpellRare
endif

" Disable the gitgutter background
let g:gitgutter_override_sign_column_highlight = 1
highlight clear SignColumn

" Make gitgutter update on file save
if !exists('g:vscode')
    autocmd BufWritePost * GitGutter
endif

" Enable Leap
lua require('leap').add_default_mappings()

" Custom functions
function! MkdirAndWrite()
    let dir = expand('%:p:h')
    exec '!mkdir -p ' . dir
    exec 'w'
endfunction
command Wmk call MkdirAndWrite()
