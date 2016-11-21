#ifndef _BASEMODULE_H_
#define _BASEMODULE_H_

#include "common/common.h"

#ifdef _BASEMODULE_C_
#define EXTERN
#else
#define EXTERN extern
#endif

enum E_MODID {
	MODID_START = 0,					/**< 模块起始ID			*/
	MODID_SUBMODULE1 = MODID_START,		/**< 模块ID:SubModule1	*/
	MODID_MAX							/**< 模块总数			*/
};

/** \brief		子模块基类
 *  \details	所有子模块的基类，规定了main函数中会使用的3个接口函数。
 *  \version	0.1	2016/11/21	KOTEI	新规
 */
class BaseModule {
public:
	/** \brief		模块构造函数
	 *  \details	本函数中，生成所有私有对象的指针。
	 *  \version	0.1	2016/11/21	KOTEI	新规
	 */
	BaseModule() {}
	/** \brief		模块析构函数
	 *  \details	本函数中，释放所有私有对象的指针。
	 *  \version	0.1	2016/11/21	KOTEI	新规
	 */
	virtual ~BaseModule() {}
	/** \brief		模块初始化函数
	 *  \details	进行模块内的初始化处理，可以调用类成员函数以及私有对象的成员函数。
	 *  \version	0.1	2016/11/21	KOTEI	新规
	 */
	virtual VD init(VD) = 0;
	virtual VD run(VD) = 0;
	virtual VD exit(U1 u1_code) = 0;
};

/** \brief    子模块管理类
 *  \details  用于管理所有子模块对象。
 *  \version  0.1	2016/11/21	KOTEI	新规
 */
class ModuleList {
public:
	ModuleList();
	~ModuleList();
	VD setModule(I4 modid, BaseModule* pmod, BOOL freeold);
	BaseModule* getModule(I4 modid);
private:
	BaseModule* mods[MODID_MAX];
};

EXTERN ModuleList g_mods;

#endif
