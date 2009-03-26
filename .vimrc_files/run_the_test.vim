set viminfo='20,\"50,%  " (vi) read/write a .viminfo file, don't store more
                        " than 50 lines of registers
call RTKSource('go_to_test.vim')

if ! exists("g:rtk_test_command")
    let g:rtk_test_command = "nice rtk_appropriate_perl_for_directory /usr/local/bin/rtk_test"
endif

set errorformat=%f^^%l^^%m

function! s:RTK_load_errors(file)
    exec( ':cg ' . a:file )
endfunction

function! s:RTK_shell_run_tests(flags, test)
    let test_results_file=tempname()
    let parsed_errors_file=tempname()

    let cmd = ":!clear;"
    let cmd = cmd . g:rtk_test_command . ' ' . a:flags . ' -th ' . a:test
    let cmd = cmd . ' 2>&1 | tee ' . test_results_file . '; '

    let parse_errors_bin = g:rtk_vimrc_files_dir . 'parse_errors.pl'
    if (!executable(parse_errors_bin))
        let cmd = cmd . 'echo; echo ' . parse_errors_bin . ' was not found or is not executable, cannot create error list ' 
        let can_parse_errors=0
    else
        let cmd = cmd . parse_errors_bin . ' < ' . test_results_file . ' > ' . parsed_errors_file
        let can_parse_errors=1
    endif
    exec( cmd )

    if (can_parse_errors)
        call s:RTK_load_errors(parsed_errors_file)
    endif
endfunction

"Search for the current RTK test and run it
function! RTK_Test(flags)
    :write!
    :redraw!

    let l:saved_line_no = line('.')
    let l:saved_col_no = col('.')
    call cursor(l:saved_line_no + 1, col(1))
    let test_sub_pattern = "^sub *TEST_.*$"

    if search(test_sub_pattern, "bW") || search(test_sub_pattern, "W")
        let l:test_name = matchstr(getline('.'), "TEST_[^\($]*")
        call s:RTK_shell_run_tests(a:flags, '-f ' . l:test_name . ' ' . expand("%:p"))
    elseif match( expand("%:p"), "TEST" ) <= -1
        call GoToTheTest()
        call RTK_Test("")
    else
        echom "RTK_Test() failed to identify a test even though it seems we are in a test module"
    endif
endfunction

function! RTK_All_Tests(flags)
    write!
    call GoToTheTest()
    
    call s:RTK_shell_run_tests(a:flags, expand("%:p"))
endfunction

map  ,tc      :call RTK_Test("-c")<cr>
map! ,tc <ESC>:call RTK_Test("-c")<cr>

map  ,ts      :call RTK_Test("-s")<cr>
map! ,ts <ESC>:call RTK_Test("-s")<cr>

map  ,t       :call RTK_Test("")<cr>
map! ,t  <ESC>:call RTK_Test("")<cr>

map  ,TC       :call RTK_All_Tests("-c")<cr>
map! ,TC  <ESC>:call RTK_All_Tests("-c")<cr>
map  ,Tc       :call RTK_All_Tests("-c")<cr>
map! ,Tc  <ESC>:call RTK_All_Tests("-c")<cr>

map  ,TS       :call RTK_All_Tests("-s")<cr>
map! ,TS  <ESC>:call RTK_All_Tests("-s")<cr>
map  ,Ts       :call RTK_All_Tests("-s")<cr>
map! ,Ts  <ESC>:call RTK_All_Tests("-s")<cr>

map  ,T       :call RTK_All_Tests("")<cr>
map! ,T  <ESC>:call RTK_All_Tests("")<cr>

"map  <C-C>       :write!<cr>:call GoToTheTest()<cr>:! rtk_test -thc %<cr>
"map! <C-C>  <ESC>:write!<cr>:call GoToTheTest()<cr>:! rtk_test -thc %<cr>

