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

Plugin 'AndrewRadev/linediff.vim'
Plugin 'SirVer/ultisnips'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'honza/vim-snippets'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdtree'
Plugin 'sjl/gundo.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-fugitive'
Plugin 'xsnippet/vim-xsnippet'

Plugin 'Rip-Rip/clang_complete'
Plugin 'davidhalter/jedi-vim'
Plugin 'nvie/vim-flake8'

Plugin 'docker/docker', {'rtp': '/contrib/syntax/vim/'}
Plugin 'elzr/vim-json'
Plugin 'hdima/python-syntax'
Plugin 'jszakmeister/markdown2ctags'
Plugin 'jszakmeister/rst2ctags'
Plugin 'mitsuhiko/vim-jinja'
Plugin 'plasticboy/vim-markdown'
Plugin 'rodjek/vim-puppet'
Plugin 'rust-lang/rust.vim'

Plugin 'nanotech/jellybeans.vim'

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


" tagbar
" ------

let g:tagbar_width = 30
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_iconchars = ['+', '-']

" add support for markdown files in tagbar markdown2ctags is required
let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '$VIMHOME/bundle/markdown2ctags/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

" add support for restructuredtext files in tagbar rst2ctags is required
let g:tagbar_type_rst = {
    \ 'ctagstype': 'rst',
    \ 'ctagsbin' : '$VIMHOME/bundle/rst2ctags/rst2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
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

let g:vim_json_syntax_conceal = 0       " do not hide json's double quotes


" python-syntax
" -------------

let python_highlight_all = 1


" vim-markdown
" ------------

let g:vim_markdown_frontmatter = 1


" jellybeans.vim
" --------------

let g:jellybeans_use_term_background_color = 0
