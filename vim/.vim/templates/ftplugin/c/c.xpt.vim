"      AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>

XPTemplate priority=personal

let s:f = g:XPTfuncs()

" MACRO GUARD
XPT guard " C/C++ Macro Guard
#ifndef `symbol^
#define `symbol^

`cursor^

#endif // `symbol^
..XPT
