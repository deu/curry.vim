" Hit C-y once to insert the function name,
" hit it again to insert '=' and 'undefined'

function! s:insertFunctionName()
    let lnr = search('^\l[0-9A-Za-z'']*\s*::', 'bnW')

    if lnr == 0
        return "\<C-y>"
    endif

    let funcname = substitute(getline(lnr), '\s*::.*', '', '')

    let cline = getline('.')

    " if line is empty -- 'funcname '
    if empty(cline)
        return funcname . ' '

    " if 'funcname' exists on the line -- '= '
    elseif cline =~ '^' . funcname . '\s*$'
        let pre = cline =~ '\s\+$' ? '' : ' '
        return pre . '= '

    " if 'funcname =' exists on the line -- 'undefined'
    elseif cline =~ '^' . funcname . '\s*=\s*$'
        let pre = cline =~ '\s\+$' ? '' : ' '
        return pre . 'undefined'

    " if line is 'fu' -- 'ncname '
    elseif strpart(funcname, 0, len(cline)) == cline
        return strpart(funcname, len(cline)) . ' '

    " else <C-y>
    else
        return "\<C-y>"

    endif
endfunction

if maparg("\<C-y>", 'i') == ''
    inoremap <buffer> <expr> <C-y> <SID>insertFunctionName()
endif

if maparg(']]','n') == ''
    nnoremap <silent><buffer> [[ m':call search('^\l[0-9A-Za-z'']*\s*::', "bW")<CR>
    nnoremap <silent><buffer> ]] m':call search('^\l[0-9A-Za-z'']*\s*::', "W")<CR>

    vnoremap <silent><buffer> [[ m':<C-u>exe "normal! gv"<BAR>call search('^\l[0-9A-Za-z'']*\s*::', "bW")<CR>
    vnoremap <silent><buffer> ]] m':<C-u>exe "normal! gv"<BAR>call search('^\l[0-9A-Za-z'']*\s*::', "W")<CR>
endif
