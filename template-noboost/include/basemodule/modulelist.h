#ifndef _MODULELIST_H_
#define _MODULELIST_H_

#include "basemodule/basemodule.h"

/**	\brief		全局模块ID列表
 *	\version	0.1	2016/11/21	初版
 */
enum E_MODID {
	MODID_START = 0,					/**<	模块起始ID			*/
	MODID_SUBMODULE1 = MODID_START,		/**<	模块ID:SubModule1	*/
	MODID_MAX							/**<	模块总数			*/
};

/**	\brief		全局子模块管理类
 *	\details	用于管理所有全局公开子模块对象。
 *	\version	0.1	2016/11/21	初版
 */
class ModuleList : public BaseModuleList<E_MODID> {
public:
	ModuleList();
};

#ifdef _MODULELIST_C_
ModuleList g_mods;
#else
/**	\brief		全局子模块管理对象
 *	\version	0.1	2016/11/21	初版
 */
extern ModuleList g_mods;
#endif

#endif
