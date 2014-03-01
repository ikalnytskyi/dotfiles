" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"   DESCRIPTION: General settings for Vim
"        AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

syntax on
filetype plugin indent on


" Add folders to Vim runtime
" --------------------------

set rtp+=$VIMHOME/templates     " user's snippets for XPTemplate
set rtp+=$VIMHOME/languages     " language specified Vim settings


" General settings
" ----------------

set nocompatible                " No compatibility with vi
set shellslash                  " Set forward slash to be the slash of note (for Windows - backslashes suck)
set vb                          " Set visual bell (instead of beeping)
set backspace=2                 " Allow backspacing over indent, eol, and the start of an insert
set scrolloff=3                 " Number of lines from the end of the screen when start scrolling
set sidescrolloff=3             " Number of columns from the end of the screen when start scrolling
set isfname+=32                 " Make Vim understand filenames with spaces
set showfulltag                 " When completing by tag, show the whole tag, not just the function name
set history=128                 " How much lines of command line history to remember
set undolevels=2048             " Number of possible undo's
set hidden                      " Enable unwritten buffers to be hidden
set autochdir                   " Automatically switch directory to current
set virtualedit=all             " Enable a full virtual editing mode
set showmode                    " Show what mode are you in
set wildmenu                    " Enable enhanced command line completion
set browsedir=current           " Directory to use for the file browser
set diffopt+=iwhite             " Add ignorance of whitespace to diff
set autoread                    " Automatically read files, edited outside of Vim
set showcmd                     " Show current command buffer
set splitbelow                  " Put the new window below when vertical splitting
set splitright                  " Put the new window right when horizontal splitting
set backup                      " Save file backups
set list!
set iminsert=0                  " Turn of :lmap and Input Method
set imsearch=-1                 " Set search layout same is iminsert
set lazyredraw                  " Don't update the display while executing macros
set ffs=unix,dos,mac            " End-of-line symbol processing order
set fileencodings=utf-8,windows-1251,iso-8859-15,koi8-r " Order of encodings recognition attempts
set nowrap

if has('unix')
    set clipboard=unnamedplus   " use system clipboard on unix/linux
else
    set clipboard=unnamed       " use system clipboard on windows/mac
endif


if !isdirectory($VIMHOME . "/swap")
    call mkdir($VIMHOME . "/swap", "p")
endif
if !isdirectory($VIMHOME . "/backup")
    call mkdir($VIMHOME . "/backup", "p")
endif

set backupdir=$VIMHOME/backup     " Directory for backup storing
set directory=$VIMHOME/swap       " Directory for storing swaps


" Search settings
" ---------------

set incsearch           " Enable incremental search
set ignorecase          " Ignore search case
set smartcase           " Match upper case in the search string if specified
set wrapscan            " Set the search scan to wrap lines
set hlsearch            " Highlight search results


" Indentation settings
" --------------------

set autoindent          " inherit current indentation in the next line
set tabstop=4           " set tab size
set softtabstop=4       " always insert spaces instead of tabs (if expandtab)
set shiftwidth=4        " shift lines by 4 spaces
set expandtab           " insert space instead the tab
set smarttab            " align tab instead of just inserting 4 spaces
