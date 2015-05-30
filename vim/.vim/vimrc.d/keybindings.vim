" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"   DESCRIPTION: Keymap settings for Vim
"        AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" navigate through windows
nnoremap <silent> <leader>k :wincmd k<CR>
nnoremap <silent> <leader>j :wincmd j<CR>
nnoremap <silent> <leader>h :wincmd h<CR>
nnoremap <silent> <leader>l :wincmd l<CR>

" call file explorer
nnoremap <leader>1  :NERDTreeToggle<CR>

" show/hide tagbar (class tree, for instance)
nnoremap <leader>2  :TagbarToggle<CR>

" show/hide quickfix lis
nnoremap <leader>3  :QFix<CR>

" turn on/off spellchecker
nnoremap <leader>4 :Spell<CR>

" tab manipulations
nmap <silent><C-t> :tabnew<CR>
nmap <silent><C-w> :tabclose<CR>

" use autocomplete
if has("gui_running")
    imap <silent> <buffer> <C-Space>  <C-X><C-O>
else
    imap <silent> <buffer> <C-@>  <C-X><C-O>
endif
