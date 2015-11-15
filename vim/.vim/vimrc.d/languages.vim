" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"   DESCRIPTION: Various language specific settings.
"        AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

autocmd BufReadPost *.qss set filetype=css
autocmd BufReadPost *.qrc set filetype=xml

autocmd BufReadPre SConstruct set filetype=python
autocmd BufReadPre SConscript set filetype=python


augroup PYTHON
    autocmd!
    autocmd BufWritePost *.py silent! call Flake8()
augroup END


augroup HTML
    autocmd!
    autocmd FileType html setlocal shiftwidth=2 tabstop=2
augroup END


augroup JAVASCRIPT
    autocmd!
    autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
augroup END


augroup CPP
    autocmd!
    autocmd BufWritePost *.c,*.cc,*.cpp,*.cxx,*.h,*.hpp,*.hxx
       \ silent! call g:ClangUpdateQuickFix()
augroup END
