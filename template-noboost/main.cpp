#include "common/common.h"
#include "common/log.h"
#include "common/timer.h"
#include <iostream>
#include <thread>
#ifdef ENABLE_GFLAGS
#include <gflags/gflags.h>
/* ToDo: add command flags */
// DEFINE_bool		布尔类型
// DEFINE_int32	32位整型
// DEFINE_int64	64位整型
// DEFINE_uint64	无符号64位整型
// DEFINE_double	浮点类型
// DEFINE_string	C++ string类型
// DEFINE_XXX(Name, default_value, "help message");
#endif

void test(TIMER_ID_T x)                            // 定义计时器回调函数
{
    LOG(ERROR) << x;
}

int main(int argc, char *argv[])
{
#ifdef ENABLE_GFLAGS
    gflags::SetUsageMessage("some usage message");
    gflags::SetVersionString("1.0.0");
    gflags::ParseCommandLineFlags(&argc, &argv, true);
    /* ToDo: use variable FLAGS_Name */
    gflags::ShutDownCommandLineFlags();
#endif
    google::InitGoogleLogging(argv[0]);

    LOG(INFO) << "INFO: Hello";
    LOG(WARNING) << "WARNING: Hello";
    LOG(ERROR) << "ERROR: Hello";
    // LOG(FATAL) << "FATAL: Hello";
    std::shared_ptr<TIMER_OWNER_T> pt(new TIMER_OWNER_T(0));   // 申明父对象
    Timer_init();                                       // 生成计时器线程
    TIMER_ID_T tid;
    tid=Timer_newTimer(test,nullptr);                 // 不指定父对象，使用第2部分计时器ID
    Timer_startTimer(tid,std::chrono::seconds(1),-1);  // 1秒间隔，无限次
    tid=Timer_newTimer(test,pt);                      // 指定父对象，使用第2部分计时器ID，20已被占用，自动分配第3部分计时器ID(TIMER_AUTO_ID_START)
    Timer_startTimer(tid,std::chrono::seconds(2),10);  // 2秒间隔，10次
    tid=Timer_newTimer(test,pt);                       // 指定父对象，自动分配第3部分计时器ID(TIMER_AUTO_ID_START+1)
    Timer_startTimer(tid,std::chrono::seconds(3),10);  // 3秒间隔，10次
    std::this_thread::sleep_for(std::chrono::seconds(7));
    Timer_stopTimer(tid);
    tid -= 1;
    Timer_deleteTimer(tid);
    std::this_thread::sleep_for(std::chrono::seconds(5));
    pt.reset();                                        // 释放父对象，第2个和第3个计时器自动停止并释放
    std::cin.get();                                    // 用户输入任意键后结束程序
    Timer_destroy();

    google::ShutdownGoogleLogging();
    return 0;
}
