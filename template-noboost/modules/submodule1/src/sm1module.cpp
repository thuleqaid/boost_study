#define _SM1MODULE_C_
#include "sm1module.h"

#include "sm1counter.h"

/**	\brief		SubModule1子模块管理对象构造函数
 *	\details	生成SubModule1所有的私有子模块对象。
 *	\version	0.1	2016/11/21	初版
 */
SM1ModuleList::SM1ModuleList()
{
	mods[E_SM1_MODID::MODID_SM1_COUNTER] = new SM1Counter();
}

