source ~/.vimrc

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

" Custom syntax highlighting
au BufRead,BufNewFile *.usd set filetype=usda
au BufRead,BufNewFile *.usda set filetype=usda
autocmd FileType usda source ~/.config/nvim/third_party/usda-syntax/vim/usda.vim

" Disable the gitgutter background
let g:gitgutter_override_sign_column_highlight = 1
highlight clear SignColumn

" Make gitgutter update on file save
if !exists('g:vscode')
    autocmd BufWritePost * GitGutter
endif

" Don't bother loading plugins if we are on a really old NeoVim installation
if has('nvim-0.8')
    " Enable Leap
    lua require('leap').add_default_mappings()

    " Enable trailing space detection
    lua require('mini.trailspace').setup()
endif

" Configure floating window colours
highlight Pmenu ctermbg=none ctermfg=white

" VSCode-style comment toggling
nnoremap <C-_> :Commentary<CR>
vnoremap <C-_> :Commentary<CR>
inoremap <C-_> <C-O>:Commentary<CR>
