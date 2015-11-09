" Name    : LiuYao
" Object  : Switch guifont quickly
" Author  : thuleqaid@163.com
" Date    : 2015/11/09
" Version : v0.4
" ChangeLog
" v0.4 2015/11/09
"   move s:ListAndSelect into common.vim
" v0.3 2015/08/31
"   use python script to generate random initial value
" v0.2 2015/07/17
"   move date calculation into CalTrans.vim
" v0.1 2015/07/15
"   new plugin
let g:ly_paipan_mode = get(g:, 'ly_paipan_mode', 0) " 0:六爻, 1:梅花
let g:ly_visible_all = get(g:, 'ly_visible_all', 0) " 只用于六爻排盘方式 0:只显示宫卦中的伏神和变卦中的动爻, 1:显示宫卦和变卦中所有的爻

" define command
command! -n=0 -bar LyNew :call s:InsertDateTime()
command! -n=0 -bar LyPan :call s:ParseDateTime()
command! -n=0 -bar LyMode :call s:SetPaiPanMode()

let s:paipanmethod = ['LiuYao', 'MeiHua']
let s:setupmethod = ['Coin Head', 'Coin Tail', 'Gua Code', 'Three Numbers']
let s:setupexample = ['CH:000000', 'CT:000000', 'GC:11123456', 'TN:111,222,333']
let s:txtYao = ['----  ----', '----------']
if &encoding == 'utf-8'
    " utf-8
    let s:txtLS       = ['青龙'  , '朱雀' , '勾陈' , '滕蛇' , '白虎' , '玄武']
    let s:txtLQ       = ['兄'    , '父'   , '官'   , '财'   , '孙']
    let s:txtGua      = ['坤'    , '艮'   , '坎'   , '巽'   , '震'   , '离'    , '兑'   , '乾']
    let s:txtGuaType  = ['宫'    , '正'   , '互'   , '变'   , '错'   , '综']
    let s:txtExtra    = ['世'    , '应'   , '动'   , '伏'   , '为']
    let s:txt64Gua    = [ '坤'   , '剥'   , '比'   , '观'   , '豫'   , '晋'    , '萃'   , '否'   ,
                        \ '谦'   , '艮'   , '蹇'   , '渐'   , '小过' , '旅'    , '咸'   , '遯'   ,
                        \ '师'   , '蒙'   , '坎'   , '涣'   , '解'   , '未济'  , '困'   , '讼'   ,
                        \ '升'   , '蛊'   , '井'   , '巽'   , '恒'   , '鼎'    , '大过' , '姤'   ,
                        \ '复'   , '颐'   , '屯'   , '益'   , '震'   , '噬嗑'  , '随'   , '无妄' ,
                        \ '明夷' , '贲'   , '既济' , '家人' , '丰'   , '离'    , '革'   , '同人' ,
                        \ '临'   , '损'   , '节'   , '中孚' , '归妹' , '睽'    , '兑'   , '履'   ,
                        \ '泰'   , '大畜' , '需'   , '小畜' , '大壮' , '大有'  , '夬'   , '乾'   ]
    let s:txtGuaXiang = ['地'    , '山'   , '水'   , '风'   , '雷'   , '火'    , '泽'   , '天']
else
    " cp936
    let s:txtLS = [
                  \ iconv("\xe9\x9d\x92\xe9\xbe\x99", "utf-8", &enc),
                  \ iconv("\xe6\x9c\xb1\xe9\x9b\x80", "utf-8", &enc),
                  \ iconv("\xe5\x8b\xbe\xe9\x99\x88", "utf-8", &enc),
                  \ iconv("\xe6\xbb\x95\xe8\x9b\x87", "utf-8", &enc),
                  \ iconv("\xe7\x99\xbd\xe8\x99\x8e", "utf-8", &enc),
                  \ iconv("\xe7\x8e\x84\xe6\xad\xa6", "utf-8", &enc),
                  \ ]
    let s:txtLQ = [
                  \ iconv("\xe5\x85\x84", "utf-8", &enc),
                  \ iconv("\xe7\x88\xb6", "utf-8", &enc),
                  \ iconv("\xe5\xae\x98", "utf-8", &enc),
                  \ iconv("\xe8\xb4\xa2", "utf-8", &enc),
                  \ iconv("\xe5\xad\x99", "utf-8", &enc),
                  \ ]
    let s:txtGua = [
                   \ iconv("\xe5\x9d\xa4", "utf-8", &enc),
                   \ iconv("\xe8\x89\xae", "utf-8", &enc),
                   \ iconv("\xe5\x9d\x8e", "utf-8", &enc),
                   \ iconv("\xe5\xb7\xbd", "utf-8", &enc),
                   \ iconv("\xe9\x9c\x87", "utf-8", &enc),
                   \ iconv("\xe7\xa6\xbb", "utf-8", &enc),
                   \ iconv("\xe5\x85\x91", "utf-8", &enc),
                   \ iconv("\xe4\xb9\xbe", "utf-8", &enc),
                   \ ]
    let s:txtGuaType = [
                       \ iconv("\xe5\xae\xab", "utf-8", &enc),
                       \ iconv("\xe6\xad\xa3", "utf-8", &enc),
                       \ iconv("\xe4\xba\x92", "utf-8", &enc),
                       \ iconv("\xe5\x8f\x98", "utf-8", &enc),
                       \ iconv("\xe9\x94\x99", "utf-8", &enc),
                       \ iconv("\xe7\xbb\xbc", "utf-8", &enc),
                       \ ]
    let s:txtExtra = [
                     \ iconv("\xe4\xb8\x96", "utf-8", &enc),
                     \ iconv("\xe5\xba\x94", "utf-8", &enc),
                     \ iconv("\xe5\x8a\xa8", "utf-8", &enc),
                     \ iconv("\xe4\xbc\x8f", "utf-8", &enc),
                     \ iconv("\xe4\xb8\xba", "utf-8", &enc),
                     \ ]
    let s:txt64Gua = [
                     \ iconv("\xe5\x9d\xa4", "utf-8", &enc),
                     \ iconv("\xe5\x89\xa5", "utf-8", &enc),
                     \ iconv("\xe6\xaf\x94", "utf-8", &enc),
                     \ iconv("\xe8\xa7\x82", "utf-8", &enc),
                     \ iconv("\xe8\xb1\xab", "utf-8", &enc),
                     \ iconv("\xe6\x99\x8b", "utf-8", &enc),
                     \ iconv("\xe8\x90\x83", "utf-8", &enc),
                     \ iconv("\xe5\x90\xa6", "utf-8", &enc),
                     \ iconv("\xe8\xb0\xa6", "utf-8", &enc),
                     \ iconv("\xe8\x89\xae", "utf-8", &enc),
                     \ iconv("\xe8\xb9\x87", "utf-8", &enc),
                     \ iconv("\xe6\xb8\x90", "utf-8", &enc),
                     \ iconv("\xe5\xb0\x8f\xe8\xbf\x87", "utf-8", &enc),
                     \ iconv("\xe6\x97\x85", "utf-8", &enc),
                     \ iconv("\xe5\x92\xb8", "utf-8", &enc),
                     \ iconv("\xe9\x81\xaf", "utf-8", &enc),
                     \ iconv("\xe5\xb8\x88", "utf-8", &enc),
                     \ iconv("\xe8\x92\x99", "utf-8", &enc),
                     \ iconv("\xe5\x9d\x8e", "utf-8", &enc),
                     \ iconv("\xe6\xb6\xa3", "utf-8", &enc),
                     \ iconv("\xe8\xa7\xa3", "utf-8", &enc),
                     \ iconv("\xe6\x9c\xaa\xe6\xb5\x8e", "utf-8", &enc),
                     \ iconv("\xe5\x9b\xb0", "utf-8", &enc),
                     \ iconv("\xe8\xae\xbc", "utf-8", &enc),
                     \ iconv("\xe5\x8d\x87", "utf-8", &enc),
                     \ iconv("\xe8\x9b\x8a", "utf-8", &enc),
                     \ iconv("\xe4\xba\x95", "utf-8", &enc),
                     \ iconv("\xe5\xb7\xbd", "utf-8", &enc),
                     \ iconv("\xe6\x81\x92", "utf-8", &enc),
                     \ iconv("\xe9\xbc\x8e", "utf-8", &enc),
                     \ iconv("\xe5\xa4\xa7\xe8\xbf\x87", "utf-8", &enc),
                     \ iconv("\xe5\xa7\xa4", "utf-8", &enc),
                     \ iconv("\xe5\xa4\x8d", "utf-8", &enc),
                     \ iconv("\xe9\xa2\x90", "utf-8", &enc),
                     \ iconv("\xe5\xb1\xaf", "utf-8", &enc),
                     \ iconv("\xe7\x9b\x8a", "utf-8", &enc),
                     \ iconv("\xe9\x9c\x87", "utf-8", &enc),
                     \ iconv("\xe5\x99\xac\xe5\x97\x91", "utf-8", &enc),
                     \ iconv("\xe9\x9a\x8f", "utf-8", &enc),
                     \ iconv("\xe6\x97\xa0\xe5\xa6\x84", "utf-8", &enc),
                     \ iconv("\xe6\x98\x8e\xe5\xa4\xb7", "utf-8", &enc),
                     \ iconv("\xe8\xb4\xb2", "utf-8", &enc),
                     \ iconv("\xe6\x97\xa2\xe6\xb5\x8e", "utf-8", &enc),
                     \ iconv("\xe5\xae\xb6\xe4\xba\xba", "utf-8", &enc),
                     \ iconv("\xe4\xb8\xb0", "utf-8", &enc),
                     \ iconv("\xe7\xa6\xbb", "utf-8", &enc),
                     \ iconv("\xe9\x9d\xa9", "utf-8", &enc),
                     \ iconv("\xe5\x90\x8c\xe4\xba\xba", "utf-8", &enc),
                     \ iconv("\xe4\xb8\xb4", "utf-8", &enc),
                     \ iconv("\xe6\x8d\x9f", "utf-8", &enc),
                     \ iconv("\xe8\x8a\x82", "utf-8", &enc),
                     \ iconv("\xe4\xb8\xad\xe5\xad\x9a", "utf-8", &enc),
                     \ iconv("\xe5\xbd\x92\xe5\xa6\xb9", "utf-8", &enc),
                     \ iconv("\xe7\x9d\xbd", "utf-8", &enc),
                     \ iconv("\xe5\x85\x91", "utf-8", &enc),
                     \ iconv("\xe5\xb1\xa5", "utf-8", &enc),
                     \ iconv("\xe6\xb3\xb0", "utf-8", &enc),
                     \ iconv("\xe5\xa4\xa7\xe7\x95\x9c", "utf-8", &enc),
                     \ iconv("\xe9\x9c\x80", "utf-8", &enc),
                     \ iconv("\xe5\xb0\x8f\xe7\x95\x9c", "utf-8", &enc),
                     \ iconv("\xe5\xa4\xa7\xe5\xa3\xae", "utf-8", &enc),
                     \ iconv("\xe5\xa4\xa7\xe6\x9c\x89", "utf-8", &enc),
                     \ iconv("\xe5\xa4\xac", "utf-8", &enc),
                     \ iconv("\xe4\xb9\xbe", "utf-8", &enc),
                     \ ]
    let s:txtGuaXiang = [
                        \ iconv("\xe5\x9c\xb0", "utf-8", &enc),
                        \ iconv("\xe5\xb1\xb1", "utf-8", &enc),
                        \ iconv("\xe6\xb0\xb4", "utf-8", &enc),
                        \ iconv("\xe9\xa3\x8e", "utf-8", &enc),
                        \ iconv("\xe9\x9b\xb7", "utf-8", &enc),
                        \ iconv("\xe7\x81\xab", "utf-8", &enc),
                        \ iconv("\xe6\xb3\xbd", "utf-8", &enc),
                        \ iconv("\xe5\xa4\xa9", "utf-8", &enc),
                        \ ]
endif
let s:wxGua = [4, 4, 1, 2, 2, 3, 5, 5] " 土，土，水，木，木，火，金，金
let s:baseGZ = [[10, 12,  2,  4,  6,  8],
              \ [ 3,  1, 11,  9,  7,  5],
              \ [ 1, 11,  9,  7,  5,  3],
              \ [ 4,  6,  8, 10, 12,  2],
              \ [11,  9,  7,  5,  3,  1],
              \ [ 6,  8, 10, 12,  2,  4],
              \ [ 8, 10, 12,  2,  4,  6],
              \ [11,  9,  7,  5,  3,  1]]

function! s:SetPaiPanMode()
    let l:mode = ListAndSelect('PaiPan Mode List:', s:paipanmethod, g:ly_paipan_mode)
    if l:mode >= 0
        let g:ly_paipan_mode = l:mode
    endif
endfunction
function! s:InsertDateTime()
    let l:curdt = CalNow()
    let l:method = ListAndSelect('Method List:', s:setupmethod, -1)
    if l:method >= 0
        let l:coins = s:setupexample[l:method]
        if has("python")
            let l:coins = system("python " . s:findFile() . ' '. strpart(l:coins,0,2))
            let l:coins = strpart(l:coins, 0, strlen(l:coins)-1)
        endif
        if len(getline('.')) > 0
            call append(line('.'), "{'TIME':'" . l:curdt . "', 'COINS':'" . l:coins . "'}")
        else
            call setline(line('.'), "{'TIME':'" . l:curdt . "', 'COINS':'" . l:coins . "'}")
        endif
    endif
endfunction
function! s:ParseDateTime()
    let l:curlineno = line('.')
    let l:parts  = eval(getline(l:curlineno))
    let l:datetime  = CalParseDateTime(l:parts['TIME'])
    let l:datenew = CalChineseSolarDT(l:datetime)
    if l:datenew[0] <= 0
        return
    endif
    let l:datestr = CalChineseSolarDTStr("%YG%YZ%YC %MG%MZ%MC %DG%DZ%DC %HG%HZ%HC %NC%DN", l:datenew)
    let l:guas = s:calcGua(l:parts['COINS'])
    if (l:guas[0] < 0) || (l:guas[1] < 0)
        return
    endif
    let l:guastr = s:calcGuaStr(l:guas, l:datenew[2])
    call append(l:curlineno, l:datestr)
    for l:i in range(len(s:txtLS) + 1)
        let l:curlineno = l:curlineno + 1
        call append(l:curlineno, l:guastr[i])
    endfor
endfunction
function! s:calcGuaStr(guas, day)
    let l:yaolen  = len(s:txtLS)
    let l:wxlen   = len(s:txtLQ)
    let l:typelen = len(s:txtGuaType)
    let l:yaostr  = repeat(['',], l:yaolen + 1)
    let l:day     = CalModulo(a:day - 1, 10)
    " 记录各类型卦爻的起始列（一个汉字占2列，对于不同的编码所占的字节数可能为2也可能为3）
    let l:guacol  = repeat([0,], l:typelen)
    " 记录各类型卦信息（卦名，宫卦，世爻位置）
    let l:guainfo = []
    let l:base    = s:calcBase(a:guas[0])
    let l:basewx  = s:wxGua[l:base[0] % 8]
    " 宫卦信息
    call add(l:guainfo, [l:base[0], l:base[0] % 8, 6])
    " 正卦信息
    call add(l:guainfo, [a:guas[0], l:base[0] % 8, l:base[1]])
    " 互卦信息
    let l:guahu   = and(a:guas[0], 14) / 2 + and(a:guas[0], 28) * 2
    let l:base    = s:calcBase(l:guahu)
    call add(l:guainfo, [l:guahu, l:base[0] % 8, l:base[1]])
    " 变卦信息
    let l:base    = s:calcBase(a:guas[1])
    call add(l:guainfo, [a:guas[1], l:base[0] % 8, l:base[1]])
    " 错卦信息
    let l:guacuo  = xor(a:guas[0], 63)
    let l:base    = s:calcBase(l:guacuo)
    call add(l:guainfo, [l:guacuo, l:base[0] % 8, l:base[1]])
    " 综卦信息
    let l:guazong = and(a:guas[0], 1) * 32 + and(a:guas[0], 2) * 8 + and(a:guas[0], 4) * 2 + and(a:guas[0], 8) / 2 + and(a:guas[0], 16) / 8 + and(a:guas[0], 32) / 32
    let l:base    = s:calcBase(l:guazong)
    call add(l:guainfo, [l:guazong, l:base[0] % 8, l:base[1]])
    " 初爻六神
    if l:day < 2
        let l:day = 0
    elseif l:day < 4
        let l:day = 1
    elseif l:day < 5
        let l:day = 2
    elseif l:day < 6
        let l:day = 3
    elseif l:day < 8
        let l:day = 4
    else
        let l:day = 5
    endif
    " 记录六亲出现情况（宫卦，正卦变卦）
    let l:lq0 = []
    for l:j in range(l:wxlen)
        call add(l:lq0, [])
    endfor
    let l:lq1 = repeat([0,], l:wxlen)
    " 装卦
    for l:j in range(2)
        if l:j == 0
            " 上卦
            let l:gua00 = l:guainfo[0][0] % 8
            let l:gua01 = l:guainfo[1][0] % 8
            let l:gua02 = l:guainfo[2][0] % 8
            let l:gua03 = l:guainfo[3][0] % 8
            let l:gua04 = l:guainfo[4][0] % 8
            let l:gua05 = l:guainfo[5][0] % 8
            let l:imin = 0
            let l:imax = l:yaolen / 2 - 1
        else
            " 下卦
            let l:gua00 = l:guainfo[0][0] / 8
            let l:gua01 = l:guainfo[1][0] / 8
            let l:gua02 = l:guainfo[2][0] / 8
            let l:gua03 = l:guainfo[3][0] / 8
            let l:gua04 = l:guainfo[4][0] / 8
            let l:gua05 = l:guainfo[5][0] / 8
            let l:imin = l:yaolen / 2
            let l:imax = l:yaolen - 1
        endif
        let l:gua0 = l:gua00
        let l:gua1 = l:gua01
        let l:gua2 = l:gua02
        let l:gua3 = l:gua03
        let l:gua4 = l:gua04
        let l:gua5 = l:gua05
        for l:i in range(l:imin, l:imax)
            " 六神
            let l:yaostr[i] = l:yaostr[i] . s:txtLS[CalModulo(l:day + l:yaolen - l:i - 1, l:yaolen)]
            " 宫卦
            let l:yaog  = CalModulo(s:baseGZ[l:gua00][l:i] - 1, 10)
            let l:yaoz  = CalModulo(s:baseGZ[l:gua00][l:i] - 1, 12)
            let l:yaolq = CalModulo(l:basewx - CalWxDZ(l:yaoz + 1), l:wxlen)
            call add(l:lq0[l:yaolq], l:i)
            let l:gongpos1 = strlen(l:yaostr[i])
            let l:yaostr[i] = l:yaostr[i] . '  '
            let l:guacol[0] = strwidth(l:yaostr[i])
            let l:yaostr[i] = l:yaostr[i] . s:txtYao[l:gua0 % 2] . CalTextDZ(l:yaoz + 1) . s:txtLQ[l:yaolq]
            let l:gongpos2 = strlen(l:yaostr[i])
            " 正卦
            let l:yaog  = CalModulo(s:baseGZ[l:gua01][l:i] - 1, 10)
            let l:yaoz  = CalModulo(s:baseGZ[l:gua01][l:i] - 1, 12)
            let l:yaolq = CalModulo(l:basewx - CalWxDZ(l:yaoz + 1), l:wxlen)
            let l:lq1[l:yaolq] = 1
            if l:yaolen - l:i == l:guainfo[1][2]
                let l:txtsy = s:txtGua[l:guainfo[1][1]] " 世
            elseif (l:yaolen - l:i == l:guainfo[1][2] + 3) || (l:yaolen - l:i == l:guainfo[1][2] - 3)
                let l:txtsy = s:txtExtra[1] " 应
            else
                let l:txtsy = repeat(' ', strwidth(s:txtExtra[1]))
            endif
            let l:yaostr[i] = l:yaostr[i] . '  '
            let l:guacol[1] = strwidth(l:yaostr[i])
            let l:yaostr[i] = l:yaostr[i] . s:txtYao[l:gua1 % 2] . l:txtsy . CalTextDZ(l:yaoz + 1) . s:txtLQ[l:yaolq]
            " 互卦
            if g:ly_paipan_mode == 1
                let l:txtsy = ''
                let l:yaog  = CalModulo(s:baseGZ[l:gua02][l:i] - 1, 10)
                let l:yaoz  = CalModulo(s:baseGZ[l:gua02][l:i] - 1, 12)
                let l:yaolq = CalModulo(l:basewx - CalWxDZ(l:yaoz + 1), l:wxlen)
                let l:yaostr[i] = l:yaostr[i] . '  '
                let l:guacol[2] = strwidth(l:yaostr[i])
                let l:yaostr[i] = l:yaostr[i] . s:txtYao[l:gua2 % 2] . l:txtsy . CalTextDZ(l:yaoz + 1) . s:txtLQ[l:yaolq]
            endif
            " 变卦
            if (g:ly_paipan_mode == 1) || ((g:ly_paipan_mode == 0) && ((g:ly_visible_all == 1) || (l:gua3 % 2 != l:gua1 % 2)))
                " 变爻
                if l:yaolen - l:i == l:guainfo[3][2]
                    let l:txtsy = s:txtGua[l:guainfo[3][1]] " 世
                elseif (l:yaolen - l:i == l:guainfo[3][2] + 3) || (l:yaolen - l:i == l:guainfo[3][2] - 3)
                    let l:txtsy = s:txtExtra[1] " 应
                else
                    let l:txtsy = repeat(' ', strwidth(s:txtExtra[1]))
                endif
                if l:gua3 % 2 != l:gua1 % 2
                    let l:txtdj = s:txtExtra[2]
                else
                    let l:txtdj = repeat(' ', strwidth(s:txtExtra[2]))
                endif
                let l:yaog  = CalModulo(s:baseGZ[l:gua03][l:i] - 1, 10)
                let l:yaoz  = CalModulo(s:baseGZ[l:gua03][l:i] - 1, 12)
                let l:yaolq = CalModulo(l:basewx - CalWxDZ(l:yaoz + 1), l:wxlen)
                let l:lq1[l:yaolq] = 1
                let l:yaostr[i] = l:yaostr[i] . '  ' . l:txtdj
                let l:guacol[3] = strwidth(l:yaostr[i])
                let l:yaostr[i] = l:yaostr[i] . s:txtYao[l:gua3 % 2] . l:txtsy . CalTextDZ(l:yaoz + 1) . s:txtLQ[l:yaolq]
            endif
            " 错卦
            if g:ly_paipan_mode == 1
                let l:txtsy = ''
                let l:yaog  = CalModulo(s:baseGZ[l:gua04][l:i] - 1, 10)
                let l:yaoz  = CalModulo(s:baseGZ[l:gua04][l:i] - 1, 12)
                let l:yaolq = CalModulo(l:basewx - CalWxDZ(l:yaoz + 1), l:wxlen)
                let l:yaostr[i] = l:yaostr[i] . '  '
                let l:guacol[4] = strwidth(l:yaostr[i])
                let l:yaostr[i] = l:yaostr[i] . s:txtYao[l:gua4 % 2] . l:txtsy . CalTextDZ(l:yaoz + 1) . s:txtLQ[l:yaolq]
            endif
            " 综卦
            if g:ly_paipan_mode == 1
                let l:txtsy = ''
                let l:yaog  = CalModulo(s:baseGZ[l:gua05][l:i] - 1, 10)
                let l:yaoz  = CalModulo(s:baseGZ[l:gua05][l:i] - 1, 12)
                let l:yaolq = CalModulo(l:basewx - CalWxDZ(l:yaoz + 1), l:wxlen)
                let l:yaostr[i] = l:yaostr[i] . '  '
                let l:guacol[5] = strwidth(l:yaostr[i])
                let l:yaostr[i] = l:yaostr[i] . s:txtYao[l:gua5 % 2] . l:txtsy . CalTextDZ(l:yaoz + 1) . s:txtLQ[l:yaolq]
            endif
            let l:gua0 = l:gua0 / 2
            let l:gua1 = l:gua1 / 2
            let l:gua2 = l:gua2 / 2
            let l:gua3 = l:gua3 / 2
            let l:gua4 = l:gua4 / 2
            let l:gua5 = l:gua5 / 2
        endfor
    endfor
    " 添加卦类型
    let l:yaostr[l:yaolen] = repeat(' ', max(l:guacol))
    let l:widthdiff = 0
    for l:i in range(l:typelen)
        if l:guacol[l:i] > 0
            let l:tmptxt = s:txtGuaType[l:i]
            if l:guainfo[l:i][0] % 9 == 0
                let l:tmptxt = l:tmptxt . s:txtGuaXiang[l:guainfo[l:i][0] / 8] . s:txtExtra[4] . s:txt64Gua[l:guainfo[l:i][0]]
            else
                let l:tmptxt = l:tmptxt . s:txtGuaXiang[l:guainfo[l:i][0] % 8] . s:txtGuaXiang[l:guainfo[l:i][0] / 8] . s:txt64Gua[l:guainfo[l:i][0]]
            endif
            " l:guacol由列数转变为字节数
            let l:guacol[l:i] = l:guacol[l:i] + l:widthdiff
            let l:yaostr[l:yaolen] = strpart(l:yaostr[l:yaolen], 0, l:guacol[l:i]) . l:tmptxt . strpart(l:yaostr[l:yaolen], l:guacol[l:i] + strwidth(l:tmptxt))
            let l:widthdiff = l:widthdiff + strlen(l:tmptxt) - strwidth(l:tmptxt)
        endif
    endfor
    " 添加伏神标记
    if index(l:lq1, 0) >= 0
        for l:j in range(l:wxlen)
            if l:lq1[l:j] > 0
                for l:i in l:lq0[l:j]
                    let l:yaostr[l:i] = strpart(l:yaostr[l:i], 0, l:gongpos2) . repeat(' ', strwidth(s:txtExtra[3])) . strpart(l:yaostr[l:i], l:gongpos2)
                endfor
            else
                for l:i in l:lq0[l:j]
                    let l:yaostr[l:i] = strpart(l:yaostr[l:i], 0, l:gongpos2) . s:txtExtra[3] . strpart(l:yaostr[l:i], l:gongpos2)
                endfor
            endif
        endfor
        let l:yaostr[l:yaolen] = strpart(l:yaostr[l:yaolen], 0, l:gongpos2) . repeat(' ', strwidth(s:txtExtra[3])) . strpart(l:yaostr[l:yaolen], l:gongpos2)
        let l:gongpos2 = l:gongpos2 + strlen(s:txtExtra[3])
    endif
    " 删除无用宫卦
    if (g:ly_paipan_mode == 0) && (g:ly_visible_all != 1)
        if index(l:lq1, 0) < 0
            " 无伏神
            for l:i in range(l:yaolen)
                let l:yaostr[l:i] = strpart(l:yaostr[l:i], 0, l:gongpos1) . strpart(l:yaostr[l:i], l:gongpos2)
            endfor
            let l:yaostr[l:yaolen] = strpart(l:yaostr[l:yaolen], 0, l:guacol[0]) . strpart(l:yaostr[l:yaolen], l:guacol[1])
        else
            for l:j in range(l:wxlen)
                if l:lq1[l:j] > 0
                    for l:i in l:lq0[l:j]
                        let l:yaostr[l:i] = strpart(l:yaostr[l:i], 0, l:gongpos1) . repeat(' ', strwidth(strpart(l:yaostr[l:i], l:gongpos1, l:gongpos2 - l:gongpos1))) . strpart(l:yaostr[l:i], l:gongpos2)
                    endfor
                endif
            endfor
        endif
    endif
    return l:yaostr
endfunction
function! s:calcGua(coinstr)
    " @retval [gua1 gua2]
    let l:method = strpart(a:coinstr, 0, 2)
    let l:gua1 = -1
    let l:gua2 = -1
    if l:method == 'CH'
        let l:gua1 = 0
        let l:gua2 = 0
        for l:i in range(len(s:txtLS))
            let l:highest = 3 - CalModulo(str2nr(a:coinstr[l:i + 3]), 4)
            let l:gua1    = l:gua1 * 2 + CalModulo(l:highest, 2)
            if l:highest / 2 == CalModulo(l:highest, 2)
                let l:gua2    = l:gua2 * 2 + 1 - CalModulo(l:highest, 2)
            else
                let l:gua2    = l:gua2 * 2 + CalModulo(l:highest, 2)
            endif
        endfor
    elseif l:method == 'CT'
        let l:gua1 = 0
        let l:gua2 = 0
        for l:i in range(len(s:txtLS))
            let l:highest = CalModulo(str2nr(a:coinstr[l:i + 3]), 4)
            let l:gua1    = l:gua1 * 2 + CalModulo(l:highest, 2)
            if l:highest / 2 == CalModulo(l:highest, 2)
                let l:gua2    = l:gua2 * 2 + 1 - CalModulo(l:highest, 2)
            else
                let l:gua2    = l:gua2 * 2 + CalModulo(l:highest, 2)
            endif
        endfor
    elseif l:method == 'GC'
        let l:gua1 = len(s:txtGua) - CalModulo(str2nr(a:coinstr[3]) - 1, 8) - 1
        let l:gua2 = len(s:txtGua) - CalModulo(str2nr(a:coinstr[4]) - 1, 8) - 1
        let l:gua1 = l:gua2 * 8 + l:gua1
        let l:gua2 = l:gua1
        let l:bits = [32, 16, 8, 4, 2, 1]
        for l:i in range(5, len(a:coinstr) - 1)
            let l:pos = CalModulo(str2nr(a:coinstr[l:i]) - 1, 6)
            let l:gua2 = xor(l:gua2, l:bits[l:pos])
        endfor
    elseif l:method == 'TN'
        let l:parts  = map(split(strpart(a:coinstr, 3), ','), 'str2nr(v:val)')
        let l:gua1 = len(s:txtGua) - CalModulo(l:parts[0] - 1, 8) - 1
        let l:gua2 = len(s:txtGua) - CalModulo(l:parts[1] - 1, 8) - 1
        let l:gua1 = l:gua2 * 8 + l:gua1
        let l:gua2 = l:gua1
        let l:bits = [32, 16, 8, 4, 2, 1]
        let l:pos = CalModulo(l:parts[2] - 1, 6)
        let l:gua2 = xor(l:gua2, l:bits[l:pos])
    endif
    return [l:gua1, l:gua2]
endfunction
function! s:calcBase(gua)
    " @retval [gua0 shiyao]
    let l:base = CalModulo(a:gua, 64)
    let l:bit  = [0, 32, 16, 8, 4, 2, 4, 56]
    let l:pos  = [6,  1,  2, 3, 4, 5, 4,  3]
    let l:i    = 0
    while l:i < len(l:bit)
        let l:base = xor(l:base, l:bit[l:i])
        if CalModulo(l:base, 9) == 0
            break
        endif
        let l:i = l:i + 1
    endwhile
    return [l:base, l:pos[l:i]]
endfunction
function! s:findFile()
    let l:path = globpath(&rtp, 'plugin/LiuYao.py')
    return l:path
endfunction
