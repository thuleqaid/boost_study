#ifndef _SM1MODULE_H_
#define _SM1MODULE_H_

#include "basemodule/basemodule.h"

/**	\brief		SubModule1子模块ID列表
 *	\version	0.1	2016/11/21	初版
 */
enum E_SM1_MODID {
	MODID_START = 0,					/**<	模块起始ID			*/
	MODID_SM1_COUNTER = MODID_START,	/**<	模块ID:SM1Counter	*/
	MODID_MAX							/**<	模块总数			*/
};

/**	\brief		SubModule1子模块管理类
 *	\details	用于管理SubModule1所有私有子模块对象。
 *	\version	0.1	2016/11/21	初版
 */
class SM1ModuleList : public BaseModuleList<E_SM1_MODID> {
public:
	SM1ModuleList();
};

#ifdef _SM1MODULE_C_
SM1ModuleList g_sm1_mods;				/**<	SubModule1子模块管理对象		*/
#else
extern SM1ModuleList g_sm1_mods;		/**<	SubModule1子模块管理对象		*/
#endif

#endif
