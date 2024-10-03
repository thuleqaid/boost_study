#ifndef _LOGSEQ_H_
#define _LOGSEQ_H_
#ifdef COMMON_LOGSEQ_ENABLE

#include <string>
#include "common/common.h"
#include "common/ringbuffer.h"

VD Logseq_init(const U4 history_size=256, const U1 count_bits=32);
VD Logseq_mark(const std::string& label);
VD Logseq_destroy();

/* 设计概要：
 *   1. 在每个需要确认是否运行的位置，调用`Logseq_mark`函数（不同位置需要传入不同的label）
 *   2. Debug时，可以通过查看Logseq对象的值，来确定代码的执行过程
 *   3. 当history_size不够大时，新数据会覆盖最早的数据
 *   4. 数据规则
 *     4.1 在 0 < count_length < 4 时，history数据的高字节存放位置index，低字节(count_length)存放连续当前位置的次数
 *     4.2 在 count_length==0 或者 count_length >= 4 时，count_length设置为0，仅保存位置index
 */

#endif /* COMMON_LOGSEQ_ENABLE */
#endif /* _LOGSEQ_H_ */
