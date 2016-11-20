#define _BASEMODULE_C_
#include "basemodule/basemodule.h"

#include "submodule1/submodule1.h"

ModuleList::ModuleList()
{
	mods[MODID_SUBMODULE1] = new SubModule1();

}
ModuleList::~ModuleList()
{
	I4 i = 0;
	for (i = MODID_START; i < MODID_MAX; ++i) {
		delete mods[i];
	}
}

VD ModuleList::setModule(I4 modid, BaseModule* pmod, BOOL freeold = true) {
	if ((MODID_START <= modid) && (modid < MODID_MAX)) {
		if (freeold) {
			delete mods[modid];
		}
		mods[modid] = pmod;
	}
}

BaseModule* ModuleList::getModule(I4 modid) {
	if ((MODID_START <= modid) && (modid < MODID_MAX)) {
		return mods[modid];
	} else {
		return nullptr;
	}
}
