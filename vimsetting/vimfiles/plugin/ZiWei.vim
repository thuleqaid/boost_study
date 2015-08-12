" define command
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
                \       ['S1N06', 'S1N18', 'S1N04', 'S1N03'] ,
                \       ['S1N02', 'S1N16', 'S1N01', 'S1N12'] ,
                \       ['S1N05', 'S1N02', 'S2N03', 'S1N06'] ,
                \       ['S1N12', 'S1N05', 'S1N02', 'S1N14'] ,
                \       ['S1N13', 'S1N12', 'S1N03', 'S1N02'] ,
                \       ['S1N04', 'S1N13', 'S1N16', 'S2N04'] ,
                \       ['S1N03', 'S1N04', 'S1N11', 'S1N12'] ,
                \       ['S1N14', 'S1N03', 'S2N04', 'S2N03'] ,
                \       ['S1N16', 'S1N01', 'S1N11', 'S1N04'] ,
                \       ['S1N18', 'S1N14', 'S1N12', 'S1N13'] ,
                \       ]
                \ }
"" S1N01 = 紫微, S1N02 = 天机, S1N03 = 太阳, S1N04 = 武曲, S1N05 = 天同, S1N06 = 廉贞
"" S1N11 = 天府, S1N12 = 太阴, S1N13 = 贪狼, S1N14 = 巨门, S1N15 = 天相, S1N16 = 天梁, S1N17 = 七杀, S1N18 = 破军
"" S2N01 = 左辅, S2N02 = 右弼, S2N03 = 文昌, S2N04 = 文曲, S2N05 = 地空, S2N06 = 地劫, S2N07 = 天魁, S2N08 = 天钺
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
                 \ 'S2N01' : {
                 \             'NAME'    : [iconv("\xe5\xb7\xa6", "utf-8", &enc),iconv("\xe8\xbe\x85", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:basicInfo["BMONTH"] + 3, s:cellCount) + 1',
                 \           },
                 \ 'S2N02' : {
                 \             'NAME'    : [iconv("\xe5\x8f\xb3", "utf-8", &enc),iconv("\xe5\xbc\xbc", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(11 - s:basicInfo["BMONTH"], s:cellCount) + 1',
                 \           },
                 \ 'S2N03' : {
                 \             'NAME'    : [iconv("\xe6\x96\x87", "utf-8", &enc),iconv("\xe6\x98\x8c", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(11 - s:basicInfo["BHOUR"], s:cellCount) + 1',
                 \           },
                 \ 'S2N04' : {
                 \             'NAME'    : [iconv("\xe6\x96\x87", "utf-8", &enc),iconv("\xe6\x9b\xb2", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:basicInfo["BHOUR"] + 3, s:cellCount) + 1',
                 \           },
                 \ 'S2N05' : {
                 \             'NAME'    : [iconv("\xe5\x9c\xb0", "utf-8", &enc),iconv("\xe7\xa9\xba", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(12 - s:basicInfo["BHOUR"], s:cellCount) + 1',
                 \           },
                 \ 'S2N06' : {
                 \             'NAME'    : [iconv("\xe5\x9c\xb0", "utf-8", &enc),iconv("\xe5\x8a\xab", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:basicInfo["BHOUR"] + 10, s:cellCount) + 1',
                 \           },
                 \ 'S2N07' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe9\xad\x81", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S2N07"]["TABLE"][s:basicInfo["BYEARGZ"] % 10]',
                 \             'TABLE'   : [4 , 2 , 1 , 12 , 12 , 2 , 1 , 2 , 7 , 4],
                 \           },
                 \ 'S2N08' : {
                 \             'NAME'    : [iconv("\xe5\xa4\xa9", "utf-8", &enc),iconv("\xe9\x92\xba", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S2N08"]["TABLE"][s:basicInfo["BYEARGZ"] % 10]',
                 \             'TABLE'   : [6 , 8 , 9 , 10 , 10 , 8 , 9 , 8 , 3 , 6],
                 \           },
                 \ 'S2N10' : {
                 \             'NAME'    : [iconv("\xe7\xa6\x84", "utf-8", &enc),iconv("\xe5\xad\x98", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo["S2N10"]["TABLE"][s:basicInfo["BYEARGZ"] % 10]',
                 \             'TABLE'   : [1 , 3 , 4 , 6 , 7 , 6 , 7 , 9 , 10 , 12],
                 \           },
                 \ 'S2N11' : {
                 \             'NAME'    : [iconv("\xe6\x93\x8e", "utf-8", &enc),iconv("\xe7\xbe\x8a", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S2N10"]["VALUE"], s:cellCount) + 1',
                 \           },
                 \ 'S2N12' : {
                 \             'NAME'    : [iconv("\xe9\x99\x80", "utf-8", &enc),iconv("\xe7\xbd\x97", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S2N10"]["VALUE"] - 2, s:cellCount) + 1',
                 \           },
                 \ 'S2N13' : {
                 \             'NAME'    : [iconv("\xe7\x81\xab", "utf-8", &enc),iconv("\xe6\x98\x9f", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S2N13"]["TABLE"][s:basicInfo["BYEARGZ"] % 12] + s:basicInfo["BHOUR"] - 2, s:cellCount) + 1',
                 \             'TABLE'   : [10 , 3 , 4 , 2 , 10 , 3 , 4 , 2 , 10 , 3 , 4 , 2],
                 \           },
                 \ 'S2N14' : {
                 \             'NAME'    : [iconv("\xe9\x93\x83", "utf-8", &enc),iconv("\xe6\x98\x9f", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 'CalModulo(s:starInfo["S2N14"]["TABLE"][s:basicInfo["BYEARGZ"] % 12] + s:basicInfo["BHOUR"] - 2, s:cellCount) + 1',
                 \             'TABLE'   : [11 , 11 , 11 , 4 , 11 , 11 , 11 , 4 , 11 , 11 , 11 , 4],
                 \           },
                 \ }

"" S9N01 = 将星 S9N02 = 攀鞍 S9N03 = 岁驿 S9N04 = 息神 S9N05 = 华盖 S9N06 = 劫煞 S9N07 = 灾煞 S9N08 = 天煞 S9N09 = 指背 S9N10 = 咸池 S9N11 = 月煞 S9N12 = 亡神
"" S9N21 = 岁建 S9N22 = 晦气 S9N23 = 丧门 S9N24 = 贯索 S9N25 = 官符 S9N26 = 小耗 S9N27 = 大耗 S9N28 = 龙德 S9N29 = 白虎 S9N30 = 天德 S9N31 = 吊客 S9N32 = 病符
"" S9N41 = 博士 S9N42 = 力士 S9N43 = 青龙 S9N44 = 小耗 S9N45 = 将军 S9N46 = 奏书 S9N47 = 飞廉 S9N48 = 喜神 S9N49 = 病符 S9N50 = 大耗 S9N51 = 伏兵 S9N52 = 官府
let s:starInfo2 = {
                 \ 'S9N01' : {
                 \             'NAME'    : [iconv("\xe5\xb0\x86", "utf-8", &enc),iconv("\xe6\x98\x9f", "utf-8", &enc),],
                 \             'VISIBLE' : 1,
                 \             'CALC'    : 's:starInfo2["S9N01"]["TABLE"][(s:basicInfo["BYEARGZ"] - 1) % 12]',
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
                 \             'CALC'    : '(s:basicInfo["BYEARGZ"] - 1) % 12 + 1',
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
                 \             'CALC'    : 's:starInfo["S2N10"]["VALUE"]',
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
    let l:starCount = repeat([0, ], s:cellCount)
    for l:skey in sort(keys(s:starInfo2))
        let l:tmpvalue = eval(s:starInfo2[l:skey]['CALC'])
        let s:starInfo2[l:skey]['VALUE'] = l:tmpvalue
        if s:starInfo2[l:skey]['VISIBLE'] == 1
            let l:starCount[l:tmpvalue - 1] = l:starCount[l:tmpvalue - 1] + 1
            let s:starInfo2[l:skey]['POS']   = l:starCount[l:tmpvalue - 1]
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
    let l:rightcols = l:width - ((l:width - 20) / 2 + 6)
    let l:monthgz   = CalModulo(s:basicInfo['BYEARGZ'] - 1, 5) * 12 + 3
    for l:i in range(s:cellCount)
        let l:zwpan[CalModulo(l:i + 2, s:cellCount)][l:height - 2] = CalTextTG(l:monthgz + l:i)
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
    " 计算四化
    let l:fourChange = s:fourChange['TABLE'][(s:basicInfo['BYEARGZ'] - 1) % 10]
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
    let l:crow = 2
    for l:i in range(len(l:changes))
        let l:item = l:changes[l:i]
        let l:cspace = l:item[1] * 2 - strwidth(l:zwpan[l:item[0]][l:crow])
        let l:zwpan[l:item[0]][l:crow] = l:zwpan[l:item[0]][l:crow] . s:fourChange['NAME'][l:item[2]] . repeat(' ', l:cspace)
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
