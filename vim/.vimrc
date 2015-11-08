" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"   DESCRIPTION: Vim configuration file
"        AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
"
"   All settings are stored in `$VIMHOME/vimrc.d/` folder
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


let $VIMHOME=fnamemodify($MYVIMRC, ':h') . '/.vim'
if has('win32') || has('win64')
    set rtp+=$VIMHOME/
endif


source $VIMHOME/vimrc.d/bundles.vim

source $VIMHOME/vimrc.d/general.vim
source $VIMHOME/vimrc.d/appearance.vim
source $VIMHOME/vimrc.d/commands.vim
source $VIMHOME/vimrc.d/mapping.vim
source $VIMHOME/vimrc.d/languages.vim
