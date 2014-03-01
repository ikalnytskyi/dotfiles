" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"   DESCRIPTION: Vim configuration file
"        AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
"
"   All settings are stored in `$VIMHOME/vimrc.d/` folder
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


" Set `$VIMHOME` variable
" -----------------------------------------------

let $VIMHOME=fnamemodify($MYVIMRC, ':h') . '/.vim'
if has('win32') || has('win64')
    set rtp+=$VIMHOME/
endif


" Include setting files
" -----------------------------------------------

" NOTE: should be first in this list
source $VIMHOME/vimrc.d/bundles.vim

source $VIMHOME/vimrc.d/general.vim
source $VIMHOME/vimrc.d/appearance.vim
source $VIMHOME/vimrc.d/keybindings.vim
source $VIMHOME/vimrc.d/plugins.vim
source $VIMHOME/vimrc.d/syntax.vim
source $VIMHOME/vimrc.d/functions.vim
