" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"   DESCRIPTION: Key mapping settings
"        AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" call file explorer
nnoremap <leader>1 :NERDTreeToggle<CR>

" show/hide tagbar (class tree, for instance)
nnoremap <leader>2 :TagbarToggle<CR>

" show/hide quickfix lis
nnoremap <leader>3 :QFix<CR>

" turn on/off spellchecker
nnoremap <leader>4 :Spell<CR>

" use autocomplete
if has("gui_running")
    imap <silent> <buffer> <C-Space>  <C-X><C-O>
else
    imap <silent> <buffer> <C-@>  <C-X><C-O>
endif
