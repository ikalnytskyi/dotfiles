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
        !git clone https://github.com/gmarik/Vundle.vim.git
    else
        echo 'WARNING: Git is missing! Cannot pull Vundle plugin.'
    endif
endif
set rtp+=$VIMHOME/bundle/Vundle.vim/


" Plugins
" -------
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'
Plugin 'drmingdrmer/xptemplate'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'xsnippet/vim-xsnippet'
Plugin 'kien/ctrlp.vim'
Plugin 'gitignore'

Plugin 'Rip-Rip/clang_complete'
Plugin 'davidhalter/jedi-vim'
Plugin 'nvie/vim-flake8'

Plugin 'wting/rust.vim'
Plugin 'mitsuhiko/vim-jinja'
Plugin 'jnwhiteh/vim-golang'

Plugin 'chriskempson/base16-vim'
Plugin 'altercation/vim-colors-solarized'

call vundle#end()


" Helper messages for some dependencies
" -------------------------------------

if !executable('ctags')
    echo 'Need ctags for tagbar plugin!'
endif

if !executable('clang')
    echo 'Need clang with llvm for clang_complete plugin!'
endif
