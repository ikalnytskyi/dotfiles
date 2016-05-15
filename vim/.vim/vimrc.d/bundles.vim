" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"   DESCRIPTION: Plugin list which will be install via Vundle
"        AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

scriptencoding utf-8

set nocompatible
filetype off

if !isdirectory($VIMHOME . "/bundle")
  call mkdir($VIMHOME . "/bundle", "p")
  cd $VIMHOME/bundle
  if executable('git')
    !git clone git@github.com:VundleVim/Vundle.vim.git
  else
    echo 'WARNING: Git is missing! Cannot pull Vundle plugin.'
  endif
endif
set rtp+=$VIMHOME/bundle/Vundle.vim/


call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

Plugin 'terryma/vim-multiple-cursors'
Plugin 'godlygeek/tabular'
Plugin 'sjl/gundo.vim'
Plugin 'AndrewRadev/linediff.vim'
Plugin 'xsnippet/vim-xsnippet'
Plugin 'honza/vim-snippets'
Plugin 'SirVer/ultisnips'

Plugin 'davidhalter/jedi-vim'
Plugin 'nvie/vim-flake8'
Plugin 'alfredodeza/pytest.vim'
Plugin 'Rip-Rip/clang_complete'

Plugin 'docker/docker', {'rtp': '/contrib/syntax/vim/'}
Plugin 'rust-lang/rust.vim'
Plugin 'plasticboy/vim-markdown'
Plugin 'elzr/vim-json'
Plugin 'othree/yajs.vim'
Plugin 'mitsuhiko/vim-jinja'
Plugin 'rodjek/vim-puppet'

Plugin 'nanotech/jellybeans.vim'
Plugin 'w0ng/vim-hybrid'

call vundle#end()


if !executable('ctags')
  echo 'Need ctags for tagbar plugin!'
endif


" ultisnips
" ---------

let g:UltiSnipsExpandTrigger = '<C-\>'
let g:UltiSnipsJumpForwardTrigger = '<Tab>'
let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'


" vim-airline
" -----------

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


" ctrlp.vim
" ---------

let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'git --git-dir=%s/.git ls-files -oc --exclude-standard'],
    \ 2: ['.hg', 'hg --cwd %s status -numac -I . $(hg root)'],
  \ },
\ }


" nerdtree
" --------

let NERDTreeQuitOnOpen = 1


" clang_complete
" --------------

let g:clang_periodic_quickfix = 1
let g:clang_hl_errors = 1
let g:clang_use_library = 1
let g:clang_user_options = "-std=c++14 -Wall -Wextra -pedantic"

if has('mac')
    let g:clang_library_path = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/'
else
    let g:clang_library_path = '/usr/lib'
endif


" jedi-vim
" --------

let g:jedi#popup_on_dot = 1
let g:jedi#use_tabs_not_buffers = 1


" vim-json
" --------

let g:vim_json_syntax_conceal = 0


" vim-markdown
" ------------

let g:vim_markdown_frontmatter = 1
let g:vim_markdown_conceal = 0


" jellybeans.vim
" --------------

let g:jellybeans_use_term_background_color = 0


" hybrid.vim
" ----------

let g:hybrid_reduced_contrast = 1


" tagbar
" ------

let g:tagbar_width = 30
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_iconchars = ['+', '-']

let g:tagbar_type_rst = {
  \ 'ctagstype': 'restructuredtext',
  \ 'kinds': [
    \ 'c:chapters',
    \ 's:sections',
    \ 'S:subsections',
    \ 't:subsubsections',
  \ ],
  \ 'sro' : '|',
  \ 'kind2scope': {
    \ 'c': 'chapter',
    \ 's': 'section',
    \ 'S': 'subsection',
    \ 't': 'subsubsection',
  \ },
  \ 'sort': 0,
\ }

let g:tagbar_type_rust = {
  \ 'ctagstype' : 'rust',
  \ 'kinds': [
    \ 'n:modules',
    \ 's:structs',
    \ 'i:traits',
    \ 'c:implementations',
    \ 'f:functions',
    \ 'g:enums',
    \ 't:types',
    \ 'v:variables',
    \ 'M:macros',
    \ 'm:struct members',
    \ 'e:enumerators',
    \ 'F:methods',
  \ ],
  \ 'sro': '.',
  \ 'kind2scope': {
    \ 'n': 'module',
    \ 's': 'struct',
    \ 'g': 'enum',
    \ 'i': 'interface',
    \ 'c': 'implementation',
  \ },
\ }

let g:tagbar_type_go = {
  \ 'ctagstype' : 'go',
  \ 'kinds': [
    \ 'p:packages',
    \ 'f:functions',
    \ 'c:constants',
    \ 't:types',
    \ 'v:variables',
    \ 's:structs',
    \ 'i:interfaces',
    \ 'm:struct members',
  \ ],
  \ 'sro': '.',
  \ 'kind2scope': {
    \ 'p': 'package',
    \ 's': 'struct',
    \ 'i': 'interface',
  \ },
\ }

let g:tagbar_type_css = {
  \ 'ctagstype': 'css',
  \ 'kinds': [
    \ 'c:classes',
    \ 's:selectors',
    \ 'i:identities',
  \ ],
  \ 'sort': 0,
\ }
