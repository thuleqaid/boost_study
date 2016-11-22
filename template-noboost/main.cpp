#include "common/common.h"
#include "basemodule/modulelist.h"

#ifdef ENABLE_GFLAGS
#include <gflags/gflags.h>
#endif
#ifdef ENABLE_GLOG
#include <glog/logging.h>
#endif

#ifdef ENABLE_GFLAGS
/* ToDo: add command flags */
// DEFINE_bool(verbose, false, "Display program name before message");
// DEFINE_string(message, "Hello world!", "Message to print");
#endif

VD MainInit( VD );
VD MainLoop( VD );
VD MainExit( VD );
U1 MainLoopCondition( VD );
U1 MainExitCode( VD );

#define MAINLOOP_CONTINUE		( 0 )			/* 主循环继续 */
#define MAINLOOP_BREAK			( 1 )			/* 主循环退出 */

int main(int argc, char *argv[])
{
#ifdef ENABLE_GFLAGS
	gflags::SetUsageMessage("some usage message");
	gflags::SetVersionString("1.0.0");
	gflags::ParseCommandLineFlags(&argc, &argv, true);
	/* ToDo: use command flags */
	// if (FLAGS_verbose) std::cout << gflags::ProgramInvocationShortName() << ": ";
	// std::cout << FLAGS_message << std::endl;
	gflags::ShutDownCommandLineFlags();
#endif
#ifdef ENABLE_GLOG
	google::InitGoogleLogging(argv[0]);
	google::ParseCommandLineFlags(&argc, &argv, true);
#endif

	MainInit();
	while (MAINLOOP_CONTINUE == MainLoopCondition()) {
		MainLoop();
	}
	MainExit();
	return 0;
}

VD MainInit( VD )
{
	I4 i = 0;
	for (i = E_MODID::MODID_START; i < E_MODID::MODID_MAX; ++i) {
		g_mods.getModule(i)->init();
	}
}

VD MainLoop( VD )
{
	I4 i = 0;
	for (i = E_MODID::MODID_START; i < E_MODID::MODID_MAX; ++i) {
		g_mods.getModule(i)->run();
	}
}

VD MainExit( VD )
{
	I4 i = 0;
	U1 code = E_EXITCODE::EXIT_UNKNOWN;

	code = MainExitCode();
	for (i = E_MODID::MODID_START; i < E_MODID::MODID_MAX; ++i) {
		g_mods.getModule(i)->exit(code);
	}
}
U1 MainLoopCondition( VD )
{
	static I4 i4_times = 10;
	while (i4_times > 0) {
		i4_times--;
		return MAINLOOP_CONTINUE;
	}
	return MAINLOOP_BREAK;
}

U1 MainExitCode( VD )
{
	return E_EXITCODE::EXIT_USER;
}
