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
let g:jedi#force_py_version = 2


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
let g:clang_library_path = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/"


" Tagbar
" ------
let g:tagbar_width = 30
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_iconchars = ['+', '-']


" Airline
" -------
if has('gui_running')
    let g:airline_theme="base16"
endif

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_section_z = airline#section#create_right(['%3l:%2c'])

let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.whitespace = '·'
