" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"   DESCRIPTION: Vim's configuration file for Python languages
"        AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

setlocal completeopt=menu,longest

let python_highlight_all=1
autocmd BufWritePre <buffer> normal m`:%s/\s\+$//e ``
autocmd BufWritePost <buffer> call Flake8()
