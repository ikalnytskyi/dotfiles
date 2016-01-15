" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"   DESCRIPTION: General settings for Vim
"        AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

scriptencoding utf-8

syntax on
filetype plugin indent on

set nocompatible                " Use Vim defaults, no Vi ones
set shellslash                  " Use forward slashed when expanding file names
set vb                          " Set visual bell (instead of beeping)
set scrolloff=3                 " Number of lines from the end of the screen when start scrolling
set sidescrolloff=3             " Number of columns from the end of the screen when start scrolling
set isfname+=32                 " Make Vim understand filenames with spaces
set showfulltag                 " When completing by tag, show the whole tag, not just the function name
set history=128                 " How much lines of command line history to remember
set undolevels=2048             " Number of possible undo's
set hidden                      " Enable unwritten buffers to be hidden
set autochdir                   " Automatically switch directory to current
set virtualedit=all             " Enable all types of virtual modes
set showmode                    " Show what mode are you in
set wildmenu                    " Enable enhanced command line completion
set browsedir=current           " Directory to use for the file browser
set diffopt+=iwhite             " Add ignorance of whitespace to diff
set autoread                    " Automatically read files, edited outside of Vim
set showcmd                     " Show current command buffer
set splitbelow                  " Put the new window below when vertical splitting
set splitright                  " Put the new window right when horizontal splitting
set iminsert=0                  " Turn of :lmap and Input Method
set imsearch=-1                 " Set search layout same is iminsert
set lazyredraw                  " Don't update the display while executing macros
set ffs=unix,dos,mac            " End-of-line symbol processing order
set fileencodings=utf-8,windows-1251,iso-8859-15,koi8-r " Order of encodings recognition attempts
set spelllang=en,ru             " Set languages for spell checking
set nowrap                      " Turn off 'visual' wrapping
set nofoldenable                " Turn off code folding
set nrformats-=octal            " Consider Dec as default number format
set completeopt=longest,menuone " Use popup even if there's only one match
set nobackup                    " Don't make backup
set nowritebackup               " Don't make backup for backup
set noswapfile                  " Don't make swapfiles
set backupdir=$VIMHOME/backup   " Directory for storing backup
set directory=$VIMHOME/swap     " Directory for storing swap
set mouse=a                     " Enable mouse for all modes
set mousemodel=popup_setpos     " RMB triggers popup, and set position

set incsearch                   " Enable incremental search
set ignorecase                  " Enable case insensitive search
set smartcase                   " Match uppercase in the search string
set wrapscan                    " Set the search scan to wrap lines
set hlsearch                    " Highlight search results

set autoindent                  " Inherit current indentation in the next line
set expandtab                   " Insert space instead the tab
set softtabstop=4               " Always insert spaces instead of tabs
set shiftwidth=4                " Shift lines by 4 spaces
set tabstop=4                   " Set tab width
set smarttab                    " Align tab instead of just inserting 4 spaces
set backspace=indent,eol,start  " Allow backspacing over indent, eol and start

set t_Co=256                    " Enable 256 color mode
set cursorline                  " Highlight the line with cursor
set colorcolumn=80              " Highlight 80 column
set cursorcolumn                " Highlight the column with cursor
set number                      " Enable line numbering
set synmaxcol=2048              " Syntax coloring long lines slows down the vim
set mousehide                   " Hide mouse cursor while typing
set timeoutlen=500              " Timeout between keystrokes on shortcuts
set fillchars=""                " Get rid of characters in windows separators
set list                        " Show unprintable characters
set listchars=tab:»·,trail:·    " Set unprintable characters
set laststatus=2

" the status line will be overridden by vim-airline. it's kept here just
" in case - if one day i'll want to use vanilla vim. :)
set statusline=%f\ %m\ %r\ %y\ [%{&fileencoding}]\ [len\ %L:%p%%]
set statusline+=\ [pos\ %02l:%02c\ 0x%O]\ [%3b\ 0x%02B]\ [buf\ #%n]

set background=dark
colorscheme jellybeans

if has('gui_running')
    set guioptions-=m       " remove menu bar
    set guioptions-=T       " remove toolbar

    if has('mac')
        set guifont=Menlo:h13
    else
        set guifont=Ubuntu\ Mono\ 13
    endif
endif

if has('mac')
    set clipboard=unnamed       " use system clipboard on windows/mac
else
    set clipboard=unnamedplus   " use system clipboard on unix/linux
endif
