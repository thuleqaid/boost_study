#include <iostream>
#include "submodule1/submodule1.h"
#include "sm1module.h"
#include "sm1counter.h"

SubModule1::SubModule1()
{
}
SubModule1::~SubModule1()
{
}
VD SubModule1::init(VD)
{
	std::cout<<"SubModule1 Init"<<std::endl;
}
VD SubModule1::run(VD)
{
	SM1Counter *pcounter = dynamic_cast<SM1Counter *>(g_sm1_mods.getModule(MODID_SM1_COUNTER));	/* SM1Counter对象指针 */
	std::cout<<"SubModule1 Run:"<<pcounter->isTimeUp()<<std::endl;
}
VD SubModule1::exit(U1 u1_code)
{
	std::cout<<"SubModule1 Exit("<<static_cast<I4>(u1_code)<<")"<<std::endl;
}

