" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"   DESCRIPTION: Apperance settings for Vim
"        AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

scriptencoding utf-8


set t_Co=256                    " Enable 256 color mode
set cursorline                  " Highlight the line with cursor
set colorcolumn=80              " Highlight 80 column
set cursorcolumn                " Highlight the column with cursor
set number                      " Enable line numbering
set synmaxcol=2048              " Syntax coloring long lines slows down the vim
set mousehide                   " Hide mouse cursor while typing
set timeoutlen=500              " Timeout between keystrokes on shortcuts
set fillchars=""                " Get rid of characters in windows separators
set listchars=tab:»·,trail:·    " Set unprintable characters
set laststatus=2

set statusline=%f\ %m\ %r\ %y\ [%{&fileencoding}]\ [len\ %L:%p%%]
set statusline+=\ [pos\ %02l:%02c\ 0x%O]\ [%3b\ 0x%02B]\ [buf\ #%n]


set background=dark
colorscheme xoria256

if has('gui_running')
    colorscheme base16-tomorrow

    set guifont=Ubuntu\ Mono\ 13
    set guioptions-=m       "remove menu bar
    set guioptions-=T       "remove toolbar
endif
