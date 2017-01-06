#ifndef _BASEMODULE_H_
#define _BASEMODULE_H_

#include "common/common.h"

/**	\mainpage	代码架构
 *	\section	WholeArch	整体架构
 *	* include目录存放公用头文件
 *	* modules目录下每个子模块单独建立一个目录
 *	* tests目录下存放单元测试用代码
 *	* extlibs目录下存放外部库文件及头文件
 *	* main.cpp程序入口
 *	\section	ModuleArch	添加子模块
 *	* 新建文件（假设子模块名为Xxx）
 *	  - include/Xxx/Xxx.h 公开头文件，定义class Xxx:public BaseModule
 *	  - modules/Xxx/CMakeLists.txt 复制modules/basemodule/CMakeLists.txt
 *	  - modules/Xxx/src/Xxx.cpp 实现Xxx类
 *	  - modules/Xxx/inc/XxxAAA.h 私有头文件，定义class XxxAAA:public BaseModule
 *	  - modules/Xxx/src/XxxAAA.cpp 实现XxxAAA类
 *	  - modules/Xxx/inc/XxxBBB.h 私有头文件，定义class XxxBBB:public BaseModule
 *	  - modules/Xxx/src/XxxBBB.cpp 实现XxxBBB类
 *	  - modules/Xxx/inc/XxxModule.h 私有头文件，定义模块ID列表（E_XXX_MODID），定义class XxxModule:public BaseModuleList<E_XXX_MODID>
 *	  - modules/Xxx/src/XxxModule.cpp 实现XxxModule类，定义全局变量（XxxModule类型的对象）
 *	* 修改内容
 *	  - E_MODID 在MODID_MAX之前添加Xxx模块的模块ID
 *	  - ModuleList::ModuleList() 添加Xxx模块对象的生成处理
 */

/**	\brief		系统退出原因
 *	\version	0.1	2016/11/21	初版
 */
enum E_EXITCODE {
	EXIT_UNKNOWN = 0,					/**< 未知原因			*/
	EXIT_SYSTEM,						/**< 系统结束			*/
	EXIT_USER							/**< 用户退出			*/
};

/**	\brief		子模块基类
 *	\details	所有子模块的基类，规定了main函数中会使用的3个接口函数。
 *	\version	0.1	2016/11/21	初版
 */
class BaseModule {
public:

	/**	\brief		模块构造函数
	 *	\details	本函数中，生成所有私有对象的指针。
	 *	\version	0.1	2016/11/21	初版
	 */
	BaseModule() {}
	/**	\brief		模块析构函数
	 *	\details	本函数中，释放所有私有对象的指针。
	 *	\version	0.1	2016/11/21	初版
	 */
	virtual ~BaseModule() {}
	/**	\brief		模块初始化函数
	 *	\details	进行模块内的初始化处理，可以调用类成员函数以及私有对象的成员函数。
	 *	\version	0.1	2016/11/21	初版
	 */
	virtual VD init(VD) {}
	/**	\brief		模块处理函数
	 *	\details	主循环中每次循环依次调用所有子模块的模块处理函数。
	 *	\version	0.1	2016/11/21	初版
	 */
	virtual VD run(VD) {}
	/**	\brief		模块退出函数
	 *	\details	系统结束时，依次调用所有子模块的模块退出函数。
	 *	\param[in]	u1_code	\ref E_EXITCODE "退出原因"
	 *	\version	0.1	2016/11/21	初版
	 */
	virtual VD exit(U1 u1_code) {}
};

/**	\brief		子模块管理类
 *	\details	用于管理所有子模块对象。
 *	\par		对于枚举类型ModEnum的要求
 *				第一个成员必须为MODID_START(0)，最后一个成员必须为MODID_MAX。
 *	\version	0.1	2016/11/21	初版
 */
template <typename ModEnum>
class BaseModuleList {
public:
	/**	\brief		模块管理对象析构函数
	 *	\details	释放所有的子模块对象。
	 *	\version	0.1	2016/11/21	初版
	 */
	virtual ~BaseModuleList()
	{
		I4 i = 0;
		for (i = ModEnum::MODID_MAX - 1; i >= ModEnum::MODID_START; --i) {
			delete mods[i];
		}
	}

	/**	\brief		子模块对象设定函数
	 *	\details	指定子模块ID有效时，设定子模块ID对应的模块对象。
	 *	\param[in]	modid	子模块ID [ModEnum::MODID_START, ModEnum::MODID_MAX)
	 *	\param[in]	pmod	新模块对象地址
	 *	\param[in]	freeold	是否释放原模块对象空间
	 *	\version	0.1	2016/11/21	初版
	 */
	VD setModule(I4 modid, BaseModule* pmod, BOOL freeold)
	{
		if ((ModEnum::MODID_START <= modid) && (modid < ModEnum::MODID_MAX)) {
			if (freeold) {
				delete mods[modid];
			}
			mods[modid] = pmod;
	}
	}
	/**	\brief		子模块对象取得函数
	 *	\details	指定子模块ID有效时，取得子模块ID对应的模块对象。
	 *	\par		代码示例
	 *				dynamic_cast<子模块类型 *>(BaseModuleList对象.getModule(模块ID))
	 *	\param[in]	modid	子模块ID [ModEnum::MODID_START, ModEnum::MODID_MAX)
	 *	\return		模块对象地址（指定子模块ID无效时，返回nullptr）
	 *	\version	0.1	2016/11/21	初版
	 */
	BaseModule* getModule(I4 modid)
	{
		if ((ModEnum::MODID_START <= modid) && (modid < ModEnum::MODID_MAX)) {
			return mods[modid];
		} else {
			return nullptr;
		}
	}
protected:
	BaseModule* mods[ModEnum::MODID_MAX];		/**<	子模块对象数组			*/
};

#endif
