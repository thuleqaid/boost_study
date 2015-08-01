command! -n=0 -bar HlPan :call s:HeluoPaiPan()
command! -n=1 -bar HlYear :call s:HeluoYear(<args>)

let s:tbl_tianshu = [0 , 6 , 0 , 2  , 0 , 8 , 7 , 0 , 1 , 0  , 9 , 0 , 3 , 0 , 0 , 4  , 0 , 6 , 0 , 2]
let s:tbl_dishu   = [1 , 6 , 5 , 10 , 3 , 8 , 3 , 8 , 5 , 10 , 7 , 2 , 7 , 2 , 5 , 10 , 9 , 4 , 9 , 4  , 5 , 10 , 1 , 6]
let s:basicInfo   = { 'BYEAR' :1983, 'YEARGZ':60, 'MONTHGZ':57, 'DAYGZ':30, 'HOURGZ':56, 'YUN':6, 'TERMIDX':14,
                    \ 'GENDER':1   , 'NANNV' :2 , 'TIANSHU':34, 'DISHU':26,
                    \ 'GUA1'  :47  , 'YAO1'  :2 , 'GUA2'   :63, 'YAO2' :5}
function! s:HeluoPaiPan()
    let l:inputinfo = eval(getline('.'))
    let l:birthinfo = CalParseDateTime(l:inputinfo['CLOCKTIME'])
    let l:solarinfo = CalChineseSolarDT(l:birthinfo)
    let s:basicInfo['GENDER']  = (l:inputinfo['GENDER'] == 'F')?2:1
    let s:basicInfo['NANNV' ]  = (l:solarinfo[0] + s:basicInfo['GENDER']) % 2 + 1
    let s:basicInfo['YEARGZ']  = l:solarinfo[0]
    let s:basicInfo['MONTHGZ'] = l:solarinfo[1]
    let s:basicInfo['DAYGZ']   = l:solarinfo[2]
    let s:basicInfo['HOURGZ']  = l:solarinfo[3]
    let s:basicInfo['YUN']     = l:solarinfo[4]
    let s:basicInfo['TERMIDX'] = l:solarinfo[5]
    if (s:basicInfo['YEARGZ'] + l:birthinfo[0]) % 2 == 1
        let s:basicInfo['BYEAR'] = l:birthinfo[0]
    else
        let s:basicInfo['BYEAR'] = l:birthinfo[0] - 1
    endif
    let l:ts = 0
    let l:ds = 0
    "" 计算天数和地数
    "" 戊一乙癸二，庚三辛四同。壬甲从六数，丁七丙八宫。己九无差别，五数寄于中。
    "" 亥子一六水，寅卯三八真。巳午二七火，申酉四九金。辰戌丑未土，五十总生成。
    for l:i in range(4)
        let l:tmp1 = CalModulo(l:solarinfo[l:i] - 1, 10) * 2
        let l:tmp2 = CalModulo(l:solarinfo[l:i] - 1, 12) * 2
        let l:ts = l:ts + s:tbl_tianshu[l:tmp1]
        let l:ds = l:ds + s:tbl_tianshu[l:tmp1 + 1]
        let l:ts = l:ts + s:tbl_dishu[l:tmp2]
        let l:ds = l:ds + s:tbl_dishu[l:tmp2 + 1]
    endfor
    let s:basicInfo['TIANSHU'] = l:ts
    let s:basicInfo['DISHU']   = l:ds
    let l:ts = CalModulo(l:ts - 1, 25) + 1
    if l:ts % 10 == 0
        let l:ts = l:ts / 10
    else
        let l:ts = l:ts % 10
    endif
    let l:ds = CalModulo(l:ds - 1, 30) + 1
    if l:ds % 10 == 0
        let l:ds = l:ds / 10
    else
        let l:ds = l:ds % 10
    endif
    "" 上元男艮女为坤。女兑男离属下元。中元阴女阳男艮。阳女阴男亦寄坤。
    if (l:ts == 5) || (l:ds ==5)
        if s:basicInfo['YUN'] <= 3
            if s:basicInfo['GENDER'] == 1
                if l:ts == 5
                    let l:ts = 8
                endif
                if l:ds == 5
                    let l:ds = 8
                endif
            else
                if l:ts == 5
                    let l:ts = 2
                endif
                if l:ds == 5
                    let l:ds = 2
                endif
            endif
        elseif s:basicInfo['YUN'] <= 6
            if s:basicInfo['NANNV'] == 1
                if l:ts == 5
                    let l:ts = 8
                endif
                if l:ds == 5
                    let l:ds = 8
                endif
            else
                if l:ts == 5
                    let l:ts = 2
                endif
                if l:ds == 5
                    let l:ds = 2
                endif
            endif
        else
            if s:basicInfo['GENDER'] == 1
                if l:ts == 5
                    let l:ts = 9
                endif
                if l:ds == 5
                    let l:ds = 9
                endif
            else
                if l:ts == 5
                    let l:ts = 7
                endif
                if l:ds == 5
                    let l:ds = 7
                endif
            endif
        endif
    endif
    "" 八卦相荡成卦 阳男阴女，天数在上、地数在下成卦；阴男阳女，天数在下、地数在上成卦。
    if s:basicInfo['NANNV'] == 1
        let s:basicInfo['GUA1'] = s:trans_gua(l:ds) * 8 + s:trans_gua(l:ts)
    else
        let s:basicInfo['GUA1'] = s:trans_gua(l:ts) * 8 + s:trans_gua(l:ds)
    endif
    let l:yangyao = s:get_bit_sts(s:basicInfo['GUA1'])
    let l:shizhi  = (s:basicInfo['HOURGZ'] - 1) % 12 +1
    if l:shizhi <= 6
        let l:yinyang = 1
    else
        let l:yinyang = 0
        let l:shizhi = l:shizhi - 6
        let l:yangyao[0] = 6 - l:yangyao[0]
    endif
    if (l:yangyao[0] >= 1) && (l:yangyao[0] <= 3)
        if l:shizhi <= (l:yangyao[0] * 2)
            if l:shizhi > l:yangyao[0]
                let l:shizhi = l:shizhi - l:yangyao[0]
            endif
            for i in range(6)
                if l:yangyao[i+1] == l:yinyang
                    let l:shizhi = l:shizhi - 1
                endif
                if l:shizhi <= 0
                    let s:basicInfo['YAO1'] = i + 1
                    break
                endif
            endfor
        else
            let l:shizhi = l:shizhi - l:yangyao[0] * 2
            for i in range(6)
                if l:yangyao[i+1] != l:yinyang
                    let l:shizhi = l:shizhi - 1
                endif
                if l:shizhi <= 0
                    let s:basicInfo['YAO1'] = i + 1
                    break
                endif
            endfor
        endif
    elseif (l:yangyao[0] > 3) && (l:yangyao[0] < 6)
        if l:shizhi <= l:yangyao[0]
            for i in range(6)
                if l:yangyao[i+1] == l:yinyang
                    let l:shizhi = l:shizhi - 1
                endif
                if l:shizhi <= 0
                    let s:basicInfo['YAO1'] = i + 1
                    break
                endif
            endfor
        else
            let l:shizhi = l:shizhi - l:yangyao[0]
            for i in range(6)
                if l:yangyao[i+1] != l:yinyang
                    let l:shizhi = l:shizhi - 1
                endif
                if l:shizhi <= 0
                    let s:basicInfo['YAO1'] = i + 1
                    break
                endif
            endfor
        endif
    else
        if s:basicInfo['GUA1'] == 63
            if s:basicInfo['GENDER'] == 1
                if l:yinyang == 1
                    if l:shizhi > 3
                        let s:basicInfo['YAO1'] = l:shizhi - 3
                    else
                        let s:basicInfo['YAO1'] = l:shizhi
                    endif
                else
                    if l:shizhi > 3
                        let s:basicInfo['YAO1'] = l:shizhi
                    else
                        let s:basicInfo['YAO1'] = l:shizhi + 3
                    endif
                endif
            else
                if (s:basicInfo['TERMIDX'] >= 10) && (s:basicInfo['TERMIDX'] < 22)
                    if l:yinyang == 1
                        if l:shizhi > 3
                            let s:basicInfo['YAO1'] = l:shizhi - 3
                        else
                            let s:basicInfo['YAO1'] = l:shizhi
                        endif
                    else
                        if l:shizhi > 3
                            let s:basicInfo['YAO1'] = l:shizhi
                        else
                            let s:basicInfo['YAO1'] = l:shizhi + 3
                        endif
                    endif
                else
                    if l:yinyang == 1
                        if l:shizhi > 3
                            let s:basicInfo['YAO1'] = 10 - l:shizhi
                        else
                            let s:basicInfo['YAO1'] = 7 - l:shizhi
                        endif
                    else
                        if l:shizhi > 3
                            let s:basicInfo['YAO1'] = 7 - l:shizhi
                        else
                            let s:basicInfo['YAO1'] = 4 - l:shizhi
                        endif
                    endif
                endif
            endif
        else
            if s:basicInfo['GENDER'] == 2
                if l:yinyang == 1
                    if l:shizhi > 3
                        let s:basicInfo['YAO1'] = l:shizhi - 3
                    else
                        let s:basicInfo['YAO1'] = l:shizhi
                    endif
                else
                    if l:shizhi > 3
                        let s:basicInfo['YAO1'] = l:shizhi
                    else
                        let s:basicInfo['YAO1'] = l:shizhi + 3
                    endif
                endif
            else
                if (s:basicInfo['TERMIDX'] >= 10) && (s:basicInfo['TERMIDX'] < 22)
                    if l:yinyang == 1
                        if l:shizhi > 3
                            let s:basicInfo['YAO1'] = 10 - l:shizhi
                        else
                            let s:basicInfo['YAO1'] = 7 - l:shizhi
                        endif
                    else
                        if l:shizhi > 3
                            let s:basicInfo['YAO1'] = 7 - l:shizhi
                        else
                            let s:basicInfo['YAO1'] = 4- l:shizhi
                        endif
                    endif
                else
                    if l:yinyang == 1
                        if l:shizhi > 3
                            let s:basicInfo['YAO1'] = l:shizhi - 3
                        else
                            let s:basicInfo['YAO1'] = l:shizhi
                        endif
                    else
                        if l:shizhi > 3
                            let s:basicInfo['YAO1'] = l:shizhi
                        else
                            let s:basicInfo['YAO1'] = l:shizhi + 3
                        endif
                    endif
                endif
            endif
        endif
    endif
    let l:pow2 = [32, 16, 8, 4, 2, 1]
    let s:basicInfo['GUA2'] = xor(s:basicInfo['GUA1'], l:pow2[s:basicInfo['YAO1'] - 1])
    let s:basicInfo['YAO2'] = s:basicInfo['YAO1']
    if ((s:basicInfo['GUA1'] == 10) || (s:basicInfo['GUA1'] == 18) || (s:basicInfo['GUA1'] == 34)) && (s:basicInfo['YAO2'] > 4)
        if (s:basicInfo['MONTHGZ'] % 2) == 1
            if s:basicInfo['YAO2'] == 5
                let s:basicInfo['YAO2'] = s:basicInfo['YAO2'] - 3
                let s:basicInfo['GUA2'] = (s:basicInfo['GUA2'] / 8) + ((s:basicInfo['GUA2'] % 8) * 8)
            endif
        else
            if s:basicInfo['YAO2'] == 6
                let s:basicInfo['YAO2'] = s:basicInfo['YAO2'] - 3
                let s:basicInfo['GUA2'] = (s:basicInfo['GUA2'] / 8) + ((s:basicInfo['GUA2'] % 8) * 8)
            endif
        endif
    else
        let s:basicInfo['YAO2'] = (s:basicInfo['YAO2'] + 2) % 6 + 1
        let s:basicInfo['GUA2'] = (s:basicInfo['GUA2'] / 8) + ((s:basicInfo['GUA2'] % 8) * 8)
    endif
    call s:HeluoYear(str2nr(strftime("%Y")))
endfunction

function! s:HeluoYear(year)
    " @ret: [先天/后天运， 大运， 岁运， 月运]
    let l:out = [[], [], [], []]
    let l:gua1 = s:get_bit_sts(s:basicInfo['GUA1'])
    let l:gua2 = s:get_bit_sts(s:basicInfo['GUA2'])
    let l:minyear = s:basicInfo['BYEAR']
    let l:midyear = l:gua1[0] * 3 + 36 + l:minyear
    let l:maxyear = l:gua2[0] * 3 + 36 + l:midyear
    let l:year = a:year
    if l:year < l:minyear
        let l:year = l:minyear
    elseif l:year >= l:maxyear
        let l:year = l:maxyear - 1
    endif
    " 先天/后天运
    if l:year < l:midyear
        call add(l:out[0], s:basicInfo['GUA1'])
        call add(l:out[0], s:basicInfo['YAO1'])
        call add(l:out[0], l:minyear)
        call add(l:out[0], l:midyear - 1)
    else
        call add(l:out[0], s:basicInfo['GUA2'])
        call add(l:out[0], s:basicInfo['YAO2'])
        call add(l:out[0], l:midyear)
        call add(l:out[0], l:maxyear - 1)
    endif
    " 大运
    let l:gua1 = s:get_bit_sts(l:out[0][0])
    let l:yao1 = l:out[0][1]
    let l:yearcnt = l:year - l:out[0][2]
    for l:i in range(6)
        let l:yaoyears = l:gua1[l:yao1] * 3 + 6
        if l:yaoyears > l:yearcnt
            call add(l:out[1], l:out[0][0])
            call add(l:out[1], l:yao1)
            call add(l:out[1], l:year - l:yearcnt)
            call add(l:out[1], l:year - l:yearcnt + l:yaoyears - 1)
            break
        endif
        let l:yearcnt = l:yearcnt - l:yaoyears
        if l:yao1 >= 6
            let l:yao1 = 1
        else
            let l:yao1 = l:yao1 + 1
        endif
    endfor
    unlet l:gua2
    " 岁运
    let l:gua2 = l:out[1][0]
    let l:yao2 = l:out[1][1]
    let l:pow2 = [32, 16, 8, 4, 2, 1]
    if l:yaoyears > 6
        if (l:year - l:yearcnt) % 2 == 1
            let l:gua2 = xor(l:gua2, l:pow2[l:yao2 - 1])
        endif
        if l:yearcnt > 0
            if l:yao2 > 3
                let l:gua2 = xor(l:gua2, l:pow2[l:yao2 - 4])
            else
                let l:gua2 = xor(l:gua2, l:pow2[l:yao2 + 2])
            endif
            let l:yearcnt = l:yearcnt - 1
            let l:yao2 = l:yao2 - 1
            for l:i in range(l:yearcnt)
                if l:yao2 >= 6
                    let l:yao2 = 1
                else
                    let l:yao2 = l:yao2 + 1
                endif
                let l:gua2 = xor(l:gua2, l:pow2[l:yao2 -1])
            endfor
        endif
    else
        let l:yao2 = l:yao2 - 1
        for l:i in range(l:yearcnt + 1)
            if l:yao2 >= 6
                let l:yao2 = 1
            else
                let l:yao2 = l:yao2 + 1
            endif
            let l:gua2 = xor(l:gua2, l:pow2[l:yao2 -1])
        endfor
    endif
    call add(l:out[2], l:gua2)
    call add(l:out[2], l:yao2)
    call add(l:out[2], l:year)
    " 月运
    for l:i in range(6)
        if l:yao2 >= 6
            let l:yao2 = 1
        else
            let l:yao2 = l:yao2 + 1
        endif
        let l:gua2 = xor(l:gua2, l:pow2[l:yao2 - 1])
        call add(l:out[3], [l:gua2, l:yao2, l:i * 2 + 1])
        if l:yao2 > 3
            let l:yao3 = l:yao2 - 3
        else
            let l:yao3 = l:yao2 + 3
        endif
        let l:gua3 = xor(l:gua2, l:pow2[l:yao3 - 1])
        call add(l:out[3], [l:gua3, l:yao3, l:i * 2 + 2])
    endfor
    call s:outputResult(l:out)
endfunction

function! s:outputResult(info)
    let l:curline = line('.')
    let l:txtPath = s:findFile()
    if strlen(l:txtPath) > 0
        let l:filedata = readfile(l:txtPath)
        let l:outtxt = []
        "call add(l:outtxt, printf("%4d ~ %4d", a:info[0][2], a:info[0][3]))
        "call add(l:outtxt, s:stripNo(l:filedata[a:info[0][0]*7]))
        "call add(l:outtxt, s:stripNo(l:filedata[a:info[0][0]*7+a:info[0][1]]))
        call add(l:outtxt, printf("%4d ~ %4d", a:info[1][2], a:info[1][3]))
        call add(l:outtxt, s:stripNo(l:filedata[a:info[1][0]*7]))
        call add(l:outtxt, s:stripNo(l:filedata[a:info[1][0]*7+a:info[1][1]]))
        call add(l:outtxt, printf("%4d", a:info[2][2]))
        call add(l:outtxt, s:stripNo(l:filedata[a:info[2][0]*7]))
        call add(l:outtxt, s:stripNo(l:filedata[a:info[2][0]*7+a:info[2][1]]))
        for l:i in range(12)
            call add(l:outtxt, printf("%02d", a:info[3][l:i][2]))
            call add(l:outtxt, s:stripNo(l:filedata[a:info[3][l:i][0]*7]))
            call add(l:outtxt, s:stripNo(l:filedata[a:info[3][l:i][0]*7+a:info[3][l:i][1]]))
        endfor
        for l:i in range(len(l:outtxt))
            call append(l:curline + l:i, l:outtxt[l:i])
        endfor
        silent exe string(l:curline + 1) . ',' . string(l:curline + len(l:outtxt)) . 's/://g'
    else
        call append(l:curline, string(a:info))
    endif
endfunction

function! s:trans_gua(shu)
    "" 一数坎兮二数坤
    "" 三震四巽数中分
    "" 五寄中宫六是乾
    "" 七兑八艮九离门
    let l:gua = 0
    if a:shu == 1
        let l:gua = 2
    elseif a:shu == 2
        let l:gua = 0
    elseif a:shu == 3
        let l:gua = 4
    elseif a:shu == 4
        let l:gua = 3
    elseif a:shu == 6
        let l:gua = 7
    elseif a:shu == 7
        let l:gua = 6
    elseif a:shu == 8
        let l:gua = 1
    elseif a:shu == 9
        let l:gua = 5
    endif
    return l:gua
endfunction
function! s:get_bit_sts(gua)
    let l:sts = repeat([0, ], 7)
    let l:gua = a:gua
    for l:i in range(6)
        let l:sts[0] = l:sts[0] + (l:gua % 2)
        let l:sts[6 - i] = l:gua % 2
        let l:gua = l:gua / 2
    endfor
    return l:sts
endfunction
function! s:findFile()
    let l:path = globpath(&rtp, 'plugin/Heluo.txt')
    return l:path
endfunction
function! s:stripNo(txt)
    let l:idx = stridx(a:txt, '#')
    return strpart(a:txt, l:idx + 1)
endfunction

