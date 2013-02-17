" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"   DESCRIPTION: This file contains different useful functions.
"        AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" Function aliases
" ----------------
command -bar Hexmode call ToggleHex()
command -bar Spell call ToggleSpell()
command -bar Compile call Compile()


" Helper function to toggle hex mode
" ----------------------------------
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction


" Spell checker function
" ----------------------
function ToggleSpell()
    if !exists("b:isChecked") || !b:isChecked
        set spl=en,uk,ru spell
        let b:isChecked = 1
    else
        set nospell
        let b:isChecked = 0
    endif
endfunction


" Recursively look for Makefile or SConstruct and perform build accordingly
" -------------------------------------------------------------------------
function! Compile()
    let origcurdir = getcwd()
    let curdir     = origcurdir
    while curdir != "/"
        if filereadable("Makefile")
            break
        elseif filereadable("SConstruct")
            break
        endif
        cd ..
        let curdir= getcwd()
    endwhile
    if filereadable('Makefile')
        set makeprg=make
    elseif filereadable('SConstruct')
        set makeprg=scons
    else
        set makeprg=make
    endif
    echo "now building..."
    silent w
    make
    echo "build finished"
endfunction
