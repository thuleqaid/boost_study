#include "log.hpp"

int main(int argc, char **argv)
{
	loginit(LEVEL_TRACE);
	LOG(trace)<< "trace message";
	LOG(debug)<< "debug message";
	LOG(info)<< "info message";
	LOG(warning)<< "warning message";
	LOG(error)<< "error message";
	LOG(fatal)<< "fatal message";
	return 0;
}
