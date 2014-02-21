" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"   DESCRIPTION: Keymap settings for Vim
"        AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" Ctrl + [h, j, k, l] - to navigate through split windows
" -------------------------------------------------------
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-l> :wincmd l<CR>



" [F3] — call file explorer
" -------------------------
nnoremap <silent> <F3>   :NERDTreeToggle<CR>


" NOTE: F4 maped for switching header/source in c++


" [F5] — recursively search Makefile and run last one
" ---------------------------------------------------
nmap <silent> <F5>  :Compile<CR>


" [Ctrl + F6] — turn on/off spellchecker
" [F6] — fix grammar mistake
" --------------------------------------
nnoremap <silent> <C-F6> :Spell<CR>
inoremap <F6> z=<CR>i
nnoremap <F6> z=<CR>


" [F8] — show/hide tagbar (class tree, for instance)
" --------------------------------------------------
nnoremap <silent> <F8> :TagbarToggle<CR>


" [F9] — turn on/off hex mode
" ---------------------------
"nnoremap <silent> <F9>  :Hexmode<CR>


" [F11] — show/hide quickfix list
" -------------------------------
nnoremap <silent> <F11>  :QFix<CR>


nnoremap <F9> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>


" [Ctrl + T] — new tab
" [Ctrl +  W] — close tab
"
" ATTENTION: the lines below could remap hotkeys from the another plugins
" -----------------------------------------------------------------------
nmap <silent><C-t> :tabnew<CR>
nmap <silent><C-w> :tabclose<CR>


" [Ctrl + Space] — use autocomplete
" ---------------------------------
if has("gui_running")
    imap <silent> <buffer> <C-Space>  <C-X><C-O>
else
    imap <silent> <buffer> <C-@>  <C-X><C-O>
endif
