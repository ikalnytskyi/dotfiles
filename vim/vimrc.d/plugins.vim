" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"   DESCRIPTION: Plugin settings for Vim
"        AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" XPTemplate
" ----------
let g:xptemplate_vars = 'SParg='
let g:xptemplate_brace_complete = ''


" NERDtree
" --------
let NERDTreeQuitOnOpen = 1


" jedi-vim
" --------
let g:jedi#popup_on_dot = 1


" vim-flake8
" ----------
let g:flake8_builtins="_,apply,self"
let g:flake8_max_line_length=99


" clang_complete
" --------------
let g:clang_periodic_quickfix = 1
let g:clang_hl_errors = 1
let g:clang_use_library = 1
let g:clang_jumpto_back_key = "<C-[>"
let g:clang_user_options = "-std=c++11 -Wall -Wextra -pedantic"
let g:clang_library_path = "/usr/lib/llvm-3.3/lib"


" QFixToggle
" ----------
let g:QFixToggle_Height = 3


" Tagbar
" ------
let g:tagbar_width = 30
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_iconchars = ['+', '-']
