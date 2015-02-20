#include <iostream>
#include "argvutils.hpp"
#include "log.hpp"
ArgvUtils simple_argv(int argc, char *argv[])
{
	bool ret = true;
	Argv a;
#ifdef DEBUGLOG
	a.startGroup("Log config");
	a.addBoolOption("logconf", "generate template file for log.conf");
	a.stopGroup();
#endif

	/* ToDo: add custom options here */
	a.addBoolOption("bo", "test bool option");
	a.addIntegerOptionI("io", "test Integer option", 100);
	a.addTextOption("so", "test string option");

	a.parse(argc, argv);
	if (a.showHelp(std::cout)) {
		/* '-h' is specified */
		ret = false;
	}
#ifdef DEBUGLOG
	if (ret && a.getBoolOption("logconf")) {
		/* '--logconf' is specified */
		ConfigLogger::configTemplate();
		ret = false;
	}
#endif
	if (ret) {
		return a;
	} else {
		return boost::none;
	}
}
