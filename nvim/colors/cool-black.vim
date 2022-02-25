if exists("syntax_on")
    syntax reset
endif
let colors_name       = expand("<sfile>:t:r")

hi clear

hi NonText                                              gui=NONE
hi MoreMsg                                              gui=NONE
hi ModeMsg                                              gui=NONE
hi Question                                             gui=NONE
hi Title                                                gui=NONE
hi VisualNOS                                            gui=underline
hi DiffDelete                                           gui=NONE
hi DiffText                                             gui=NONE
hi TabLineSel                                           gui=NONE
hi CursorLine                                           guibg=Black

hi Normal                                               gui=NONE        guifg=#ffffff           guibg=#000000
hi Comment                      ctermfg=Blue            gui=NONE        guifg=#0000ff           guibg=#000000
hi Constant                     ctermfg=Red             gui=NONE        guifg=#ff0000           guibg=#000000
hi Special      term=bold       ctermfg=DarkMagenta     gui=NONE        guifg=#ffff00           guibg=#000000
hi Identifier                   ctermfg=Cyan            gui=NONE        guifg=#00ffff           guibg=#000000
hi Statement                    ctermfg=Yellow          gui=NONE        guifg=#ffff00           guibg=#000000
hi PreProc                      ctermfg=Blue            gui=NONE        guifg=#00ffff           guibg=#000000
hi Type                         ctermfg=Green           gui=NONE        guifg=#00ff00           guibg=#000000
hi Function                     ctermfg=Cyan            gui=NONE        guifg=#00ffff           guibg=#000000
hi Repeat                       ctermfg=Yellow          gui=NONE        guifg=#ffff00           guibg=#000000
hi Operator                     ctermfg=Red             gui=NONE        guifg=#ff0000           guibg=#000000
hi Ignore                       ctermfg=Black           gui=NONE        guifg=#000000           guibg=#ffffff
hi Error        term=reverse    ctermfg=White           ctermbg=Red     gui=NONE                guifg=#ffffff           guibg=#ff0000
hi Todo         term=standout   ctermfg=Black           ctermbg=Yellow  gui=NONE                guifg=#000000           guibg=#ffff00

" Common groups that link to default highlighting.
" You can specify other highlighting easily.
hi link String  Constant
hi link Character       Constant
hi link Number          Constant
hi link Boolean         Constant
hi link Float           Number
hi link Conditional     Repeat
hi link Label           Statement
hi link Keyword         Statement
hi link Exception       Statement
hi link Include         PreProc
hi link Define          PreProc
hi link Macro           PreProc
hi link PreCondit       PreProc
hi link StorageClass    Type
hi link Structure       Type
hi link Typedef         Type
hi link Tag             Special
hi link SpecialChar     Special
hi link Delimiter       Special
hi link SpecialComment  Special
hi link Debug           Special
hi link PMenu           Normal
hi link PMenuSel        Visual
hi link StatusLine      NormalS
