" define command
command! -n=0 -bar ZwPan :call s:ZiWeiPaiPan()
command! -n=1 -bar ZwYear :call s:ZiWeiYear(<args>)

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
"" 命宫, 兄弟, 夫妻, 子女, 财帛, 疾厄, 迁移, 奴仆, 官禄, 田宅, 福德, 父母, 身
let s:txtGong = [
                \ iconv("\xe5\x91\xbd\xe5\xae\xab", "utf-8", &enc),
                \ iconv("\xe5\x85\x84\xe5\xbc\x9f", "utf-8", &enc),
                \ iconv("\xe5\xa4\xab\xe5\xa6\xbb", "utf-8", &enc),
                \ iconv("\xe5\xad\x90\xe5\xa5\xb3", "utf-8", &enc),
                \ iconv("\xe8\xb4\xa2\xe5\xb8\x9b", "utf-8", &enc),
                \ iconv("\xe7\x96\xbe\xe5\x8e\x84", "utf-8", &enc),
                \ iconv("\xe8\xbf\x81\xe7\xa7\xbb", "utf-8", &enc),
                \ iconv("\xe5\xa5\xb4\xe4\xbb\x86", "utf-8", &enc),
                \ iconv("\xe5\xae\x98\xe7\xa6\x84", "utf-8", &enc),
                \ iconv("\xe7\x94\xb0\xe5\xae\x85", "utf-8", &enc),
                \ iconv("\xe7\xa6\x8f\xe5\xbe\xb7", "utf-8", &enc),
                \ iconv("\xe7\x88\xb6\xe6\xaf\x8d", "utf-8", &enc),
                \ iconv("\xe8\xba\xab", "utf-8", &enc),
                \ ]
"" 四化：禄权科忌
let s:fourChange = {
                \ 'PARAM': 60,
                \ 'NAME':  [iconv("\xe7\xa6\x84", "utf-8", &enc), iconv("\xe6\x9d\x83", "utf-8", &enc), iconv("\xe7\xa7\x91", "utf-8", &enc), iconv("\xe5\xbf\x8c", "utf-8", &enc),],
                \ 'TABLE': [
                \       ['S0N06', 'S0N18', 'S0N04', 'S0N03'] ,
                \       ['S0N02', 'S0N16', 'S0N01', 'S0N12'] ,
                \       ['S0N05', 'S0N02', 'S1N41', 'S0N06'] ,
                \       ['S0N12', 'S0N05', 'S0N02', 'S0N14'] ,
                \       ['S0N13', 'S0N12', 'S1N22', 'S0N02'] ,
                \       ['S0N04', 'S0N13', 'S0N16', 'S1N42'] ,
                \       ['S0N03', 'S0N04', 'S0N12', 'S0N05'] ,
                \       ['S0N14', 'S0N03', 'S1N42', 'S1N41'] ,
                \       ['S0N16', 'S0N01', 'S1N21', 'S0N04'] ,
                \       ['S0N18', 'S0N14', 'S0N12', 'S0N13'] ,
                \       ]
                \ }
""" 主星
"" 北斗
"" S0N01 = 紫微, S0N02 = 天机, S0N03 = 太阳, S0N04 = 武曲, S0N05 = 天同, S0N06 = 廉贞
"" 南斗
"" S0N11 = 天府, S0N12 = 太阴, S0N13 = 贪狼, S0N14 = 巨门, S0N15 = 天相, S0N16 = 天梁, S0N17 = 七杀, S0N18 = 破军
""" 甲级星
"" 年干
"" S1N01 = 禄存, S1N02 = 擎羊, S1N03 = 陀罗, S1N04 = 天魁, S1N05 = 天钺
"" 年支
"" S1N11 = 天马
"" 月
"" S1N21 = 左辅, S1N22 = 右弼
"" 时支
"" S1N41 = 文昌, S1N42 = 文曲, S1N43 = 火星, S1N44 = 铃星, S1N45 = 地劫, S1N46 = 地空, S1N47 = 台辅, S1N48 = 封诰
""" 乙级星
"" 年干
"" S2N01 = 天官, S2N02 = 天福, S2N03 = 天厨
"" 年支
"" S2N11 = 天空, S2N12 = 天哭, S2N13 = 天虚, S2N14 = 龙池, S2N15 = 凤阁, S2N16 = 红鸾, S2N17 = 天喜, S2N18 = 孤辰
"" S2N19 = 寡宿, S2N1A = 蜚廉, S2N1B = 破碎, S2N1C = 华盖, S2N1D = 咸池, S2N1E = 天德, S2N1F = 月德, S2N1G = 天才
"" S2N1H = 天寿
"" 月
"" S2N21 = 天刑, S2N22 = 天姚, S2N23 = 解神, S2N24 = 天巫, S2N25 = 天月, S2N26 = 阴煞
"" 日
"" S2N31 = 三台, S2N32 = 八座, S2N33 = 恩光, S2N34 = 天贵
let s:starInfo = {
                 \ 'S0N01' : {
                 \             'NAME'    : [iconv("\xe7\xb4\xab", "utf-8", &enc),iconv("\xe5\xbe\xae", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S0N01"]["TABLE"][s:basicInfo["JU"] - 2][s:basicInfo["BDAY"] - 1]',
                 \             'TABLE'   : [
                 \                          [2  , 3  , 3  , 4 , 4 , 5 , 5  , 6 , 6 , 7 , 7 , 8 , 8  , 9 , 9 , 10 , 10 , 11 , 11 , 12 , 12 , 1  , 1 , 2  , 2 , 3  , 3  , 4  , 4  , 5]  ,
                 \                          [5  , 2  , 3  , 6 , 3 , 4 , 7  , 4 , 5 , 8 , 5 , 6 , 9  , 6 , 7 , 10 , 7  , 8  , 11 , 8  , 9  , 12 , 9 , 10 , 1 , 10 , 11 , 2  , 11 , 12] ,
                 \                          [12 , 5  , 2  , 3 , 1 , 6 , 3  , 4 , 2 , 7 , 4 , 5 , 3  , 8 , 5 , 6  , 4  , 9  , 6  , 7  , 5  , 10 , 7 , 8  , 6 , 11 , 8  , 9  , 7  , 12] ,
                 \                          [7  , 12 , 5  , 2 , 3 , 8 , 1  , 6 , 3 , 4 , 9 , 2 , 7  , 4 , 5 , 10 , 3  , 8  , 5  , 6  , 11 , 4  , 9 , 6  , 7 , 12 , 5  , 10 , 7  , 8]  ,
                 \                          [10 , 7  , 12 , 5 , 2 , 3 , 11 , 8 , 1 , 6 , 3 , 4 , 12 , 9 , 2 , 7  , 4  , 5  , 1  , 10 , 3  , 8  , 5 , 6  , 2 , 11 , 4  , 9  , 6  , 7]  ,
                 \                         ],
                 \           },
                 \ 'S0N02' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe6\x9c\xba", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S0N01"]["VALUE"] - 2, s:cellCount) + 1',
                 \           },
                 \ 'S0N03' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xaa", "utf-8", &enc),iconv("\xe9\x98\xb3", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S0N01"]["VALUE"] - 4, s:cellCount) + 1',
                 \           },
                 \ 'S0N04' : {
                 \             'NAME'    : [iconv("\xe6\xad\xa6", "utf-8", &enc),iconv("\xe6\x9b\xb2", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S0N01"]["VALUE"] - 5, s:cellCount) + 1',
                 \           },
                 \ 'S0N05' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe5\x90\x8c", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S0N01"]["VALUE"] - 6, s:cellCount) + 1',
                 \           },
                 \ 'S0N06' : {
                 \             'NAME'    : [iconv("\xe5\xbb\x89", "utf-8", &enc),iconv("\xe8\xb4\x9e", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S0N01"]["VALUE"] - 9, s:cellCount) + 1',
                 \           },
                 \ 'S0N11' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe5\xba\x9c", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(17 - s:starInfo["S0N01"]["VALUE"], s:cellCount) + 1',
                 \           },
                 \ 'S0N12' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xaa", "utf-8", &enc),iconv("\xe9\x98\xb4", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S0N11"]["VALUE"], s:cellCount) + 1',
                 \           },
                 \ 'S0N13' : {
                 \             'NAME'    : [iconv("\xe8\xb4\xaa", "utf-8", &enc),iconv("\xe7\x8b\xbc", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S0N11"]["VALUE"] + 1, s:cellCount) + 1',
                 \           },
                 \ 'S0N14' : {
                 \             'NAME'    : [iconv("\xe5\xb7\xa8", "utf-8", &enc),iconv("\xe9\x97\xa8", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S0N11"]["VALUE"] + 2, s:cellCount) + 1',
                 \           },
                 \ 'S0N15' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe7\x9b\xb8", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S0N11"]["VALUE"] + 3, s:cellCount) + 1',
                 \           },
                 \ 'S0N16' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe6\xa2\x81", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S0N11"]["VALUE"] + 4, s:cellCount) + 1',
                 \           },
                 \ 'S0N17' : {
                 \             'NAME'    : [iconv("\xe4\xb8\x83", "utf-8", &enc),iconv("\xe6\x9d\x80", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S0N11"]["VALUE"] + 5, s:cellCount) + 1',
                 \           },
                 \ 'S0N18' : {
                 \             'NAME'    : [iconv("\xe7\xa0\xb4", "utf-8", &enc),iconv("\xe5\x86\x9b", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S0N11"]["VALUE"] + 9, s:cellCount) + 1',
                 \           },
                 \ 'S1N01' : {
                 \             'NAME'    : [iconv("\xe7\xa6\x84", "utf-8", &enc),iconv("\xe5\xad\x98", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S1N01"]["TABLE"][s:basicInfo["BYEARGZ"] % 10]',
                 \             'TABLE'   : [1 , 3 , 4 , 6 , 7 , 6 , 7 , 9 , 10 , 12],
                 \           },
                 \ 'S1N02' : {
                 \             'NAME'    : [iconv("\xe6\x93\x8e", "utf-8", &enc),iconv("\xe7\xbe\x8a", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S1N01"]["VALUE"], s:cellCount) + 1',
                 \           },
                 \ 'S1N03' : {
                 \             'NAME'    : [iconv("\xe9\x99\x80", "utf-8", &enc),iconv("\xe7\xbd\x97", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S1N01"]["VALUE"] - 2, s:cellCount) + 1',
                 \           },
                 \ 'S1N04' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe9\xad\x81", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S1N04"]["TABLE"][s:basicInfo["BYEARGZ"] % 10]',
                 \             'TABLE'   : [4 , 2 , 1 , 12 , 12 , 2 , 1 , 2 , 7 , 4],
                 \           },
                 \ 'S1N05' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe9\x92\xba", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S1N05"]["TABLE"][s:basicInfo["BYEARGZ"] % 10]',
                 \             'TABLE'   : [6 , 8 , 9 , 10 , 10 , 8 , 9 , 8 , 3 , 6],
                 \           },
                 \ 'S1N11' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe9\xa9\xac", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S1N11"]["TABLE"][s:basicInfo["BYEARGZ"] % 12]',
                 \             'TABLE'   : [6 , 3 , 12 , 9 , 6 , 3 , 12 , 9 , 6 , 3 , 12 , 9],
                 \           },
                 \ 'S1N21' : {
                 \             'NAME'    : [iconv("\xe5\xb7\xa6", "utf-8", &enc),iconv("\xe8\xbe\x85", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:basicInfo["BMONTH"] + 3, s:cellCount) + 1',
                 \           },
                 \ 'S1N22' : {
                 \             'NAME'    : [iconv("\xe5\x8f\xb3", "utf-8", &enc),iconv("\xe5\xbc\xbc", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(11 - s:basicInfo["BMONTH"], s:cellCount) + 1',
                 \           },
                 \ 'S1N41' : {
                 \             'NAME'    : [iconv("\xe6\x96\x87", "utf-8", &enc),iconv("\xe6\x98\x8c", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(11 - s:basicInfo["BHOUR"], s:cellCount) + 1',
                 \           },
                 \ 'S1N42' : {
                 \             'NAME'    : [iconv("\xe6\x96\x87", "utf-8", &enc),iconv("\xe6\x9b\xb2", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:basicInfo["BHOUR"] + 3, s:cellCount) + 1',
                 \           },
                 \ 'S1N43' : {
                 \             'NAME'    : [iconv("\xe7\x81\xab", "utf-8", &enc),iconv("\xe6\x98\x9f", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S1N43"]["TABLE"][s:basicInfo["BYEARGZ"] % 12] + s:basicInfo["BHOUR"] - 2, s:cellCount) + 1',
                 \             'TABLE'   : [10 , 3 , 4 , 2 , 10 , 3 , 4 , 2 , 10 , 3 , 4 , 2],
                 \           },
                 \ 'S1N44' : {
                 \             'NAME'    : [iconv("\xe9\x93\x83", "utf-8", &enc),iconv("\xe6\x98\x9f", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S1N44"]["TABLE"][s:basicInfo["BYEARGZ"] % 12] + s:basicInfo["BHOUR"] - 2, s:cellCount) + 1',
                 \             'TABLE'   : [11 , 11 , 11 , 4 , 11 , 11 , 11 , 4 , 11 , 11 , 11 , 4],
                 \           },
                 \ 'S1N45' : {
                 \             'NAME'    : [iconv("\xe5\x9c\xb0", "utf-8", &enc),iconv("\xe5\x8a\xab", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:basicInfo["BHOUR"] + 10, s:cellCount) + 1',
                 \           },
                 \ 'S1N46' : {
                 \             'NAME'    : [iconv("\xe5\x9c\xb0", "utf-8", &enc),iconv("\xe7\xa9\xba", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(12 - s:basicInfo["BHOUR"], s:cellCount) + 1',
                 \           },
                 \ 'S1N47' : {
                 \             'NAME'    : [iconv("\xe5\x8f\xb0", "utf-8", &enc),iconv("\xe8\xbe\x85", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(5 + s:basicInfo["BHOUR"], s:cellCount) + 1',
                 \           },
                 \ 'S1N48' : {
                 \             'NAME'    : [iconv("\xe5\xb0\x81", "utf-8", &enc),iconv("\xe8\xaf\xb0", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(1 + s:basicInfo["BHOUR"], s:cellCount) + 1',
                 \           },
                 \ 'S2N01' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe5\xae\x98", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S2N01"]["TABLE"][s:basicInfo["BYEARGZ"] % 10]',
                 \             'TABLE'   : [7 , 8 , 5 , 6 , 3 , 4 , 10 , 12 , 10 , 11],
                 \           },
                 \ 'S2N02' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe7\xa6\x8f", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S2N02"]["TABLE"][s:basicInfo["BYEARGZ"] % 10]',
                 \             'TABLE'   : [6 , 10 , 9 , 1 , 12 , 4 , 3 , 7 , 6 , 7],
                 \           },
                 \ 'S2N03' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe5\x8e\xa8", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S2N03"]["TABLE"][s:basicInfo["BYEARGZ"] % 10]',
                 \             'TABLE'   : [12 , 6 , 7 , 1 , 6 , 7 , 9 , 3 , 7 , 10],
                 \           },
                 \ 'S2N11' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe7\xa9\xba", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(0 + s:basicInfo["BYEARGZ"] % 12, s:cellCount) + 1',
                 \           },
                 \ 'S2N12' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe5\x93\xad", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(7 - s:basicInfo["BYEARGZ"] % 12, s:cellCount) + 1',
                 \           },
                 \ 'S2N13' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe8\x99\x9a", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(5 + s:basicInfo["BYEARGZ"] % 12, s:cellCount) + 1',
                 \           },
                 \ 'S2N14' : {
                 \             'NAME'    : [iconv("\xe9\xbe\x99", "utf-8", &enc),iconv("\xe6\xb1\xa0", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(3 + s:basicInfo["BYEARGZ"] % 12, s:cellCount) + 1',
                 \           },
                 \ 'S2N15' : {
                 \             'NAME'    : [iconv("\xe5\x87\xa4", "utf-8", &enc),iconv("\xe9\x98\x81", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(11 - s:basicInfo["BYEARGZ"] % 12, s:cellCount) + 1',
                 \           },
                 \ 'S2N16' : {
                 \             'NAME'    : [iconv("\xe7\xba\xa2", "utf-8", &enc),iconv("\xe9\xb8\xbe", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(4 - s:basicInfo["BYEARGZ"] % 12, s:cellCount) + 1',
                 \           },
                 \ 'S2N17' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe5\x96\x9c", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(10 - s:basicInfo["BYEARGZ"] % 12, s:cellCount) + 1',
                 \           },
                 \ 'S2N18' : {
                 \             'NAME'    : [iconv("\xe5\xad\xa4", "utf-8", &enc),iconv("\xe8\xbe\xb0", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S2N18"]["TABLE"][s:basicInfo["BYEARGZ"] % 12]',
                 \             'TABLE'   : [3 , 3 , 3 , 6 , 6 , 6 , 9 , 9 , 9 , 12, 12, 12],
                 \           },
                 \ 'S2N19' : {
                 \             'NAME'    : [iconv("\xe5\xaf\xa1", "utf-8", &enc),iconv("\xe5\xae\xbf", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S2N19"]["TABLE"][s:basicInfo["BYEARGZ"] % 12]',
                 \             'TABLE'   : [11 , 11 , 11 , 2 , 2 , 2 , 5 , 5 , 5 , 8, 8, 8],
                 \           },
                 \ 'S2N1A' : {
                 \             'NAME'    : [iconv("\xe8\x9c\x9a", "utf-8", &enc),iconv("\xe5\xbb\x89", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S2N1A"]["TABLE"][s:basicInfo["BYEARGZ"] % 12]',
                 \             'TABLE'   : [2 , 9 , 10 , 11 , 6 , 7 , 8 , 3 , 4 , 5, 12, 1],
                 \           },
                 \ 'S2N1B' : {
                 \             'NAME'    : [iconv("\xe7\xa0\xb4", "utf-8", &enc),iconv("\xe7\xa2\x8e", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S2N1B"]["TABLE"][s:basicInfo["BYEARGZ"] % 12]',
                 \             'TABLE'   : [10 , 6 , 2 , 10 , 6 , 2 , 10 , 6 , 2 , 10, 6, 2],
                 \           },
                 \ 'S2N1C' : {
                 \             'NAME'    : [iconv("\xe5\x8d\x8e", "utf-8", &enc),iconv("\xe7\x9b\x96", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S2N1C"]["TABLE"][s:basicInfo["BYEARGZ"] % 12]',
                 \             'TABLE'   : [8 , 5 , 2 , 11 , 8 , 5 , 2 , 11 , 8 , 5, 2, 11],
                 \           },
                 \ 'S2N1D' : {
                 \             'NAME'    : [iconv("\xe5\x92\xb8", "utf-8", &enc),iconv("\xe6\xb1\xa0", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S2N1D"]["TABLE"][s:basicInfo["BYEARGZ"] % 12]',
                 \             'TABLE'   : [1 , 10 , 7 , 4 , 1 , 10 , 7 , 4 , 1 , 10, 7, 4],
                 \           },
                 \ 'S2N1E' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe5\xbe\xb7", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(8 + s:basicInfo["BYEARGZ"] % 12, s:cellCount) + 1',
                 \           },
                 \ 'S2N1F' : {
                 \             'NAME'    : [iconv("\xe6\x9c\x88", "utf-8", &enc),iconv("\xe5\xbe\xb7", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(4 + s:basicInfo["BYEARGZ"] % 12, s:cellCount) + 1',
                 \           },
                 \ 'S2N1G' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe6\x89\x8d", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:basicInfo["MING"] - 2 + s:basicInfo["BYEARGZ"] % 12, s:cellCount) + 1',
                 \           },
                 \ 'S2N1H' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe5\xaf\xbf", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:basicInfo["SHEN"] - 2 + s:basicInfo["BYEARGZ"] % 12, s:cellCount) + 1',
                 \           },
                 \ 'S2N21' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe5\x88\x91", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(8 + s:basicInfo["BMONTH"], s:cellCount) + 1',
                 \           },
                 \ 'S2N22' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe5\xa7\x9a", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(0 + s:basicInfo["BMONTH"], s:cellCount) + 1',
                 \           },
                 \ 'S2N23' : {
                 \             'NAME'    : [iconv("\xe8\xa7\xa3", "utf-8", &enc),iconv("\xe7\xa5\x9e", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S2N23"]["TABLE"][s:basicInfo["BMONTH"] % 12]',
                 \             'TABLE'   : [7 , 9 , 9 , 11 , 11 , 1 , 1 , 3 , 3 , 5, 5, 7],
                 \           },
                 \ 'S2N24' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe5\xb7\xab", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S2N24"]["TABLE"][s:basicInfo["BMONTH"] % 12]',
                 \             'TABLE'   : [12 , 6 , 9 , 3 , 12 , 6 , 9 , 3 , 12 , 6, 9, 3],
                 \           },
                 \ 'S2N25' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe6\x9c\x88", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S2N25"]["TABLE"][s:basicInfo["BMONTH"] % 12]',
                 \             'TABLE'   : [3 , 11 , 6 , 5 , 3 , 8 , 4 , 12 , 8 , 3, 7, 11],
                 \           },
                 \ 'S2N26' : {
                 \             'NAME'    : [iconv("\xe9\x98\xb4", "utf-8", &enc),iconv("\xe7\x85\x9e", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S2N26"]["TABLE"][s:basicInfo["BMONTH"] % 12]',
                 \             'TABLE'   : [5 , 3 , 1 , 11 , 9 , 7 , 5 , 3 , 1 , 11, 9, 7],
                 \           },
                 \ 'S2N31' : {
                 \             'NAME'    : [iconv("\xe4\xb8\x89", "utf-8", &enc),iconv("\xe5\x8f\xb0", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:basicInfo["BDAY"] + s:starInfo["S1N21"]["VALUE"] - 2, s:cellCount) + 1',
                 \           },
                 \ 'S2N32' : {
                 \             'NAME'    : [iconv("\xe5\x85\xab", "utf-8", &enc),iconv("\xe5\xba\xa7", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S1N22"]["VALUE"] - s:basicInfo["BDAY"], s:cellCount) + 1',
                 \           },
                 \ 'S2N33' : {
                 \             'NAME'    : [iconv("\xe6\x81\xa9", "utf-8", &enc),iconv("\xe5\x85\x89", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:basicInfo["BDAY"] + s:starInfo["S1N41"]["VALUE"] - 3, s:cellCount) + 1',
                 \           },
                 \ 'S2N34' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe8\xb4\xb5", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:basicInfo["BDAY"] + s:starInfo["S1N42"]["VALUE"] - 3, s:cellCount) + 1',
                 \           },
                 \ }

"" S9N01 = 将星 S9N02 = 攀鞍 S9N03 = 岁驿 S9N04 = 息神 S9N05 = 华盖 S9N06 = 劫煞 S9N07 = 灾煞 S9N08 = 天煞 S9N09 = 指背 S9N10 = 咸池 S9N11 = 月煞 S9N12 = 亡神
"" S9N21 = 岁建 S9N22 = 晦气 S9N23 = 丧门 S9N24 = 贯索 S9N25 = 官符 S9N26 = 小耗 S9N27 = 大耗 S9N28 = 龙德 S9N29 = 白虎 S9N30 = 天德 S9N31 = 吊客 S9N32 = 病符
"" S9N41 = 博士 S9N42 = 力士 S9N43 = 青龙 S9N44 = 小耗 S9N45 = 将军 S9N46 = 奏书 S9N47 = 飞廉 S9N48 = 喜神 S9N49 = 病符 S9N50 = 大耗 S9N51 = 伏兵 S9N52 = 官府
let s:starInfo2 = {
                 \ 'S9N01' : {
                 \             'NAME'    : [iconv("\xe5\xb0\x86", "utf-8", &enc),iconv("\xe6\x98\x9f", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo2["S9N01"]["TABLE"][(s:basicInfo["YEARGZ"] - 1) % 12]',
                 \             'TABLE'   : [1, 10, 7, 4, 1, 10, 7, 4, 1, 10, 7, 4],
                 \           },
                 \ 'S9N02' : {
                 \             'NAME'    : [iconv("\xe6\x94\x80", "utf-8", &enc),iconv("\xe9\x9e\x8d", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N01"]["VALUE"], s:cellCount) + 1',
                 \           },
                 \ 'S9N03' : {
                 \             'NAME'    : [iconv("\xe5\xb2\x81", "utf-8", &enc),iconv("\xe9\xa9\xbf", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N01"]["VALUE"] + 1, s:cellCount) + 1',
                 \           },
                 \ 'S9N04' : {
                 \             'NAME'    : [iconv("\xe6\x81\xaf", "utf-8", &enc),iconv("\xe7\xa5\x9e", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N01"]["VALUE"] + 2, s:cellCount) + 1',
                 \           },
                 \ 'S9N05' : {
                 \             'NAME'    : [iconv("\xe5\x8d\x8e", "utf-8", &enc),iconv("\xe7\x9b\x96", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N01"]["VALUE"] + 3, s:cellCount) + 1',
                 \           },
                 \ 'S9N06' : {
                 \             'NAME'    : [iconv("\xe5\x8a\xab", "utf-8", &enc),iconv("\xe7\x85\x9e", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N01"]["VALUE"] + 4, s:cellCount) + 1',
                 \           },
                 \ 'S9N07' : {
                 \             'NAME'    : [iconv("\xe7\x81\xbe", "utf-8", &enc),iconv("\xe7\x85\x9e", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N01"]["VALUE"] + 5, s:cellCount) + 1',
                 \           },
                 \ 'S9N08' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe7\x85\x9e", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N01"]["VALUE"] + 6, s:cellCount) + 1',
                 \           },
                 \ 'S9N09' : {
                 \             'NAME'    : [iconv("\xe6\x8c\x87", "utf-8", &enc),iconv("\xe8\x83\x8c", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N01"]["VALUE"] + 7, s:cellCount) + 1',
                 \           },
                 \ 'S9N10' : {
                 \             'NAME'    : [iconv("\xe5\x92\xb8", "utf-8", &enc),iconv("\xe6\xb1\xa0", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N01"]["VALUE"] + 8, s:cellCount) + 1',
                 \           },
                 \ 'S9N11' : {
                 \             'NAME'    : [iconv("\xe6\x9c\x88", "utf-8", &enc),iconv("\xe7\x85\x9e", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N01"]["VALUE"] + 9, s:cellCount) + 1',
                 \           },
                 \ 'S9N12' : {
                 \             'NAME'    : [iconv("\xe4\xba\xa1", "utf-8", &enc),iconv("\xe7\xa5\x9e", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N01"]["VALUE"] + 10, s:cellCount) + 1',
                 \           },
                 \ 'S9N21' : {
                 \             'NAME'    : [iconv("\xe5\xb2\x81", "utf-8", &enc),iconv("\xe5\xbb\xba", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : '(s:basicInfo["YEARGZ"] - 1) % 12 + 1',
                 \           },
                 \ 'S9N22' : {
                 \             'NAME'    : [iconv("\xe6\x99\xa6", "utf-8", &enc),iconv("\xe6\xb0\x94", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N21"]["VALUE"], s:cellCount) + 1',
                 \           },
                 \ 'S9N23' : {
                 \             'NAME'    : [iconv("\xe4\xb8\xa7", "utf-8", &enc),iconv("\xe9\x97\xa8", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N21"]["VALUE"] + 1, s:cellCount) + 1',
                 \           },
                 \ 'S9N24' : {
                 \             'NAME'    : [iconv("\xe8\xb4\xaf", "utf-8", &enc),iconv("\xe7\xb4\xa2", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N21"]["VALUE"] + 2, s:cellCount) + 1',
                 \           },
                 \ 'S9N25' : {
                 \             'NAME'    : [iconv("\xe5\xae\x98", "utf-8", &enc),iconv("\xe7\xac\xa6", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N21"]["VALUE"] + 3, s:cellCount) + 1',
                 \           },
                 \ 'S9N26' : {
                 \             'NAME'    : [iconv("\xe5\xb0\x8f", "utf-8", &enc),iconv("\xe8\x80\x97", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N21"]["VALUE"] + 4, s:cellCount) + 1',
                 \           },
                 \ 'S9N27' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa7", "utf-8", &enc),iconv("\xe8\x80\x97", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N21"]["VALUE"] + 5, s:cellCount) + 1',
                 \           },
                 \ 'S9N28' : {
                 \             'NAME'    : [iconv("\xe9\xbe\x99", "utf-8", &enc),iconv("\xe5\xbe\xb7", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N21"]["VALUE"] + 6, s:cellCount) + 1',
                 \           },
                 \ 'S9N29' : {
                 \             'NAME'    : [iconv("\xe7\x99\xbd", "utf-8", &enc),iconv("\xe8\x99\x8e", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N21"]["VALUE"] + 7, s:cellCount) + 1',
                 \           },
                 \ 'S9N30' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe5\xbe\xb7", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N21"]["VALUE"] + 8, s:cellCount) + 1',
                 \           },
                 \ 'S9N31' : {
                 \             'NAME'    : [iconv("\xe5\x90\x8a", "utf-8", &enc),iconv("\xe5\xae\xa2", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N21"]["VALUE"] + 9, s:cellCount) + 1',
                 \           },
                 \ 'S9N32' : {
                 \             'NAME'    : [iconv("\xe7\x97\x85", "utf-8", &enc),iconv("\xe7\xac\xa6", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N21"]["VALUE"] + 10, s:cellCount) + 1',
                 \           },
                 \ 'S9N41' : {
                 \             'NAME'    : [iconv("\xe5\x8d\x9a", "utf-8", &enc),iconv("\xe5\xa3\xab", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S1N01"]["VALUE"]',
                 \           },
                 \ 'S9N42' : {
                 \             'NAME'    : [iconv("\xe5\x8a\x9b", "utf-8", &enc),iconv("\xe5\xa3\xab", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N41"]["VALUE"] - (s:basicInfo["NANNV"] * 2 - 3) * 1 - 1,  s:cellCount) + 1',
                 \           },
                 \ 'S9N43' : {
                 \             'NAME'    : [iconv("\xe9\x9d\x92", "utf-8", &enc),iconv("\xe9\xbe\x99", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N41"]["VALUE"] - (s:basicInfo["NANNV"] * 2 - 3) * 2 - 1,  s:cellCount) + 1',
                 \           },
                 \ 'S9N44' : {
                 \             'NAME'    : [iconv("\xe5\xb0\x8f", "utf-8", &enc),iconv("\xe8\x80\x97", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N41"]["VALUE"] - (s:basicInfo["NANNV"] * 2 - 3) * 3 - 1,  s:cellCount) + 1',
                 \           },
                 \ 'S9N45' : {
                 \             'NAME'    : [iconv("\xe5\xb0\x86", "utf-8", &enc),iconv("\xe5\x86\x9b", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N41"]["VALUE"] - (s:basicInfo["NANNV"] * 2 - 3) * 4 - 1,  s:cellCount) + 1',
                 \           },
                 \ 'S9N46' : {
                 \             'NAME'    : [iconv("\xe5\xa5\x8f", "utf-8", &enc),iconv("\xe4\xb9\xa6", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N41"]["VALUE"] - (s:basicInfo["NANNV"] * 2 - 3) * 5 - 1,  s:cellCount) + 1',
                 \           },
                 \ 'S9N47' : {
                 \             'NAME'    : [iconv("\xe9\xa3\x9e", "utf-8", &enc),iconv("\xe5\xbb\x89", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N41"]["VALUE"] - (s:basicInfo["NANNV"] * 2 - 3) * 6 - 1,  s:cellCount) + 1',
                 \           },
                 \ 'S9N48' : {
                 \             'NAME'    : [iconv("\xe5\x96\x9c", "utf-8", &enc),iconv("\xe7\xa5\x9e", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N41"]["VALUE"] - (s:basicInfo["NANNV"] * 2 - 3) * 7 - 1,  s:cellCount) + 1',
                 \           },
                 \ 'S9N49' : {
                 \             'NAME'    : [iconv("\xe7\x97\x85", "utf-8", &enc),iconv("\xe7\xac\xa6", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N41"]["VALUE"] - (s:basicInfo["NANNV"] * 2 - 3) * 8 - 1,  s:cellCount) + 1',
                 \           },
                 \ 'S9N50' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa7", "utf-8", &enc),iconv("\xe8\x80\x97", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N41"]["VALUE"] - (s:basicInfo["NANNV"] * 2 - 3) * 9 - 1,  s:cellCount) + 1',
                 \           },
                 \ 'S9N51' : {
                 \             'NAME'    : [iconv("\xe4\xbc\x8f", "utf-8", &enc),iconv("\xe5\x85\xb5", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N41"]["VALUE"] - (s:basicInfo["NANNV"] * 2 - 3) * 10 - 1,  s:cellCount) + 1',
                 \           },
                 \ 'S9N52' : {
                 \             'NAME'    : [iconv("\xe5\xae\x98", "utf-8", &enc),iconv("\xe5\xba\x9c", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo2["S9N41"]["VALUE"] - (s:basicInfo["NANNV"] * 2 - 3) * 11 - 1,  s:cellCount) + 1',
                 \           },
                 \ }

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
    " 设置中央块用数据
    let s:basicInfo['NAME']    = l:inputinfo['NAME']
    let s:basicInfo['BIRTH']   = l:inputinfo['SOLARTIME']
    let s:basicInfo['LUNAR']   = l:lunarinfo
    let l:starCount = repeat([0, ], s:cellCount)
    for l:skey in sort(keys(s:starInfo))
        let l:tmpvalue = eval(s:starInfo[l:skey]['CALC'])
        let s:starInfo[l:skey]['VALUE'] = l:tmpvalue
        if s:starInfo[l:skey]['VISIBLE'] == 1
            let l:starCount[l:tmpvalue - 1] = l:starCount[l:tmpvalue - 1] + 1
            let s:starInfo[l:skey]['POS']   = l:starCount[l:tmpvalue - 1]
        endif
    endfor
    call s:ZiWeiYear(str2nr(strftime("%Y")))
endfunction
function! s:ZiWeiYear(year)
    let l:age = a:year - s:basicInfo['BYEAR'] + 1
    if l:age < s:basicInfo['JU']
        let l:age = 0
    elseif l:age >= s:basicInfo['JU'] + 120
        let l:age = 0
    endif
    call s:paipan(l:age)
endfunction
function! s:paipan(age)
    let l:zwpan = []
    let l:height = max([g:ZiWei_Cell_Height, s:cellMinHeight])
    let l:width  = max([g:ZiWei_Cell_Width,  s:cellMinWidth]) * 2
    " 计算流年星曜
    if a:age > 0
        let s:basicInfo['YEARGZ'] = CalModulo(s:basicInfo["BYEAR"] + a:age - 1985, 60) + 1
    else
        let s:basicInfo['YEARGZ'] = s:basicInfo['BYEARGZ']
    endif
    let l:starCount = repeat([0, ], s:cellCount)
    for l:skey in sort(keys(s:starInfo2))
        let l:tmpvalue = eval(s:starInfo2[l:skey]['CALC'])
        let s:starInfo2[l:skey]['VALUE'] = l:tmpvalue
        if s:starInfo2[l:skey]['VISIBLE'] == 1
            let l:starCount[l:tmpvalue - 1] = l:starCount[l:tmpvalue - 1] + 1
            let s:starInfo2[l:skey]['POS']   = l:starCount[l:tmpvalue - 1]
        endif
    endfor
    " 初期化各宫文字列数组
    for l:i in range(s:cellCount)
        call add(l:zwpan, repeat(['',], l:height))
    endfor
    let l:center = repeat(['',], l:height * 2 + 1)
    " 设置中央块
    let l:center[0] = iconv("\xe5\xa7\x93\xe5\x90\x8d", "utf-8", &enc) . ":" . s:basicInfo['NAME'] . "        " . iconv("\xe6\x80\xa7\xe5\x88\xab", "utf-8", &enc) . ":"
    if s:basicInfo['GENDER'] == 1
        let l:center[0] = l:center[0] . iconv("\xe7\x94\xb7", "utf-8", &enc)
    else
        let l:center[0] = l:center[0] . iconv("\xe5\xa5\xb3", "utf-8", &enc)
    endif
    let l:center[1] = iconv("\xe5\x87\xba\xe7\x94\x9f\xe6\x97\xb6\xe9\x97\xb4", "utf-8", &enc)
    let l:center[2] = "    " . s:basicInfo['BIRTH']
    let l:center[3] = "    " . CalChineseLunarDTStr("%YT%YC%MT%MC%DT%DC%HZ%HC",s:basicInfo['LUNAR'])
    if a:age > 0
        let l:center[4] = string(s:basicInfo["BYEAR"] + a:age - 1)
    endif
    " 单元格右下方地盘干支
    let l:rightcols = l:width - ((l:width - 20) / 2 + 6)
    let l:monthgz   = CalModulo(s:basicInfo['BYEARGZ'] - 1, 5) * 12 + 3
    for l:i in range(s:cellCount)
        let l:zwpan[CalModulo(l:i + 2, s:cellCount)][l:height - 3] = repeat(' ', l:rightcols)
        let l:zwpan[CalModulo(l:i + 2, s:cellCount)][l:height - 2] = repeat(' ', l:rightcols - 2) . CalTextTG(l:monthgz + l:i)
        let l:zwpan[CalModulo(l:i + 2, s:cellCount)][l:height - 1] = repeat(' ', l:rightcols - 2) . CalTextDZ(l:monthgz + l:i)
    endfor
    " 单元格下方正中的12宫宫名及大运起始年龄
    let l:direction = s:basicInfo['NANNV'] * 2 - 3
    for l:i in range(s:cellCount)
        let l:cellidx = CalModulo(s:basicInfo['MING'] - l:i - 1, s:cellCount) + 1
        let l:startage = s:basicInfo['JU'] + ((s:cellCount + l:direction * l:i) % s:cellCount) * 10
        if l:cellidx == s:basicInfo['SHEN']
            let l:gongname = s:txtGong[12] . strpart(s:txtGong[l:i], 0, strlen(s:txtGong[12]))
        else
            let l:gongname = s:txtGong[l:i]
        endif
        let l:gongname = '[' . l:gongname . ']' . printf("%d-", l:startage)
        let l:zwpan[l:cellidx - 1][l:height - 1] = l:gongname . strpart(l:zwpan[l:cellidx - 1][l:height - 1], strwidth(l:gongname))
    endfor
    if a:age > 0
        " 大运12宫
        let l:startcell = s:basicInfo['MING'] - l:direction * (a:age / 10)
        for l:i in range(s:cellCount)
            let l:cellidx = CalModulo(l:startcell - l:i - 1, s:cellCount) + 1
            let l:gongname = s:txtGong[l:i]
            let l:gongname = iconv("\xe5\xa4\xa7", "utf-8", &enc) . l:gongname
            let l:zwpan[l:cellidx - 1][l:height - 2] = l:gongname . strpart(l:zwpan[l:cellidx - 1][l:height - 2], strwidth(l:gongname))
        endfor
        " 流年12宫
        let l:startcell = CalModulo(s:basicInfo["BYEAR"] + a:age - 1985, 60) + 1
        for l:i in range(s:cellCount)
            let l:cellidx = CalModulo(l:startcell - l:i - 1, s:cellCount) + 1
            let l:gongname = s:txtGong[l:i]
            let l:gongname = iconv("\xe5\xb9\xb4", "utf-8", &enc) . l:gongname
            let l:zwpan[l:cellidx - 1][l:height - 3] = l:gongname . strpart(l:zwpan[l:cellidx - 1][l:height - 3], strwidth(l:gongname))
        endfor
    endif
    " 单元格右上角的星名
    for l:skey in sort(keys(s:starInfo))
        if s:starInfo[l:skey]['VISIBLE'] == 1
            let l:tmpvalue = s:starInfo[l:skey]['VALUE'] - 1
            if strwidth(l:zwpan[l:tmpvalue][0]) < l:width
                let l:zwpan[l:tmpvalue][0] = s:starInfo[l:skey]['NAME'][0] . l:zwpan[l:tmpvalue][0]
                let l:zwpan[l:tmpvalue][1] = s:starInfo[l:skey]['NAME'][1] . l:zwpan[l:tmpvalue][1]
            endif
        endif
    endfor
    " 单元格左下角的星名
    for l:skey in sort(keys(s:starInfo2))
        if s:starInfo2[l:skey]['VISIBLE'] == 1
            let l:tmpvalue = s:starInfo2[l:skey]['VALUE'] - 1
            let l:tmpspace = l:width - strwidth(l:zwpan[l:tmpvalue][g:ZiWei_Cell_Height - s:starInfo2[l:skey]['POS']]) - strwidth(s:starInfo2[l:skey]['NAME'][0]) * 2
            let l:zwpan[l:tmpvalue][g:ZiWei_Cell_Height - s:starInfo2[l:skey]['POS']] = s:starInfo2[l:skey]['NAME'][0] . s:starInfo2[l:skey]['NAME'][1] . repeat(' ', l:tmpspace) . l:zwpan[l:tmpvalue][g:ZiWei_Cell_Height - s:starInfo2[l:skey]['POS']]
        endif
    endfor
    "" 计算四化
    " 命盘四化
    let l:yeargzs = [s:basicInfo['BYEARGZ'],]
    if a:age > 0
        " 大运四化
        let l:startcell = CalModulo(s:basicInfo['MING'] - l:direction * (a:age / 10) - 1, s:cellCount) + 1
        if l:startcell >= 3
            let l:yeargz = l:monthgz + l:startcell - 3
        else
            let l:yeargz = l:monthgz + l:startcell + 9
        endif
        call add(l:yeargzs, l:yeargz)
        " 流年四化
        let l:yeargz = CalModulo(s:basicInfo["BYEAR"] + a:age - 1985, 60) + 1
        call add(l:yeargzs, l:yeargz)
    endif
    for l:k in range(len(l:yeargzs))
        let l:fourChange = s:fourChange['TABLE'][(l:yeargzs[l:k] - 1) % 10]
        let l:changes = []
        for l:i in range(len(l:fourChange))
            let l:cvalue = s:starInfo[l:fourChange[l:i]]['VALUE'] - 1
            let l:cpos   = s:starInfo[l:fourChange[l:i]]['POS'] - 1
            let l:j = 0
            while l:j < len(l:changes)
                if l:cpos < l:changes[l:j][1]
                    call insert(l:changes, [l:cvalue, l:cpos, l:i], l:j)
                    break
                endif
                let l:j = l:j + 1
            endwhile
            if l:j >= len(l:changes)
                call add(l:changes, [l:cvalue, l:cpos, l:i])
            endif
        endfor
        let l:crow = 2 + l:k
        for l:i in range(len(l:changes))
            let l:item = l:changes[l:i]
            let l:cspace = l:item[1] * 2 - strwidth(l:zwpan[l:item[0]][l:crow])
            let l:zwpan[l:item[0]][l:crow] = l:zwpan[l:item[0]][l:crow] . s:fourChange['NAME'][l:item[2]] . repeat(' ', l:cspace)
        endfor
    endfor
    unlet l:item
    " 生成命盘
    let l:outtxt = repeat(['',], l:height * 4 + 5)
    let l:outtxt[0] = '+' . repeat('-', l:width) .'+' . repeat('-', l:width) . '+' . repeat('-', l:width) . '+' . repeat('-', l:width) . '+'
    " 巳午未申宫
    for l:i in range(l:height)
        let l:outtxt[l:i + 1] = '|' . repeat(' ', l:width - strwidth(l:zwpan[5][l:i])) . l:zwpan[5][l:i] . '|' . repeat(' ', l:width - strwidth(l:zwpan[6][l:i])) . l:zwpan[6][l:i] . '|' . repeat(' ', l:width - strwidth(l:zwpan[7][l:i])) . l:zwpan[7][l:i] . '|' . repeat(' ', l:width - strwidth(l:zwpan[8][l:i])) . l:zwpan[8][l:i] . '|'
    endfor
    let l:outtxt[l:height + 1] = '+' . repeat('-', l:width) .'+' . repeat('-', l:width) . '+' . repeat('-', l:width) . '+' . repeat('-', l:width) . '+'
    " 辰酉宫
    for l:i in range(l:height)
        let l:outtxt[l:i + 2 + l:height] = '|' . repeat(' ', l:width - strwidth(l:zwpan[4][l:i])) . l:zwpan[4][l:i] . '|' . l:center[l:i] . repeat(' ', l:width * 2 + 1 - strwidth(l:center[l:i])) . '|' . repeat(' ', l:width - strwidth(l:zwpan[9][l:i])) . l:zwpan[9][l:i] . '|'
    endfor
    let l:outtxt[l:height * 2 + 2] = '+' . repeat('-', l:width) .'+' . l:center[l:height] . repeat(' ', l:width * 2 + 1 - strwidth(l:center[l:height])) . '+' . repeat('-', l:width) . '+'
    " 卯戌宫
    for l:i in range(l:height)
        let l:outtxt[l:i + 3 + l:height * 2] = '|' . repeat(' ', l:width - strwidth(l:zwpan[3][l:i])) . l:zwpan[3][l:i] . '|' . l:center[l:i + l:height + 1] . repeat(' ', l:width * 2 + 1 - strwidth(l:center[l:i + l:height + 1])) . '|' . repeat(' ', l:width - strwidth(l:zwpan[10][l:i])) . l:zwpan[10][l:i] . '|'
    endfor
    let l:outtxt[l:height * 3 + 3] = '+' . repeat('-', l:width) .'+' . repeat('-', l:width) . '+' . repeat('-', l:width) . '+' . repeat('-', l:width) . '+'
    " 寅丑子亥宫
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
