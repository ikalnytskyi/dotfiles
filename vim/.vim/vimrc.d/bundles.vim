" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"   DESCRIPTION: Plugin list which will be install via Vundle
"        AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" Initialize plugin manager
" ------------------------

filetype off

if !isdirectory($VIMHOME . "/bundle")
    call mkdir($VIMHOME . "/bundle", "p")
    cd $VIMHOME/bundle
    if executable('git')
        !git clone https://github.com/gmarik/vundle.git
        call BundleInstall!
    else
        echo 'WARNING: Git is missing! Cannot pull Vundle plugin.'
    endif
endif

set rtp+=$VIMHOME/bundle/vundle/
call vundle#rc()


" Plugins
" -------

Bundle 'gmarik/vundle'

Bundle 'scrooloose/nerdtree'
Bundle 'majutsushi/tagbar'
Bundle 'drmingdrmer/xptemplate'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-fugitive'
Bundle 'xsnippet/vim-xsnippet'
Bundle 'kien/ctrlp.vim'
Bundle 'gitignore'

Bundle 'Rip-Rip/clang_complete'
Bundle 'davidhalter/jedi-vim'
Bundle 'nvie/vim-flake8'

Bundle 'wting/rust.vim'
Bundle 'mitsuhiko/vim-jinja'

Bundle 'chriskempson/base16-vim'


" Helper messages for some dependencies
" -------------------------------------

if !executable('ctags')
    echo 'Need ctags for tagbar plugin!'
endif

if !executable('clang')
    echo 'Need clang with llvm for clang_complete plugin!'
endif
