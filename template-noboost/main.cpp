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

	return 0;
}