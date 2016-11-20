#ifndef _BASEMODULE_H_
#define _BASEMODULE_H_

#include "common/common.h"

#ifdef _BASEMODULE_C_
#define EXTERN
#else
#define EXTERN extern
#endif

enum E_MODID {
	MODID_START = 0,					/**<  */
	MODID_SUBMODULE1 = MODID_START,		/**<  */
	MODID_MAX							/**<  */
};

/** \brief    Base class for modules
 *  \details  Base class for modules
 *  \version  0.1
 *  \date     2016
 *  \par      First revision
 *            hutesahustahuesa
 */
class BaseModule {
public:
	BaseModule() {}
	virtual ~BaseModule() {}
	virtual VD init(VD) = 0;
	virtual VD run(VD) = 0;
	virtual VD exit(U1 u1_code) = 0;
};

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
