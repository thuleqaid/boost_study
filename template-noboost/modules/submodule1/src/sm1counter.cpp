#include "sm1counter.h"

/**	\brief		计数器最小值
 *	\version	0.1	2016/11/21	初版
 */
const I4 SM1Counter::COUNTER_MIN = 0;

/**	\brief		计数器最大值
 *	\version	0.1	2016/11/21	初版
 */
const I4 SM1Counter::COUNTER_MAX = 5;

/**	\brief		计数器管理对象构造函数
 *	\details	设定计数器（m_counter）初始值。
 *	\version	0.1	2016/11/21	初版
 */
SM1Counter::SM1Counter()
	:m_counter(COUNTER_MIN)
{
}

/**	\brief		计数器管理对象析构函数
 *	\version	0.1	2016/11/21	初版
 */
SM1Counter::~SM1Counter()
{
}

/**	\brief		是否刚好完成一个计数循环
 *	\details	当m_counter==COUNTER_MIN时，判断为完成一个循环。
 *	\version	0.1	2016/11/21	初版
 */
BOOL SM1Counter::isTimeUp()
{
	countUp();
	if (getCounter() == COUNTER_MIN) {
		return true;
	} else {
		return false;
	}
}

/**	\brief		取得当前计数器累加值
 *	\version	0.1	2016/11/21	初版
 */
I4 SM1Counter::getCounter() const
{
	return m_counter;
}

/**	\brief		计数器累加处理
 *	\details	m_counter达到COUNTER_MAX时，重新设置为COUNTER_MIN。
 *	\version	0.1	2016/11/21	初版
 */
VD SM1Counter::countUp()
{
	m_counter++;
	if (m_counter >= COUNTER_MAX) {
		m_counter = COUNTER_MIN;
	}
}
