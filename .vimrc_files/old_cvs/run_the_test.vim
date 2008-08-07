set viminfo='20,\"50,%  " (vi) read/write a .viminfo file, don't store more
                        " than 50 lines of registers
source ~msw/.vimrc_sources/go_to_test.vim

"Search for the current RTK test and run it
function! RTK_Test()
    :write!
    :redraw!

    let l:saved_line_no = line('.')
    let l:saved_col_no = col('.')
    call cursor(l:saved_line_no + 1, col(1))
    let test_sub_pattern = "^sub.*TEST_.*$"

    if search(test_sub_pattern, "bW") || search(test_sub_pattern, "W")
        let l:test_name = matchstr(getline('.'), "TEST_[^\($]*")
        let command_line = ':!clear;rtk_test -th -f ' . l:test_name . ' ' . expand("%:p")
        exec( command_line )
    elseif match( expand("%:p"), "TEST" ) <= -1
        call GoToTheTest()
        call RTK_Test()
    else
        echom "RTK_Test() failed to identify a test even though it seems we are in a test module"
    endif
endfunction

map  ,t       :call RTK_Test()<cr>
map! ,t  <ESC>:call RTK_Test()<cr>

map  ,T       :write!<cr>:call GoToTheTest()<cr>:!clear; rtk_test -th %<cr>
map! ,T  <ESC>:write!<cr>:call GoToTheTest()<cr>:!clear; rtk_test -th %<cr>

"map  <C-C>       :write!<cr>:call GoToTheTest()<cr>:! rtk_test -thc %<cr>
"map! <C-C>  <ESC>:write!<cr>:call GoToTheTest()<cr>:! rtk_test -thc %<cr>

