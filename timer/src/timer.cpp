#define TIMER_DEFINE_VAR
#include "timer.hpp"

void timerinit()
{
	_g_shared_timer.reset(new BasicTimer());
}
SharedTimer getSharedTimer()
{
	return _g_shared_timer;
}

/* 设计概要：
 *   1. 创建Timer对象会自动创建一个线程
 *   2. 释放Timer对象会停止所有的计时器，并结束线程
 *   3. 创建计时器时，需要指定父对象和计时器ID
 *     3.1 父对象
 *        父对象被释放时自动停止并释放该父对象的所有子计时器
 *        不指定父对象（即指定nullptr）时，Timer对象释放时才会自动停止并释放该计时器
 *     3.2 计时器ID
 *        根据计时器ID的类型，分成3部分
 *        第1部分：最小值（分配失败时的返回值）
 *        第2部分：用户指定范围
 *        第3部分：自动分配范围
 *        创建计时器时，如果指定第2部分范围内的ID，并且该ID没有被占用时，分配该ID，否则自动分配
 * 使用方法：
 *   1. Boost.thread库有效（CMakeLists.txt中BOOSTTHREAD有效）
 *   2. 定义计时器回调函数（参数：计时器ID，返回值类型：void）
 *   3. 程序启动时，调用timerinit()或者手动生成1个Timer对象
 *      C＋＋的垃圾回收机制：
 *        全局变量：程序结束时回收
 *        局部变量：离开申明变量的{ }时，自动回收（指针变量需要手动delete）
 *   4. 申明父对象（boost::shared_ptr<int>）
 * 函数列表：
 *   TIMERID_T timer_new(const TimeOutFunc &func, const boost::shared_ptr<OWNER_T> &ptshare=nullptr, const TIMERID_T &timerid=std::numeric_limits<TIMERID_T>::min());
 *   bool timer_start(const TIMERID_T &timerid, const boost::chrono::steady_clock::duration &interval=boost::chrono::seconds(1), const long count=1);
 *   bool timer_stop(const TIMERID_T &timerid);
 *   bool timer_delete(const TIMERID_T &timerid);
 * 例：
 *   #include "timer.hpp" // timer.hpp中定义了父对象的类型，计时器ID的类型，计时器ID的自动分配起始值
 *                        // typedef Timer<TIMER_OWNER_T,TIMER_ID_T,TIMER_AUTO_ID_START> BasicTimer;
 *   void test(TIMER_ID_T x)                            // 定义计时器回调函数
 *   {
 *   }
 *   int main(int argc, char **argv)
 *   {
 *   	boost::shared_ptr<TIMER_OWNER_T> pt(new TIMER_OWNER_T(0));   // 申明父对象
 *   	timerinit();                                       // 生成计时器线程
 *   	auto t=getSharedTimer();
 *   	TIMER_ID_T tid;
 *   	tid=t->timer_new(test,nullptr,20);                 // 不指定父对象，使用第2部分计时器ID
 *   	t->timer_start(tid,boost::chrono::seconds(1),-1);  // 1秒间隔，无限次
 *   	tid=t->timer_new(test,pt,20);                      // 指定父对象，使用第2部分计时器ID，20已被占用，自动分配第3部分计时器ID(TIMER_AUTO_ID_START)
 *   	t->timer_start(tid,boost::chrono::seconds(2),10);  // 2秒间隔，10次
 *   	tid=t->timer_new(test,pt,0);                       // 指定父对象，自动分配第3部分计时器ID(TIMER_AUTO_ID_START+1)
 *   	t->timer_start(tid,boost::chrono::seconds(3),10);  // 3秒间隔，10次
 *   	boost::this_thread::sleep_for(boost::chrono::seconds(7));
 *   	pt.reset();                                        // 释放父对象，第2个和第3个计时器自动停止并释放
 *   	std::cin.get();                                    // 用户输入任意键后结束程序
 *   	return 0;
 *   }                                                     // 程序结束后，释放Timer对象
 *
 */
