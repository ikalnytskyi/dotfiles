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


augroup CSS
  autocmd!
  autocmd FileType css setlocal shiftwidth=2 tabstop=2
augroup END


augroup JAVASCRIPT
  autocmd!
  autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
augroup END


augroup RESTRUCTUREDTEXT
  autocmd!
  autocmd FileType rst setlocal shiftwidth=3 tabstop=3
augroup END


augroup YAML
  autocmd!
  autocmd FileType yaml setlocal shiftwidth=3 tabstop=3
augroup END


augroup CPP
  autocmd!
  autocmd BufWritePost *.c,*.cc,*.cpp,*.cxx,*.h,*.hpp,*.hxx
     \ silent! call g:ClangUpdateQuickFix()
augroup END


augroup VIM
  autocmd!
  autocmd FileType vim setlocal shiftwidth=2 tabstop=2
augroup END
