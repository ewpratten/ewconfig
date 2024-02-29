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

" Enable Leap
lua require('leap').add_default_mappings()

" Enable Helix-style command suggestions
"lua require('command-completion').setup()

" Enable trailing space detection
lua require('mini.trailspace').setup()

" Configure floating window colours
highlight Pmenu ctermbg=none ctermfg=white

" VSCode-style comment toggling
nnoremap <C-_> :Commentary<CR>
vnoremap <C-_> :Commentary<CR>
inoremap <C-_> <C-O>:Commentary<CR>

" Custom functions
function! MkdirAndWrite()
    let dir = expand('%:p:h')
    exec '!mkdir -p ' . dir
    exec 'w'
endfunction
command Wmk call MkdirAndWrite()

" LSP Support
"lua require "lspconfig".rust_analyzer.setup {}
"lua vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
