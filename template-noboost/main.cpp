#include "common/common.h"
#include "common/log.h"
#include <iostream>
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

    LOG(INFO) << "INFO: Hello"<<EOL;
    LOG(WARNING) << "WARNING: Hello"<<EOL;
    LOG(ERROR) << "ERROR: Hello"<<EOL;
    // LOG(FATAL) << "FATAL: Hello"<<EOL;

    google::ShutdownGoogleLogging();
    return 0;
}
