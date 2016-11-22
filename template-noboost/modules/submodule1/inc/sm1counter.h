#ifndef _SM1COUNTER_H_
#define _SM1COUNTER_H_

#include "basemodule/basemodule.h"

/**	\brief		计数器管理类
 *	\version	0.1	2016/11/21	初版
 */
class SM1Counter : public BaseModule
{
public:
	SM1Counter();
	virtual ~SM1Counter();
	virtual BOOL isTimeUp();
	virtual I4 getCounter() const;
	static const I4 COUNTER_MIN;
	static const I4 COUNTER_MAX;
protected:
	virtual VD countUp();
	/**	\brief		计数器成员变量
	 *	\version	0.1	2016/11/21	初版
	 */
	I4 m_counter;
};

#endif
