set viminfo='20,\"50,%  " (vi) read/write a .viminfo file, don't store more
                        " than 50 lines of registers
autocmd BufEnter * lcd %:p:h
set hidden

function! GoToTheImplementation()
    if match( expand("%:p"), "TEST" ) > -1
        :e ../%
    endif
endfunc

map  ,gi      :call GoToTheImplementation()<cr>
map! ,gi <ESC>:call GoToTheImplementation()<cr>i

