#define _MODULELIST_C_
#include "basemodule/modulelist.h"

#include "submodule1/submodule1.h"

/**	\brief		全局模块管理对象构造函数
 *	\details	生成所有的全局公开子模块对象。
 *	\version	0.1	2016/11/21	初版
 */
ModuleList::ModuleList()
{
	mods[E_MODID::MODID_SUBMODULE1] = new SubModule1();
}

