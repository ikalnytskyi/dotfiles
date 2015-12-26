" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"   DESCRIPTION: This file contains different useful functions.
"        AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

command -bar SudoWrite %!sudo tee > /dev/null %
command -bar Spell call ToggleSpell()


function! ToggleSpell()
    if !exists("b:isChecked") || !b:isChecked
        set spell
        let b:isChecked = 1
    else
        set nospell
        let b:isChecked = 0
    endif
endfunction
