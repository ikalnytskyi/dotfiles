" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"   DESCRIPTION: Plugin list which will be install via Vundle
"        AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" Initialize Vundle plugin
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


" Plugins from GitHub
" -------------------

Bundle 'gmarik/vundle'
Bundle 'scrooloose/nerdtree'
Bundle 'drmingdrmer/xptemplate'
Bundle 'tpope/vim-surround'
Bundle 'xsnippet/vim-xsnippet'
Bundle 'davidhalter/jedi-vim'
Bundle 'nvie/vim-flake8'
Bundle 'jamessan/vim-gnupg'
Bundle 'majutsushi/tagbar'
Bundle 'Rip-Rip/clang_complete'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'Rykka/riv.vim'
Bundle 'wting/rust.vim'
Bundle 'mitsuhiko/vim-jinja'


" Plugins from vim-scripts
" ------------------------

Bundle 'QFixToggle'


" Helper messages for some dependencies
" -------------------------------------

if !executable('ctags')
    echo 'Need ctags for tagbar plugin!'
endif

if !executable('clang')
    echo 'Need clang with llvm for clang_complete plugin!'
endif
