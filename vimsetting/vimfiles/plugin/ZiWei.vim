" define command
command! -n=0 -bar ZwNew :call s:ZiWeiNew()
command! -n=0 -bar ZwPan :call s:ZiWeiPaiPan()

let s:cellMinWidth  = 10
let s:cellMinHeight = 8
let s:cellCount     = 12
let g:ZiWei_Cell_Width = get(g:, 'ZiWei_Cell_Width', s:cellMinWidth)
let g:ZiWei_Cell_Height = get(g:, 'ZiWei_Cell_Height', s:cellMinHeight)
let s:wxJUTable = [
                  \ [2, 2, 6, 6, 3, 3, 5, 5, 4, 4, 6, 6],
                  \ [6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 5, 5],
                  \ [5, 5, 3, 3, 2, 2, 4, 4, 6, 6, 3, 3],
                  \ [3, 3, 4, 4, 6, 6, 2, 2, 5, 5, 4, 4],
                  \ [4, 4, 2, 2, 5, 5, 6, 6, 3, 3, 2, 2],
                  \ ]
let s:basicInfo = {
                  \ 'GENDER'  : 1,
                  \ 'NANNV'   : 1,
                  \ 'BYEAR'   : 2000,
                  \ 'BMONTH'  : 1,
                  \ 'BDAY'    : 1,
                  \ 'BHOUR'   : 1,
                  \ 'BYEARGZ' : 1,
                  \ 'MING'    : 1,
                  \ 'SHEN'    : 1,
                  \ 'JU'      : 2,
                  \ }
"" 命宫, 兄弟, 夫妻, 子女, 财帛, 疾厄, 迁移, 奴仆, 宫禄, 田宅, 福德, 父母, 身
let s:txtGong = [
                \ iconv("\xe5\x91\xbd\xe5\xae\xab", "utf-8", &enc),
                \ iconv("\xe5\x85\x84\xe5\xbc\x9f", "utf-8", &enc),
                \ iconv("\xe5\xa4\xab\xe5\xa6\xbb", "utf-8", &enc),
                \ iconv("\xe5\xad\x90\xe5\xa5\xb3", "utf-8", &enc),
                \ iconv("\xe8\xb4\xa2\xe5\xb8\x9b", "utf-8", &enc),
                \ iconv("\xe7\x96\xbe\xe5\x8e\x84", "utf-8", &enc),
                \ iconv("\xe8\xbf\x81\xe7\xa7\xbb", "utf-8", &enc),
                \ iconv("\xe5\xa5\xb4\xe4\xbb\x86", "utf-8", &enc),
                \ iconv("\xe5\xae\xab\xe7\xa6\x84", "utf-8", &enc),
                \ iconv("\xe7\x94\xb0\xe5\xae\x85", "utf-8", &enc),
                \ iconv("\xe7\xa6\x8f\xe5\xbe\xb7", "utf-8", &enc),
                \ iconv("\xe7\x88\xb6\xe6\xaf\x8d", "utf-8", &enc),
                \ iconv("\xe8\xba\xab", "utf-8", &enc),
                \ ]
"" S1N01 = 紫微, S1N02 = 天机, S1N03 = 太阳, S1N04 = 武曲, S1N05 = 天同, S1N06 = 廉贞
"" S1N11 = 天府, S1N12 = 太阴, S1N13 = 贪狼, S1N14 = 巨门, S1N15 = 天相, S1N16 = 天梁, S1N17 = 七杀, S1N18 = 破军
"" S2N01 = 左辅, S2N02 = 右弼, S2N03 = 文晶, S2N04 = 文曲, S2N05 = 地空, S2N06 = 地劫, S2N07 = 天魁, S2N08 = 天钺
"" S2N10 = 禄存, S2N11 = 擎羊, S2N12 = 陀罗, S2N13 = 火星, S2N14 = 铃星
let s:starInfo = {
                 \ 'S1N01' : {
                 \             'NAME'    : [iconv("\xe7\xb4\xab", "utf-8", &enc),iconv("\xe5\xbe\xae", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S1N01"]["TABLE"][s:basicInfo["JU"] - 2][s:basicInfo["BDAY"] - 1]',
                 \             'TABLE'   : [
                 \                          [2  , 3  , 3  , 4 , 4 , 5 , 5  , 6 , 6 , 7 , 7 , 8 , 8  , 9 , 9 , 10 , 10 , 11 , 11 , 12 , 12 , 1  , 1 , 2  , 2 , 3  , 3  , 4  , 4  , 5]  ,
                 \                          [5  , 2  , 3  , 6 , 3 , 4 , 7  , 4 , 5 , 8 , 5 , 6 , 9  , 6 , 7 , 10 , 7  , 8  , 11 , 8  , 9  , 12 , 9 , 10 , 1 , 10 , 11 , 2  , 11 , 12] ,
                 \                          [12 , 5  , 2  , 3 , 1 , 6 , 3  , 4 , 2 , 7 , 4 , 5 , 3  , 8 , 5 , 6  , 4  , 9  , 6  , 7  , 5  , 10 , 7 , 8  , 6 , 11 , 8  , 9  , 7  , 12] ,
                 \                          [7  , 12 , 5  , 2 , 3 , 8 , 1  , 6 , 3 , 4 , 9 , 2 , 7  , 4 , 5 , 10 , 3  , 8  , 5  , 6  , 11 , 4  , 9 , 6  , 7 , 12 , 5  , 10 , 7  , 8]  ,
                 \                          [10 , 7  , 12 , 5 , 2 , 3 , 11 , 8 , 1 , 6 , 3 , 4 , 12 , 9 , 2 , 7  , 4  , 5  , 1  , 10 , 3  , 8  , 5 , 6  , 2 , 11 , 4  , 9  , 6  , 7]  ,
                 \                         ],
                 \           },
                 \ 'S1N02' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe6\x9c\xba", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S1N01"]["VALUE"] - 2, s:cellCount) + 1',
                 \           },
                 \ 'S1N03' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xaa", "utf-8", &enc),iconv("\xe9\x98\xb3", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S1N01"]["VALUE"] - 4, s:cellCount) + 1',
                 \           },
                 \ 'S1N04' : {
                 \             'NAME'    : [iconv("\xe6\xad\xa6", "utf-8", &enc),iconv("\xe6\x9b\xb2", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S1N01"]["VALUE"] - 5, s:cellCount) + 1',
                 \           },
                 \ 'S1N05' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe5\x90\x8c", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S1N01"]["VALUE"] - 6, s:cellCount) + 1',
                 \           },
                 \ 'S1N06' : {
                 \             'NAME'    : [iconv("\xe5\xbb\x89", "utf-8", &enc),iconv("\xe8\xb4\x9e", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S1N01"]["VALUE"] - 9, s:cellCount) + 1',
                 \           },
                 \ 'S1N11' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe5\xba\x9c", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(17 - s:starInfo["S1N01"]["VALUE"], s:cellCount) + 1',
                 \           },
                 \ 'S1N12' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xaa", "utf-8", &enc),iconv("\xe9\x98\xb4", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S1N11"]["VALUE"], s:cellCount) + 1',
                 \           },
                 \ 'S1N13' : {
                 \             'NAME'    : [iconv("\xe8\xb4\xaa", "utf-8", &enc),iconv("\xe7\x8b\xbc", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S1N11"]["VALUE"] + 1, s:cellCount) + 1',
                 \           },
                 \ 'S1N14' : {
                 \             'NAME'    : [iconv("\xe5\xb7\xa8", "utf-8", &enc),iconv("\xe9\x97\xa8", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S1N11"]["VALUE"] + 2, s:cellCount) + 1',
                 \           },
                 \ 'S1N15' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe7\x9b\xb8", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S1N11"]["VALUE"] + 3, s:cellCount) + 1',
                 \           },
                 \ 'S1N16' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe6\xa2\x81", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S1N11"]["VALUE"] + 4, s:cellCount) + 1',
                 \           },
                 \ 'S1N17' : {
                 \             'NAME'    : [iconv("\xe4\xb8\x83", "utf-8", &enc),iconv("\xe6\x9d\x80", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S1N11"]["VALUE"] + 5, s:cellCount) + 1',
                 \           },
                 \ 'S1N18' : {
                 \             'NAME'    : [iconv("\xe7\xa0\xb4", "utf-8", &enc),iconv("\xe5\x86\x9b", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S1N11"]["VALUE"] + 9, s:cellCount) + 1',
                 \           },
                 \ }
let s:starCount = repeat([0, ], s:cellCount)

function! s:ZiWeiNew()
    let l:curdt = CalNow()
    let l:txt = "{'NAME':'Anonymous', 'GENDER':'M', 'CLOCKTIME':'" . l:curdt . "', 'SOLARTIME':'" . l:curdt . "'}"
    if len(getline('.')) > 0
        call append(line('.'), l:txt)
    else
        call setline(line('.'), l:txt)
    endif
endfunction
function! s:ZiWeiPaiPan()
    let l:inputinfo = eval(getline('.'))
    let l:lunarinfo = CalChineseLunarDT(CalParseDateTime(l:inputinfo['SOLARTIME']))
    let s:basicInfo['GENDER']  = (l:inputinfo['GENDER']=='F')?2:1
    let s:basicInfo['NANNV' ]  = (l:lunarinfo[5] + s:basicInfo['GENDER']) % 2 + 1
    let s:basicInfo['BYEAR']   = l:lunarinfo[0]
    let s:basicInfo['BMONTH']  = l:lunarinfo[1] + ((l:lunarinfo[4]>0)?1:0)
    let s:basicInfo['BDAY']    = l:lunarinfo[2]
    let s:basicInfo['BHOUR']   = (l:lunarinfo[3]>s:cellCount)?(l:lunarinfo[3] - s:cellCount):l:lunarinfo[3]
    let s:basicInfo['BYEARGZ'] = l:lunarinfo[5]
    let s:basicInfo['MING']    = CalModulo(s:basicInfo['BMONTH'] - 1 - (s:basicInfo['BHOUR'] - 1) + 2, s:cellCount) + 1
    let s:basicInfo['SHEN']    = CalModulo(s:basicInfo['BMONTH'] - 1 + s:basicInfo['BHOUR'] - 1 + 2, s:cellCount) + 1
    let s:basicInfo['JU']      = s:wxJUTable[CalModulo(s:basicInfo['BYEARGZ'] - 1, 5)][s:basicInfo['MING'] - 1]
    let s:starCount = repeat([0, ], s:cellCount)
    for l:skey in sort(keys(s:starInfo))
        let l:tmpvalue = eval(s:starInfo[l:skey]['CALC'])
        let s:starInfo[l:skey]['VALUE'] = l:tmpvalue
        if s:starInfo[l:skey]['VISIBLE'] == 1
            let s:starCount[l:tmpvalue - 1] = s:starCount[l:tmpvalue - 1] + 1
            let s:starInfo[l:skey]['POS']   = s:starCount[l:tmpvalue - 1]
        endif
    endfor
    call s:paipan()
endfunction
function! s:paipan()
    let l:zwpan = []
    let l:height = max([g:ZiWei_Cell_Height, s:cellMinHeight])
    let l:width  = max([g:ZiWei_Cell_Width,  s:cellMinWidth]) * 2
    " 初期化各宫文字列数组
    for l:i in range(s:cellCount)
        call add(l:zwpan, repeat(['',], l:height))
    endfor
    " 设置各宫文字列数组
    " 单元格右下角的月干支
    let l:rightcols = l:width - ((l:width - 20) / 2 + 6)
    let l:monthgz   = CalModulo(s:basicInfo['BYEARGZ'] - 1, 5) * 12 + 3
    for l:i in range(s:cellCount)
        let l:zwpan[CalModulo(l:i + 2, s:cellCount)][l:height - 2] = CalTextTG(l:monthgz + l:i)
        let l:zwpan[CalModulo(l:i + 2, s:cellCount)][l:height - 1] = repeat(' ', l:rightcols - 2) . CalTextDZ(l:monthgz + l:i)
    endfor
    " 单元格下方正中的12宫宫名及大运起始年龄
    for l:i in range(s:cellCount)
        let l:cellidx = CalModulo(s:basicInfo['MING'] - l:i - 1, s:cellCount) + 1
        let l:startage = s:basicInfo['JU'] + l:i * 10
        if l:cellidx == s:basicInfo['SHEN']
            let l:gongname = s:txtGong[12] . strpart(s:txtGong[l:i], 0, strlen(s:txtGong[12]))
        else
            let l:gongname = s:txtGong[l:i]
        endif
        let l:gongname = '[' . l:gongname . ']' . printf("%d-", l:startage)
        let l:zwpan[l:cellidx - 1][l:height - 1] = l:gongname . strpart(l:zwpan[l:cellidx - 1][l:height - 1], strwidth(l:gongname))
    endfor
    " 单元格左上角的星名
    for l:skey in sort(keys(s:starInfo))
        if s:starInfo[l:skey]['VISIBLE'] == 1
            let l:tmpvalue = s:starInfo[l:skey]['VALUE'] - 1
            if strwidth(l:zwpan[l:tmpvalue][0]) < l:width
                let l:zwpan[l:tmpvalue][0] = s:starInfo[l:skey]['NAME'][0] . l:zwpan[l:tmpvalue][0]
                let l:zwpan[l:tmpvalue][1] = s:starInfo[l:skey]['NAME'][1] . l:zwpan[l:tmpvalue][1]
            endif
        endif
    endfor
    " 生成命盘
    let l:outtxt = repeat(['',], l:height * 4 + 5)
    let l:outtxt[0] = '+' . repeat('-', l:width) .'+' . repeat('-', l:width) . '+' . repeat('-', l:width) . '+' . repeat('-', l:width) . '+'
    for l:i in range(l:height)
        let l:outtxt[l:i + 1] = '|' . repeat(' ', l:width - strwidth(l:zwpan[5][l:i])) . l:zwpan[5][l:i] . '|' . repeat(' ', l:width - strwidth(l:zwpan[6][l:i])) . l:zwpan[6][l:i] . '|' . repeat(' ', l:width - strwidth(l:zwpan[7][l:i])) . l:zwpan[7][l:i] . '|' . repeat(' ', l:width - strwidth(l:zwpan[8][l:i])) . l:zwpan[8][l:i] . '|'
    endfor
    let l:outtxt[l:height + 1] = '+' . repeat('-', l:width) .'+' . repeat('-', l:width) . '+' . repeat('-', l:width) . '+' . repeat('-', l:width) . '+'
    for l:i in range(l:height)
        let l:outtxt[l:i + 2 + l:height] = '|' . repeat(' ', l:width - strwidth(l:zwpan[4][l:i])) . l:zwpan[4][l:i] . '|' . repeat(' ', l:width * 2 + 1) . '|' . repeat(' ', l:width - strwidth(l:zwpan[9][l:i])) . l:zwpan[9][l:i] . '|'
    endfor
    let l:outtxt[l:height * 2 + 2] = '+' . repeat('-', l:width) .'+' . repeat(' ', l:width * 2 + 1) . '+' . repeat('-', l:width) . '+'
    for l:i in range(l:height)
        let l:outtxt[l:i + 3 + l:height * 2] = '|' . repeat(' ', l:width - strwidth(l:zwpan[3][l:i])) . l:zwpan[3][l:i] . '|' . repeat(' ', l:width * 2 + 1) . '|' . repeat(' ', l:width - strwidth(l:zwpan[10][l:i])) . l:zwpan[10][l:i] . '|'
    endfor
    let l:outtxt[l:height * 3 + 3] = '+' . repeat('-', l:width) .'+' . repeat('-', l:width) . '+' . repeat('-', l:width) . '+' . repeat('-', l:width) . '+'
    for l:i in range(l:height)
        let l:outtxt[l:i + 4 + l:height * 3] = '|' . repeat(' ', l:width - strwidth(l:zwpan[2][l:i])) . l:zwpan[2][l:i] . '|' . repeat(' ', l:width - strwidth(l:zwpan[1][l:i])) . l:zwpan[1][l:i] . '|' . repeat(' ', l:width - strwidth(l:zwpan[0][l:i])) . l:zwpan[0][l:i] . '|' . repeat(' ', l:width - strwidth(l:zwpan[11][l:i])) . l:zwpan[11][l:i] . '|'
    endfor
    let l:outtxt[l:height * 4 + 4] = '+' . repeat('-', l:width) .'+' . repeat('-', l:width) . '+' . repeat('-', l:width) . '+' . repeat('-', l:width) . '+'
    let l:i = line('.')
    for l:item in l:outtxt
        call append(l:i, l:item)
        let l:i = l:i + 1
    endfor
endfunction
