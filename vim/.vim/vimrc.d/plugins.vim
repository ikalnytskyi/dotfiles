scriptencoding utf-8

set nocompatible
filetype off

if !filereadable($VIMHOME . '/autoload/plug.vim')
  if executable('curl')
    !curl -fLo $VIMHOME/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  endif
endif

call plug#begin($VIMHOME . '/plugins')

Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'terryma/vim-multiple-cursors'
Plug 'godlygeek/tabular'
Plug 'sjl/gundo.vim'
Plug 'AndrewRadev/linediff.vim'
Plug 'xsnippet/vim-xsnippet'
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
Plug 'editorconfig/editorconfig-vim'

Plug 'davidhalter/jedi-vim'
Plug 'nvie/vim-flake8'
Plug 'alfredodeza/pytest.vim'
Plug 'justmao945/vim-clang'
Plug 'fatih/vim-go'

Plug 'docker/docker', {'rtp': '/contrib/syntax/vim/'}
Plug 'rust-lang/rust.vim'
Plug 'plasticboy/vim-markdown'
Plug 'elzr/vim-json'
Plug 'pangloss/vim-javascript'
Plug 'mitsuhiko/vim-jinja'

Plug 'nanotech/jellybeans.vim'
Plug 'w0ng/vim-hybrid'
Plug 'kristijanhusak/vim-hybrid-material'

call plug#end()


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

let g:NERDTreeQuitOnOpen = 1


" vim-clang
" ---------

let g:clang_cpp_options = "-std=c++14 -Wall -Wextra -pedantic"
let g:clang_check_syntax_auto = 1


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


" hybrid.vim
" ----------

let g:hybrid_reduced_contrast = 1


" tagbar
" ------

let g:tagbar_width = 30
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_iconchars = ['▸', '▾']
let g:tagbar_show_visibility = 0

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

let g:tagbar_type_css = {
  \ 'ctagstype': 'css',
  \ 'kinds': [
    \ 'c:classes',
    \ 's:selectors',
    \ 'i:identities',
  \ ],
  \ 'sort': 0,
\ }
