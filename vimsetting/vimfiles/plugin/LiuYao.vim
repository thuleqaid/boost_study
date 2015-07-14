let g:ly_paipan_mode = get(g:, 'ly_paipan_mode', 0) " 0:六爻, 1:梅花
let g:ly_visible_all = get(g:, 'ly_visible_all', 0) " 只用于六爻排盘方式 0:只显示宫卦中的伏神和变卦中的动爻, 1:显示宫卦和变卦中所有的爻
let s:paipanmethod = ['LiuYao', 'MeiHua']
let s:setupmethod = ['Coin Head', 'Coin Tail', 'Gua Code', 'Three Numbers']
let s:setupexample = ['CH:000000', 'CT:000000', 'GC:11123456', 'TN:111,222,333']
"let s:txtTG = ['甲',           '乙',           '丙',           '丁',           '戊',           '己',           '庚',           '辛',           '壬',           '癸']
let s:txtTG = [nr2char(48343), nr2char(53970), nr2char(45563), nr2char(46753), nr2char(52972), nr2char(48314), nr2char(47357), nr2char(53441), nr2char(51401), nr2char(47599)]
"let s:txtDZ = ['子',           '丑',           '寅',           '卯',           '辰',           '巳',           '午',           '未',           '申',           '酉',           '戌',           '亥']
let s:txtDZ = [nr2char(55251), nr2char(46067), nr2char(54010), nr2char(50094), nr2char(46013), nr2char(52168), nr2char(52967), nr2char(52916), nr2char(51690), nr2char(54223), nr2char(53479), nr2char(47781)]
"let s:txtYao = ['━━  ━━', '━━━━━']
let s:txtYao = [repeat(nr2char(43429), 2) . '  ' . repeat(nr2char(43429), 2), repeat(nr2char(43429), 5)]
"let s:txtLS = ['青龙',                          '朱雀',                          '勾陈',                          '滕蛇',                          '白虎',                          '玄武']
let s:txtLS = [nr2char(51168) . nr2char(49658), nr2char(55020) . nr2char(51384), nr2char(47540) . nr2char(46018), nr2char(60408) . nr2char(51679), nr2char(45271) . nr2char(48034), nr2char(53502) . nr2char(52964)]
"let s:txtLQ = ['兄',           '父',           '官',           '财',           '孙']
let s:txtLQ = [nr2char(53462), nr2char(47288), nr2char(47577), nr2char(45766), nr2char(52207)]
"let s:txtGua = ['坤',           '艮',           '坎',           '巽',           '震',           '离',           '兑',           '乾']
let s:txtGua = [nr2char(49316), nr2char(62686), nr2char(49074), nr2char(55779), nr2char(54768), nr2char(49387), nr2char(46802), nr2char(51116)]
"let s:txtGuaType = ['宫',           '正',           '互',           '变',           '错',           '综']
let s:txtGuaType = [nr2char(47532), nr2char(54781), nr2char(48037), nr2char(45540), nr2char(46317), nr2char(55259)]
"let s:txtExtra = ['年',           '月',           '日',           '时',           '空',           '世',           '应',           '动',           '伏']
let s:txtExtra = [nr2char(50410), nr2char(54466), nr2char(51413), nr2char(51889), nr2char(49109), nr2char(51904), nr2char(54182), nr2char(46767), nr2char(47100)]
let s:wxGua = [3, 3, 0, 1, 1, 2, 4, 4] " 土，土，水，木，木，火，金，金
let s:wxDZ  = [0, 3, 1, 1, 3, 2, 2, 3, 4, 4, 3, 0]
let s:baseGZ = [[10, 12,  2,  4,  6,  8],
              \ [ 3,  1, 11,  9,  7,  5],
              \ [ 1, 11,  9,  7,  5,  3],
              \ [ 4,  6,  8, 10, 12,  2],
              \ [11,  9,  7,  5,  3,  1],
              \ [ 6,  8, 10, 12,  2,  4],
              \ [ 8, 10, 12,  2,  4,  6],
              \ [11,  9,  7,  5,  3,  1]]
let s:ChineseSolarDB = { '2015' : ['0105000000','0120000000','0205000000','0220000000','0305000000','0320000000','0405000000','0420000000','0505000000','0520000000','0605000000','0620000000','0705000000','0720000000','0805000000','0820000000','0905000000','0920000000','1005000000','1020000000','1105000000','1120000000','1205000000','1220000000'],
                       \ '2016' : ['0105000000','0120000000','0205000000','0220000000','0305000000','0320000000','0405000000','0420000000','0505000000','0520000000','0605000000','0620000000','0705000000','0720000000','0805000000','0820000000','0905000000','0920000000','1005000000','1020000000','1105000000','1120000000','1205000000','1220000000']}
" define command
command! -n=0 -bar LYNew :call s:InsertDateTime()
command! -n=0 -bar LYParse :call s:ParseDateTime()
command! -n=0 -bar LYSet :call s:SetPaiPanMode()
"" key-binding
"nmap <Leader>yi :LiuYaoInsertDateTime<CR>
"nmap <Leader>yp :LiuYaoParseDateTime<CR>

function! s:SetPaiPanMode()
    let l:mode = s:ListAndSelect('PaiPan Mode List:', s:paipanmethod, g:ly_paipan_mode)
    if l:mode >= 0
        let g:ly_paipan_mode = l:mode
    endif
endfunction
function! s:InsertDateTime()
    let l:curdt = strftime("%Y-%m-%d %H:%M:%S")
    let l:method = s:ListAndSelect('Method List:', s:setupmethod, -1)
    if l:method >= 0
        let l:coins = s:setupexample[l:method]
        if len(getline('.')) > 0
            call append(line('.'), l:curdt . ' ' . l:coins)
        else
            call setline(line('.'), l:curdt . ' ' . l:coins)
        endif
    endif
endfunction
function! s:ParseDateTime()
    let l:curlineno = line('.')
    let l:parts  = split(getline(l:curlineno), '[ \t]\+')
    let l:datetime  = map(split(l:parts[0] . ' ' . l:parts[1], '[ \t:-]\+'), 'str2nr(v:val)')
    let l:datenew = s:calcChineseSolarDT(l:datetime)
    let l:datestr = s:calcDateStr(l:datenew)
    let l:guas = s:calcGua(l:parts[2])
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
function! s:myModulo(a, b)
    " @retval 0 ~ (b-1)
    return (a:a % a:b + a:b) % a:b
endfunction
function! s:calcDateStr(datetime)
    let l:year  = a:datetime[0]
    let l:month = a:datetime[1]
    let l:day   = a:datetime[2]
    let l:hour  = a:datetime[3]
    let l:empty = ((l:day + 9) / 10) * 10 + 1
    let l:rettxt = ''
    let l:rettxt = l:rettxt . s:txtTG[s:myModulo(l:year  - 1, 10)] . s:txtDZ[s:myModulo(l:year  - 1, 12)] . s:txtExtra[0] . ' ' " 年
    let l:rettxt = l:rettxt . s:txtTG[s:myModulo(l:month - 1, 10)] . s:txtDZ[s:myModulo(l:month - 1, 12)] . s:txtExtra[1] . ' ' " 月
    let l:rettxt = l:rettxt . s:txtTG[s:myModulo(l:day   - 1, 10)] . s:txtDZ[s:myModulo(l:day   - 1, 12)] . s:txtExtra[2] . ' ' " 日
    let l:rettxt = l:rettxt . s:txtTG[s:myModulo(l:hour  - 1, 10)] . s:txtDZ[s:myModulo(l:hour  - 1, 12)] . s:txtExtra[3] . '  ' . s:txtExtra[4] " 时  空
    let l:rettxt = l:rettxt . s:txtDZ[s:myModulo(l:empty - 1, 12)] . s:txtDZ[s:myModulo(l:empty,     12)]
    if (len(a:datetime) > 4) && (a:datetime[4] <= 0)
        let l:rettxt = l:rettxt . '  N/F'
    endif
    return l:rettxt
endfunction
function! s:calcChineseSolarDT(datetime)
    let l:terminfo = s:calcTermIndex(a:datetime)
    let l:termidx = l:terminfo[0]
    if l:termidx < 0
        let l:year = s:myModulo(a:datetime[0] - 1 - 1984, 60) + 1
        let l:month = (l:termidx - 1) / 2 + 2
    else
        let l:year = s:myModulo(a:datetime[0] - 1984, 60) + 1
        let l:month = l:termidx / 2 + 2
    endif
    let l:month = s:myModulo(l:month + s:myModulo(l:year - 1, 5) * 12, 60) + 1
    let l:day = (a:datetime[0] - 1984) * 5 + (a:datetime[0] - 1984 + 3) / 4 + 29 + s:calcDays(a:datetime[0], a:datetime[1], a:datetime[2])
    if a:datetime[3] >= 23
        let l:day = l:day + 1
        let l:hour = 1
    else
        let l:hour = (a:datetime[3] + 1) / 2 + 1
    endif
    let l:day = s:myModulo(l:day, 60) + 1
    let l:hour = s:myModulo(l:hour + s:myModulo(l:day - 1, 5) * 12 - 1, 60) + 1
    return [l:year, l:month, l:day, l:hour, l:terminfo[1]]
endfunction
function! s:calcTermIndex(datetime)
    " @retval -3~-1:winter 0~5:spring  6~11:summer  12~17:autumn 18~21:winter
    let l:yearstr = printf("%04d", a:datetime[0])
    let l:indb = 1
    if has_key(s:ChineseSolarDB, l:yearstr)
        let l:timestr = printf("%02d%02d%02d%02d%02d", a:datetime[1], a:datetime[2], a:datetime[3], a:datetime[4], a:datetime[5])
        let l:i = len(s:ChineseSolarDB[l:yearstr]) - 1
        while l:i >= 0
            if s:ChineseSolarDB[l:yearstr][l:i] <= l:timestr
                break
            endif
            let l:i = l:i - 1
        endwhile
        let l:idx = l:i - 2
    else
        let l:idx = a:datetime[1] * 2 - 4
        if a:datetime[2] <= 6
            let l:idx = l:idx - 1
        elseif a:datetime[2] >=21
            let l:idx = l:idx + 1
        endif
        let l:indb = 0
    endif
    return [l:idx, l:indb]
endfunction
function! s:calcDays(year, month, day)
    " @retval 1 ~ 366
    let l:daystable = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30]
    let l:i = 1
    let l:days = a:day
    while l:i < a:month
        let l:days = l:days + l:daystable[l:i - 1]
        let l:i = l:i + 1
    endwhile
    " leap year
    if a:month > 2
        if (a:year % 400 == 0) || ((a:year % 100 != 0) && (a:year % 4 == 0))
            let l:days = l:days + 1
        endif
    endif
    return l:days
endfunction
function! s:calcGuaStr(guas, day)
    let l:yaolen  = len(s:txtLS)
    let l:wxlen   = len(s:txtLQ)
    let l:typelen = len(s:txtGuaType)
    let l:yaostr  = repeat(['',], l:yaolen + 1)
    let l:day     = s:myModulo(a:day - 1, 10)
    let l:guacol  = repeat([0,], l:typelen)
    " 变卦
    let l:base    = s:calcBase(a:guas[1])
    let l:base2   = l:base[0] % 8
    let l:pos2    = l:base[1]
    " 互卦
    let l:guahu   = and(a:guas[0], 14) / 2 + and(a:guas[0], 28) * 2
    let l:base    = s:calcBase(l:guahu)
    let l:base3   = l:base[0] % 8
    let l:pos3    = l:base[1]
    " 错卦
    let l:guacuo  = xor(a:guas[0], 63)
    let l:base    = s:calcBase(l:guacuo)
    let l:base4   = l:base[0] % 8
    let l:pos4    = l:base[1]
    " 综卦
    let l:guazong = and(a:guas[0], 1) * 32 + and(a:guas[0], 2) * 8 + and(a:guas[0], 4) * 2 + and(a:guas[0], 8) / 2 + and(a:guas[0], 16) / 8 + and(a:guas[0], 32) / 32
    let l:base    = s:calcBase(l:guazong)
    let l:base5   = l:base[0] % 8
    let l:pos5    = l:base[1]
    " 正卦
    let l:base    = s:calcBase(a:guas[0])
    let l:pos1    = l:base[1]
    let l:basewx  = s:wxGua[l:base[0] % 8]
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
            let l:gua00 = l:base[0] % 8
            let l:gua01 = a:guas[0] % 8
            let l:gua02 = a:guas[1] % 8
            let l:gua03 = l:guahu % 8
            let l:gua04 = l:guacuo % 8
            let l:gua05 = l:guazong % 8
            let l:imin = 0
            let l:imax = l:yaolen / 2 - 1
        else
            " 下卦
            let l:gua00 = l:base[0] / 8
            let l:gua01 = a:guas[0] / 8
            let l:gua02 = a:guas[1] / 8
            let l:gua03 = l:guahu / 8
            let l:gua04 = l:guacuo / 8
            let l:gua05 = l:guazong / 8
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
            let l:yaostr[i] = l:yaostr[i] . s:txtLS[s:myModulo(l:day + l:yaolen - l:i - 1, l:yaolen)]
            " 宫卦
            let l:yaog  = s:myModulo(s:baseGZ[l:gua00][l:i] - 1, 10)
            let l:yaoz  = s:myModulo(s:baseGZ[l:gua00][l:i] - 1, 12)
            let l:yaolq = s:myModulo(l:basewx - s:wxDZ[l:yaoz], l:wxlen)
            call add(l:lq0[l:yaolq], l:i)
            let l:gongpos1 = strlen(l:yaostr[i])
            let l:yaostr[i] = l:yaostr[i] . '  '
            let l:guacol[0] = strlen(l:yaostr[i])
            let l:yaostr[i] = l:yaostr[i] . s:txtYao[l:gua0 % 2] . s:txtDZ[l:yaoz] . s:txtLQ[l:yaolq]
            let l:gongpos2 = strlen(l:yaostr[i])
            " 正卦
            let l:yaog  = s:myModulo(s:baseGZ[l:gua01][l:i] - 1, 10)
            let l:yaoz  = s:myModulo(s:baseGZ[l:gua01][l:i] - 1, 12)
            let l:yaolq = s:myModulo(l:basewx - s:wxDZ[l:yaoz], l:wxlen)
            let l:lq1[l:yaolq] = 1
            if l:yaolen - l:i == l:pos1
                let l:txtsy = s:txtGua[l:gua00] " 世
            elseif (l:yaolen - l:i == l:pos1 + 3) || (l:yaolen - l:i == l:pos1 - 3)
                let l:txtsy = s:txtExtra[6] " 应
            else
                let l:txtsy = '  '
            endif
            let l:yaostr[i] = l:yaostr[i] . '  '
            let l:guacol[1] = strlen(l:yaostr[i])
            let l:yaostr[i] = l:yaostr[i] . s:txtYao[l:gua1 % 2] . l:txtsy . s:txtDZ[l:yaoz] . s:txtLQ[l:yaolq]
            " 互卦
            if g:ly_paipan_mode == 1
                "if l:yaolen - l:i == l:pos3
                    "let l:txtsy = s:txtGua[l:base3] " 世
                "elseif (l:yaolen - l:i == l:pos3 + 3) || (l:yaolen - l:i == l:pos3 - 3)
                    "let l:txtsy = s:txtExtra[6] " 应
                "else
                    "let l:txtsy = '  '
                "endif
                let l:txtsy = ''
                let l:yaog  = s:myModulo(s:baseGZ[l:gua03][l:i] - 1, 10)
                let l:yaoz  = s:myModulo(s:baseGZ[l:gua03][l:i] - 1, 12)
                let l:yaolq = s:myModulo(l:basewx - s:wxDZ[l:yaoz], l:wxlen)
                let l:yaostr[i] = l:yaostr[i] . '  '
                let l:guacol[2] = strlen(l:yaostr[i])
                let l:yaostr[i] = l:yaostr[i] . s:txtYao[l:gua3 % 2] . l:txtsy . s:txtDZ[l:yaoz] . s:txtLQ[l:yaolq]
            endif
            " 变卦
            if (g:ly_paipan_mode == 1) || ((g:ly_paipan_mode == 0) && ((g:ly_visible_all == 1) || (l:gua2 % 2 != l:gua1 % 2)))
                " 变爻
                if l:yaolen - l:i == l:pos2
                    let l:txtsy = s:txtGua[l:base2] " 世
                elseif (l:yaolen - l:i == l:pos2 + 3) || (l:yaolen - l:i == l:pos2 - 3)
                    let l:txtsy = s:txtExtra[6] " 应
                else
                    let l:txtsy = '  '
                endif
                if l:gua2 % 2 != l:gua1 % 2
                    let l:txtdj = s:txtExtra[7]
                else
                    let l:txtdj = '  '
                endif
                let l:yaog  = s:myModulo(s:baseGZ[l:gua02][l:i] - 1, 10)
                let l:yaoz  = s:myModulo(s:baseGZ[l:gua02][l:i] - 1, 12)
                let l:yaolq = s:myModulo(l:basewx - s:wxDZ[l:yaoz], l:wxlen)
                let l:lq1[l:yaolq] = 1
                let l:yaostr[i] = l:yaostr[i] . '  ' . l:txtdj
                let l:guacol[3] = strlen(l:yaostr[i])
                let l:yaostr[i] = l:yaostr[i] . s:txtYao[l:gua2 % 2] . l:txtsy . s:txtDZ[l:yaoz] . s:txtLQ[l:yaolq]
            endif
            " 错卦
            if g:ly_paipan_mode == 1
                "if l:yaolen - l:i == l:pos4
                    "let l:txtsy = s:txtGua[l:base4] " 世
                "elseif (l:yaolen - l:i == l:pos4 + 3) || (l:yaolen - l:i == l:pos4 - 3)
                    "let l:txtsy = s:txtExtra[6] " 应
                "else
                    "let l:txtsy = '  '
                "endif
                let l:txtsy = ''
                let l:yaog  = s:myModulo(s:baseGZ[l:gua04][l:i] - 1, 10)
                let l:yaoz  = s:myModulo(s:baseGZ[l:gua04][l:i] - 1, 12)
                let l:yaolq = s:myModulo(l:basewx - s:wxDZ[l:yaoz], l:wxlen)
                let l:yaostr[i] = l:yaostr[i] . '  '
                let l:guacol[4] = strlen(l:yaostr[i])
                let l:yaostr[i] = l:yaostr[i] . s:txtYao[l:gua4 % 2] . l:txtsy . s:txtDZ[l:yaoz] . s:txtLQ[l:yaolq]
            endif
            " 综卦
            if g:ly_paipan_mode == 1
                "if l:yaolen - l:i == l:pos5
                    "let l:txtsy = s:txtGua[l:base5] " 世
                "elseif (l:yaolen - l:i == l:pos5 + 3) || (l:yaolen - l:i == l:pos5 - 3)
                    "let l:txtsy = s:txtExtra[6] " 应
                "else
                    "let l:txtsy = '  '
                "endif
                let l:txtsy = ''
                let l:yaog  = s:myModulo(s:baseGZ[l:gua05][l:i] - 1, 10)
                let l:yaoz  = s:myModulo(s:baseGZ[l:gua05][l:i] - 1, 12)
                let l:yaolq = s:myModulo(l:basewx - s:wxDZ[l:yaoz], l:wxlen)
                let l:yaostr[i] = l:yaostr[i] . '  '
                let l:guacol[5] = strlen(l:yaostr[i])
                let l:yaostr[i] = l:yaostr[i] . s:txtYao[l:gua5 % 2] . l:txtsy . s:txtDZ[l:yaoz] . s:txtLQ[l:yaolq]
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
    for l:i in range(l:typelen)
        if l:guacol[l:i] > 0
            let l:tmptxt = s:txtGuaType[l:i]
            let l:yaostr[l:yaolen] = strpart(l:yaostr[l:yaolen], 0, l:guacol[l:i]) . l:tmptxt . strpart(l:yaostr[l:yaolen], l:guacol[l:i] + len(l:tmptxt))
        endif
    endfor
    " 添加伏神标记
    if index(l:lq1, 0) >= 0
        for l:j in range(l:wxlen)
            if l:lq1[l:j] > 0
                for l:i in l:lq0[l:j]
                    let l:yaostr[l:i] = strpart(l:yaostr[l:i], 0, l:gongpos2) . '  ' . strpart(l:yaostr[l:i], l:gongpos2)
                endfor
            else
                for l:i in l:lq0[l:j]
                    let l:yaostr[l:i] = strpart(l:yaostr[l:i], 0, l:gongpos2) . s:txtExtra[8] . strpart(l:yaostr[l:i], l:gongpos2)
                endfor
            endif
        endfor
        let l:yaostr[l:yaolen] = strpart(l:yaostr[l:yaolen], 0, l:gongpos2) . '  ' . strpart(l:yaostr[l:yaolen], l:gongpos2)
        let l:gongpos2 = l:gongpos2 + 2
        let l:guacol[1] = l:guacol[1] + 2
        let l:guacol[2] = l:guacol[2] + 2
        let l:guacol[3] = l:guacol[3] + 2
        let l:guacol[4] = l:guacol[4] + 2
    endif
    " 删除无用宫卦
    if (g:ly_paipan_mode == 0) && (g:ly_visible_all != 1)
        if index(l:lq1, 0) < 0
            " 无伏神
            for l:i in range(l:yaolen + 1)
                let l:yaostr[l:i] = strpart(l:yaostr[l:i], 0, l:gongpos1) . strpart(l:yaostr[l:i], l:gongpos2)
            endfor
        else
            for l:j in range(l:wxlen)
                if l:lq1[l:j] > 0
                    for l:i in l:lq0[l:j]
                        let l:yaostr[l:i] = strpart(l:yaostr[l:i], 0, l:gongpos1) . repeat(' ', l:gongpos2 - l:gongpos1) . strpart(l:yaostr[l:i], l:gongpos2)
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
            let l:highest = 3 - s:myModulo(str2nr(a:coinstr[l:i + 3]), 4)
            let l:gua1    = l:gua1 * 2 + s:myModulo(l:highest, 2)
            if l:highest / 2 == s:myModulo(l:highest, 2)
                let l:gua2    = l:gua2 * 2 + 1 - s:myModulo(l:highest, 2)
            else
                let l:gua2    = l:gua2 * 2 + s:myModulo(l:highest, 2)
            endif
        endfor
    elseif l:method == 'CT'
        let l:gua1 = 0
        let l:gua2 = 0
        for l:i in range(len(s:txtLS))
            let l:highest = s:myModulo(str2nr(a:coinstr[l:i + 3]), 4)
            let l:gua1    = l:gua1 * 2 + s:myModulo(l:highest, 2)
            if l:highest / 2 == s:myModulo(l:highest, 2)
                let l:gua2    = l:gua2 * 2 + 1 - s:myModulo(l:highest, 2)
            else
                let l:gua2    = l:gua2 * 2 + s:myModulo(l:highest, 2)
            endif
        endfor
    elseif l:method == 'GC'
        let l:gua1 = len(s:txtGua) - s:myModulo(str2nr(a:coinstr[3]) - 1, 8) - 1
        let l:gua2 = len(s:txtGua) - s:myModulo(str2nr(a:coinstr[4]) - 1, 8) - 1
        let l:gua1 = l:gua2 * 8 + l:gua1
        let l:gua2 = l:gua1
        let l:bits = [32, 16, 8, 4, 2, 1]
        for l:i in range(5, len(a:coinstr) - 1)
            let l:pos = s:myModulo(str2nr(a:coinstr[l:i]) - 1, 6)
            let l:gua2 = xor(l:gua2, l:bits[l:pos])
        endfor
    elseif l:method == 'TN'
        let l:parts  = map(split(strpart(a:coinstr, 3), ','), 'str2nr(v:val)')
        let l:gua1 = len(s:txtGua) - s:myModulo(l:parts[0] - 1, 8) - 1
        let l:gua2 = len(s:txtGua) - s:myModulo(l:parts[1] - 1, 8) - 1
        let l:gua1 = l:gua2 * 8 + l:gua1
        let l:gua2 = l:gua1
        let l:bits = [32, 16, 8, 4, 2, 1]
        let l:pos = s:myModulo(l:parts[2] - 1, 6)
        let l:gua2 = xor(l:gua2, l:bits[l:pos])
    endif
    return [l:gua1, l:gua2]
endfunction
function! s:calcBase(gua)
    " @retval [gua0 shiyao]
    let l:base = s:myModulo(a:gua, 64)
    let l:bit  = [0, 32, 16, 8, 4, 2, 4, 56]
    let l:pos  = [6,  1,  2, 3, 4, 5, 4,  3]
    let l:i    = 0
    while l:i < len(l:bit)
        let l:base = xor(l:base, l:bit[l:i])
        if s:myModulo(l:base, 9) == 0
            break
        endif
        let l:i = l:i + 1
    endwhile
    return [l:base, l:pos[l:i]]
endfunction
function! s:ListAndSelect(title, itemlist, markindex)
    let l:choices = copy(a:itemlist)
    " generate choice-list
    call map(l:choices, '"  " . (v:key + 1) . ". " . v:val')
    " insert '*' at the start of selected item
    if (a:markindex >= 0) && (a:markindex < len(a:itemlist))
        let l:choices[a:markindex] = '*' . l:choices[a:markindex][1:]
    endif
    " set list title
    call insert(l:choices, a:title)
    " ask for user choice
    let l:choice = inputlist(l:choices)
    if (l:choice < 1) || (l:choice > len(a:itemlist))
        let l:choice = 0
    endif
    return l:choice - 1
endfunction
