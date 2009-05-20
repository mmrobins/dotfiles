" ----------------------------------------------------------------------------------------------------------------------------------
" Filename:      relaxedgreen.vim
" Last Modified: 14 Aug 2006 02:24:33 PM by Dave V
" Maintainer:    Dave Vehrs (dvehrs at gmail.com)
" Copyright:     2002,2003,2004,2005,2006 Dave Vehrs
"                This script is free software; you can redistribute it and/or 
"                modify it under the terms of the GNU General Public License as 
"                published by the Free Software Foundation; either version 2 of 
"                the License, or (at your option) any later version. 
" Description:   Vim colorscheme file.
" Install:       Put this file in the users colors directory (~/.vim/colors) or 
"                in the shared colors directory (/usr/shared/vim/vim<version>/colors/),
"                then load it with :colorscheme relaxedgreen
"
"               
" ----------------------------------------------------------------------------------------------------------------------------------
set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "relaxedgreen"
highlight Cursor        term=reverse      ctermfg=green ctermbg=blue                      guifg=#000000 guibg=#559955
highlight CursorIM      term=reverse      ctermfg=black ctermbg=darkgreen                 guifg=#000000 guibg=#336633
highlight CursorColumn  term=none         ctermbg=darkblue                                guibg=#333366
highlight CursorColumn  term=none         ctermbg=darkblue                                guibg=#333366
highlight Comment       term=italic       ctermfg=darkcyan ctermbg=black                  guifg=#00a594
highlight Constant      term=underline    ctermfg=blue                                    guifg=#0099dd
highlight Debug         term=bold         ctermfg=red ctermbg=black                       guifg=#dc0000 guibg=#000000
highlight DiffAdd       term=reverse      ctermfg=black ctermbg=cyan                      guifg=#000000 guibg=#007200
highlight DiffChange    term=underline    cterm=reverse ctermfg=darkgreen ctermbg=black   guifg=#000000 guibg=#006700
highlight DiffDelete    term=standout     ctermfg=black ctermbg=cyan                      guifg=#000000 guibg=#007200
highlight DiffText      term=bold         ctermfg=green ctermbg=black                     guifg=#00ac00 guibg=#000000
highlight Directory     term=underline    ctermfg=green ctermbg=black                     guifg=#336633 guibg=#000000
highlight Error         term=reverse,bold ctermfg=black ctermbg=red                       guifg=#000000 guibg=#dc0000
highlight ErrorMsg      term=reverse,bold ctermfg=white ctermbg=red                       guifg=#ffffff guibg=#dc0000
highlight Folded                          ctermfg=darkgreen ctermbg=black                 guifg=#20de20 guibg=#000000
highlight FoldColumn                      ctermfg=darkgreen ctermbg=black                 guifg=#20de20 guibg=#000000
highlight Function      term=standout     ctermfg=darkgreen                               guifg=#22bb22
highlight Identifier    term=underline    ctermfg=darkcyan                                gui=underline guifg=#008800
highlight Ignore                          ctermfg=lightgreen                              guifg=#33bb33
highlight IncSearch     term=reverse      ctermfg=black ctermbg=darkgreen                 guifg=#000000 guibg=#336633
highlight LineNr        term=bold         ctermfg=green                                   guifg=#00ff00
highlight MatchParen    term=bold         ctermfg=black ctermbg=green                     guibg=#00ff00   guifg=#000000
highlight ModeMsg       term=bold         cterm=bold                                      gui=bold
highlight MoreMsg       term=bold         cterm=bold                                      gui=bold
highlight NonText                         ctermfg=darkcyan                                guifg=#999999
highlight Normal                          ctermfg=gray ctermbg=black                      guifg=#aaaaaa guibg=#000000
highlight Pmenu         term=reverse      ctermfg=black ctermbg=green                     guifg=#000000 guibg=#337733 
highlight PmenuSel      term=bold         ctermfg=black  ctermbg=gray                     guifg=#000000 guibg=#999999 
highlight PmenuSbar     term=reverse      ctermfg=black ctermbg=green                     guifg=#000000 guibg=#337733 
highlight PmenuThumb    term=reverse      ctermfg=gray ctermbg=black                      guifg=#999999 guibg=#000000 
highlight PreProc       term=standout     ctermfg=darkgreen                               guifg=#22bb22
highlight Question      term=standout     ctermfg=red                                     guifg=#ff0000
highlight Search        term=reverse      ctermfg=black ctermbg=darkgreen                 guifg=#000000 guibg=#228822
highlight SignColumn                      ctermfg=darkgreen                               guifg=#20de20 guibg=#000000
highlight Special       term=bold         ctermfg=green                                   guifg=#00ff00
highlight SpecialKey    term=bold         ctermfg=green                                   guifg=#00ff00
highlight SpellBad      term=reverse      cterm=underline ctermfg=red ctermbg=black       gui=undercurl guisp=#ff0000
highlight SpellCap      term=reverse      cterm=underline ctermfg=yellow ctermbg=black    gui=undercurl guisp=#00ffff
highlight SpellLocal    term=reverse      cterm=underline ctermfg=blue ctermbg=black      gui=undercurl guisp=#0000ff
highlight SpellRare     term=reverse      cterm=underline ctermfg=darkgreen ctermbg=black gui=undercurl guisp=#00ff00
highlight Statement     term=standout     ctermfg=darkred                                 guifg=#ac0000
highlight StatusLine    term=reverse      ctermfg=darkgreen ctermbg=black                 gui=none guibg=#228822 guifg=#000000
highlight StatusLineNC  term=reverse      ctermfg=darkgreen ctermbg=blue                  gui=none guibg=#336633 guifg=#000000
highlight TabLine       term=reverse      cterm=reverse ctermfg=black ctermbg=green       guibg=#222222 guifg=#228822
highlight TabLineFill   term=reverse      cterm=reverse ctermfg=green ctermbg=black       guibg=#222222 guifg=#226622
highlight TabLineSel                      ctermfg=black ctermbg=green                     guibg=#228822 guifg=#222222
highlight Title         term=reverse      ctermfg=black ctermbg=green                     guifg=#000000 guibg=#00ff00
highlight Todo          term=reverse      cterm=reverse ctermfg=darkgreen ctermbg=black   guibg=#336633 guifg=#000000
highlight Type          term=standout     ctermfg=green                                   guifg=#559955
highlight Visual        term=reverse      cterm=reverse ctermfg=darkgreen                 guifg=#000000 guibg=#336633
highlight VisualNOS     term=reverse,bold cterm=reverse ctermbg=darkgreen                 guifg=#000000 guibg=#228822
highlight VertSplit     term=reverse      ctermfg=darkgreen                               guifg=#336633
highlight User1         term=standout     cterm=bold ctermbg=darkgreen ctermfg=red        gui=bold guibg=#228822 guifg=#FF0000
highlight WarningMsg    term=reverse      ctermfg=black ctermbg=yellow                    guifg=#000000 guibg=#007a7a
highlight WildMenu      term=reverse      ctermfg=blue ctermbg=darkgreen                  guifg=#000099 guibg=#00ac00   

" ----------------------------------------------------------------------------------------------------------------------------------
" Common groups that link to other highlight definitions.

highlight link Constant     Character
highlight link Constant     Number
highlight link Constant     Boolean
highlight link Constant     String

highlight link LineNr       Operator

highlight link Number       Float

highlight link PreProc      Define
highlight link PreProc      Include
highlight link PreProc      Macro
highlight link PreProc      PreCondit

highlight link Question     Repeat

highlight link Repeat       Conditional

highlight link Special      Delimiter
highlight link Special      SpecialChar
highlight link Special      SpecialComment
highlight link Special      Tag

highlight link Statement    Exception
highlight link Statement    Keyword
highlight link Statement    Label

highlight link Type         StorageClass
highlight link Type         Structure
highlight link Type         Typedef

" ----------------------------------------------------------------------------------------------------------------------------------
" vim:tw=132:ts=4:sw=4
