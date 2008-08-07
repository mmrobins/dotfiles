set viminfo='20,\"50,%  " (vi) read/write a .viminfo file, don't store more
                        " than 50 lines of registers
autocmd BufEnter * lcd %:p:h
set hidden

function! GoToTheComponent()
    :write!
    :redraw!

    let htdocs_path = substitute( expand("%:p"), '/htdocs/.*', '/htdocs', '' )
    if !match( htdocs_path, '/htdocs')
        echom "no htdocs found in " . htdocs_path
    endif

    let mason_component = ''
    let the_line = getline('.')
    if match(the_line, '<& *["'."'".'][-_/a-zA-Z0-9\.]\+\.html') > -1
        let mason_component = matchstr(the_line, '\(<& *.\)\@<=[-_/a-zA-Z0-9\.]\+\.html')
    elseif match(the_line, '->s\?comp( *["'."'".'][-_/a-zA-Z0-9\.]\+') > -1
        let mason_component = matchstr(the_line, '\(->s\?comp( *.\)\@<=[-_/a-zA-Z0-9\.]\+')
    else
        echom 'failed to find a mason component with my wimpy regex'
        return
    endif

    if !match(mason_component, '^/')
        let mason_component = htdocs_path . mason_component
    else
        let current_dir = expand("%:h")
        let mason_component = current_dir . mason_component
    endif

    execute ":edit " . mason_component
endfunction

map  ,gc      :call GoToTheComponent()<cr>
map! ,gc <ESC>:call GoToTheComponent()<cr>i

