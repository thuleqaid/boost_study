#include "log.hpp"
#include "argvutils.hpp"
int main(int argc, char* argv[])
{
	ArgvUtils au = simple_argv(argc, argv);
	if (!au) {
		return 1;
	}

	/* ToDo: use arguments */
	LOG_TAG("tag1");
	LOG(4, "use argument");
	if (au->getBoolOption("bo")) {
		LOG_TAG("tag2");
		LOG(4, "bo");
	}
	LOG(4, au->getIntegerOption("io", -1));
	LOG_TAG("tag3");
	LOG(4, au->getTextOption("so", "nothing"));

	return 0;
}

