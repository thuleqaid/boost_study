#ifndef _TIMER_H_
#define _TIMER_H_
#ifdef COMMON_TIMER_ENABLE

#include <memory>
#include <chrono>
#include "common/common.h"

typedef I2 TIMER_OWNER_T;
typedef USIZE TIMER_ID_T;
typedef VD (*TimeOutFunc)(TIMER_ID_T);
#define TIMER_AUTO_ID_START 256
VD Timer_init();
VD Timer_destroy();
TIMER_ID_T Timer_newTimer(const TimeOutFunc &func, const std::shared_ptr<TIMER_OWNER_T> &ptshare);
BOOL Timer_startTimer(const TIMER_ID_T &timerid, const std::chrono::steady_clock::duration &interval, const USIZE count);
BOOL Timer_stopTimer(const TIMER_ID_T &timerid);
BOOL Timer_deleteTimer(const TIMER_ID_T &timerid);
BOOL Timer_running();

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
 * 使用方法（例）：
 *   #include "common/timer.h"
 *   void test(TIMER_ID_T x)                            // 定义计时器回调函数
 *   {
 *   }
 *   int main(int argc, char **argv)
 *   {
 *       std::shared_ptr<TIMER_OWNER_T> pt(new TIMER_OWNER_T(0));   // 申明父对象
 *       Timer_init();                                              // 生成计时器线程
 *       TIMER_ID_T tid;
 *       tid=Timer_newTimer(test,nullptr);                          // 不指定父对象，使用第2部分计时器ID
 *       Timer_startTimer(tid,std::chrono::seconds(1),-1);          // 1秒间隔，无限次
 *       tid=Timer_newTimer(test,pt);                               // 指定父对象，使用第2部分计时器ID，20已被占用，自动分配第3部分计时器ID(TIMER_AUTO_ID_START)
 *       Timer_startTimer(tid,std::chrono::seconds(2),10);          // 2秒间隔，10次
 *       tid=Timer_newTimer(test,pt);                               // 指定父对象，自动分配第3部分计时器ID(TIMER_AUTO_ID_START+1)
 *       Timer_startTimer(tid,std::chrono::seconds(3),10);          // 3秒间隔，10次
 *       std::this_thread::sleep_for(std::chrono::seconds(7));
 *       Timer_stopTimer(tid);
 *       tid -= 1;
 *       Timer_deleteTimer(tid);
 *       std::this_thread::sleep_for(std::chrono::seconds(5));
 *       pt.reset();                                                // 释放父对象，第2个和第3个计时器自动停止并释放
 *       std::cin.get();                                            // 用户输入任意键后结束程序
 *       Timer_destroy();                                           // 释放Timer对象
 *       return 0;
 *   }
 *
 */

#endif /* COMMON_TIMER_ENABLE */
#endif /* _TIMER_H_ */
