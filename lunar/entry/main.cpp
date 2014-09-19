#include "log.hpp"
#include "lunar.hpp"

int main(int argc, char **argv)
{
	loginit(LEVEL_TRACE);
	LunarCalc lc;
	lc.setADDateTime(2014,10,10,12,23,34);
	LOG(trace)<< "trace message";
	LOG(debug)<< "debug message";
	LOG(info)<< "info message";
	LOG(warning)<< "warning message";
	LOG(error)<< "error message";
	LOG(fatal)<< "fatal message";
	return 0;
}
