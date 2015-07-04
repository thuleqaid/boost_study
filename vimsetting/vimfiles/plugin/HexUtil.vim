" Name    : HexUtil
" Object  : access hex-data from xxd
" Author  : thuleqaid@163.com
" Date    : 2015/06/28
" Version : v0.1
" ChangeLog
" v0.1 2015/06/28
"   add HexTidy()
"   add HexRead()
"   add HexWrite()
"   add HexReplace()
"   add HexFind()
" Dependencies
"   Utility:xxd
" Workflow
"   1. use "xxd -ps [-c N] bin-file temp-text-file
"   2. edit temp-text-file with this plugin
"   3. use "xxd -ps [-c N] -r temp-text-file new-bin-file
" Usage
"   1. HexTidy() to align all lines
"   2. HexReplace() to escape/unescape text
"   3. HexFind() to find nearest byte-pattern
"   4. HexRead() to get string at specified offset(start from 0)
"   5. HexWrite() to write string at specified offset(start from 0)

function! HexTidy()
    " re-align the whole text based on the width of current line
    let l:maxwidth = s:lineWidth('.')
    let l:rdline1 = 1
    let l:rdline2 = line('$')
    let l:wtline = 1
    let l:wtbuf = ''
    while l:rdline1 <= l:rdline2
        let l:rdbuf = getline(l:rdline1)
        if (l:wtline == l:rdline1) && (len(l:wtbuf) == 0) && (len(l:rdbuf) == l:maxwidth)
            let l:wtline = l:wtline + 1
        else
            let l:wtbuf = l:wtbuf . l:rdbuf
            while (len(l:wtbuf) >= l:maxwidth) && (l:wtline <= l:rdline1)
                call setline(l:wtline, strpart(l:wtbuf, 0, l:maxwidth))
                let l:wtbuf = strpart(l:wtbuf, l:maxwidth)
                let l:wtline = l:wtline + 1
            endwhile
        endif
        let l:rdline1 = l:rdline1 + 1
    endwhile
    while len(l:wtbuf) >= l:maxwidth
        call setline(l:wtline, strpart(l:wtbuf, 0, l:maxwidth))
        let l:wtbuf = strpart(l:wtbuf, l:maxwidth)
        let l:wtline = l:wtline + 1
    endwhile
    if len(l:wtbuf) > 0
        call setline(l:wtline, l:wtbuf)
        let l:wtline = l:wtline + 1
    endif
    if l:wtline < l:rdline1
        silent exe 'normal ' . l:wtline . 'G' . (l:rdline1-l:wtline) . 'dd'
    endif
endfunction
function! HexAddr2Line(offset)
    let l:paramcheck = s:checkOffset(a:offset, 1)
    if l:paramcheck < 0
        return [0, 0]
    endif
    let l:maxwidth = s:lineWidth(1)
    let l:line1 = l:rdpos / l:maxwidth + 1
    let l:col1  = l:rdpos % l:maxwidth + 1
    return [l:line1, l:col1]
endfunction
function! HexLine2Addr(lineno, colno)
    let l:maxlineno = line('$')
    if (a:lineno <= 0) || (a:lineno > l:maxlineno)
        return [-1, -1]
    endif
    let l:maxwidth = s:lineWidth(1)
    if (a:colno <= 0) || (a:colno > l:maxwidth)
        return [-1, -1]
    endif
    return (a:lineno - 1) * l:maxwidth + a:colno
endfunction
function! HexRead(offset, datasize, isLittleEndian)
    " return data in string
    " text format before offset+datasize should be properly aligned
    let l:paramcheck = s:checkOffset(a:offset, a:datasize)
    if l:paramcheck < 0
        return ''
    endif
    let l:maxwidth = s:lineWidth(1)
    let l:rdpos  = a:offset * 2
    let l:rdsize = a:datasize * 2
    let l:line1 = l:rdpos / l:maxwidth + 1
    let l:col1  = l:rdpos % l:maxwidth
    let l:rdbuf = strpart(getline(l:line1), l:col1)
    let l:rddata = ''
    while len(l:rdbuf) < l:rdsize
        let l:rdsize = l:rdsize - len(l:rdbuf)
        let l:rddata = l:rddata . l:rdbuf
        let l:line1 = l:line1 + 1
        let l:rdbuf = getline(l:line1)
    endwhile
    let l:rddata = l:rddata . strpart(l:rdbuf, 0, l:rdsize)
    if a:isLittleEndian
        let l:rddata = join(reverse(split(l:rddata, '..\zs')), '')
    endif
    return l:rddata
endfunction
function! HexWrite(datastr, offset, datasize, isLittleEndian)
    " write string data in to specified position
    " text format before offset+datasize should be properly aligned
    let l:paramcheck = s:checkOffset(a:offset, a:datasize)
    if l:paramcheck < 0
        return -1
    endif
    let l:maxwidth = s:lineWidth(1)
    let l:wtpos  = a:offset * 2
    let l:wtsize = a:datasize * 2
    if len(a:datastr) < l:wtsize
        let l:wtdata = printf('%0' . l:wtsize . 's', a:datastr)
    elseif len(a:datastr) > l:wtsize
        let l:wtdata = strpart(a:datastr, strlen(a:datastr) - l:wtsize)
    else
        let l:wtdata = a:datastr
    endif
    if a:isLittleEndian
        let l:wtdata = join(reverse(split(l:wtdata, '..\zs')), '')
    endif
    let l:line1 = l:wtpos / l:maxwidth + 1
    let l:col1  = l:wtpos % l:maxwidth
    let l:rdbuf = getline(l:line1)
    if l:col1 + l:wtsize <= l:maxwidth
        let l:rdbuf = strpart(l:rdbuf, 0, l:col1) . l:wtdata . strpart(l:rdbuf, l:col1 + l:wtsize)
        call setline(l:line1, l:rdbuf)
    else
        let l:wtsize = l:maxwidth - l:col1
        let l:rdbuf = strpart(l:rdbuf, 0, l:col1) . strpart(l:wtdata, 0, l:wtsize)
        let l:wtdata = strpart(l:wtdata, l:wtsize)
        call setline(l:line1, l:rdbuf)
        let l:line1 = l:line1 + 1
        while len(l:wtdata) > l:maxwidth
            let l:rdbuf = strpart(l:wtdata, 0, l:maxwidth)
            let l:wtdata = strpart(l:wtdata, l:maxwidth)
            call setline(l:line1, l:rdbuf)
            let l:line1 = l:line1 + 1
        endwhile
        let l:rdbuf = l:wtdata . strpart(getline(l:line1), len(l:wtdata))
        call setline(l:line1, l:rdbuf)
    endif
    return 0
endfunction
function! HexFind(lineno, colno, itemlist, complen)
    " find the nearest match in the itemlist
    " if complen<=0, the length of the longest one in the itemlist will be used
    return s:findReplace(a:lineno, a:colno, a:itemlist, [], a:complen, 2)
endfunction
function! HexReplace(lineno, colno, itemlist, replacelist, complen)
    " replace all matches in the itemlist with replacelist
    " if complen<=0, the length of the longest one in the itemlist will be used
    if len(a:replacelist) >= len(a:itemlist)
        call s:findReplace(a:lineno, a:colno, a:itemlist, a:replacelist, a:complen, 2)
    endif
endfunction

function! s:lineWidth(lineno)
    let l:curwidth = strlen(getline(a:lineno))
    return l:curwidth
endfunction
function! s:textLength()
    let l:filelines = line('$')
    let l:filebytes = line2byte(l:filelines + 1) - 1
    if &fileformat == 'dos'
        let l:eolsize = 2
    else
        let l:eolsize = 1
    endif
    return l:filebytes - l:eolsize * l:filelines
endfunction
function! s:checkOffset(offset, datasize)
    if a:offset < 0
        return -1
    endif
    if a:datasize <= 0
        return -2
    endif
    let l:filesize = s:textLength()
    if a:offset + a:datasize > l:filesize / 2
        return -3
    endif
    return 0
endfunction
function! s:findReplace(lineno, colno, itemlist, replacelist, complen, step)
    let l:maxlineno = line('$')
    if (a:lineno <= 0) || (a:lineno > l:maxlineno)
        return [-1, -1]
    endif
    if len(a:itemlist) <= 0
        return [-1, -1]
    endif
    if len(a:replacelist) < len(a:itemlist)
        " find mode
        let l:workmode = 1
    else
        " replace mode
        let l:workmode = 2
    endif
    if a:complen <= 0
        let l:i = 0
        let l:complen = 0
        while l:i < len(a:itemlist)
            if len(a:itemlist[l:i]) > l:complen
                let l:complen = len(a:itemlist[l:i])
            endif
            let l:i = l:i + 1
        endwhile
    else
        let l:complen = a:complen
    endif
    let l:i = 0
    let l:itemlist = []
    while l:i < len(a:itemlist)
        call add(l:itemlist, strpart(a:itemlist[l:i], 0, l:complen))
        let l:i = l:i + 1
    endwhile
    let l:step = max([1, a:step])
    let l:rdlineno = a:lineno
    let l:wtlineno = a:lineno
    let l:linewidth = s:lineWidth(a:lineno)
    let l:rdbufsize = max([l:linewidth * 2, l:complen * 16])
    let l:strleft = strpart(getline(a:lineno), 0, a:colno - 1)
    let l:strright = strpart(getline(a:lineno), a:colno - 1)
    while l:rdlineno < l:maxlineno
        while (l:rdlineno < l:maxlineno) && (len(l:strright) < l:rdbufsize)
            let l:rdlineno = l:rdlineno + 1
            let l:strright = l:strright . getline(l:rdlineno)
        endwhile
        while len(l:strright) >= l:complen
            let l:compstr = strpart(l:strright, 0, l:complen)
            let l:i = 0
            while l:i < len(l:itemlist)
                if strpart(l:compstr, 0, len(l:itemlist[l:i])) == l:itemlist[l:i]
                    break
                endif
                let l:i = l:i + 1
            endwhile
            if l:i < len(l:itemlist)
                if l:workmode == 1
                    let l:leftlen = len(l:strleft)
                    let l:wtlineno = l:wtlineno + l:leftlen / l:linewidth
                    let l:leftlen = l:leftlen % l:linewidth
                    return [l:wtlineno, l:leftlen]
                elseif l:workmode == 2
                    let l:strleft = l:strleft . a:replacelist[l:i]
                    let l:strright = strpart(l:strright, len(l:itemlist[l:i]))
                endif
            else
                let l:strleft = l:strleft . strpart(l:strright, 0, l:step)
                let l:strright = strpart(l:strright, l:step)
            endif
            while (len(l:strleft) >= l:linewidth) && (l:wtlineno <= l:rdlineno)
                if l:workmode == 2
                    call setline(l:wtlineno, strpart(l:strleft, 0, l:linewidth))
                endif
                let l:strleft = strpart(l:strleft, l:linewidth)
                let l:wtlineno = l:wtlineno + 1
            endwhile
        endwhile
    endwhile
    if l:workmode == 1
        " not found
        return [0, 0]
    elseif l:workmode == 2
        let l:strleft = l:strleft . l:strright
        while len(l:strleft) > 0
            call setline(l:wtlineno, strpart(l:strleft, 0, l:linewidth))
            let l:strleft = strpart(l:strleft, l:linewidth)
            let l:wtlineno = l:wtlineno + 1
        endwhile
        if l:wtlineno <= l:maxlineno
            silent exe 'normal ' . l:wtlineno . 'G' . (l:maxlineno - l:wtlineno + 1) . 'dd'
        endif
    endif
endfunction

