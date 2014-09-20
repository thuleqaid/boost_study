#include "log.hpp"
#include "lunar.hpp"
#include "translator.h"

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
	short adcal[]={2013,2,9,13,15,0};
	short scal[4]={0};
	short lcal[4]={0};
	int ret=TranslateAD2Solar(adcal,scal);
	LOG(trace)<<ret;
	LOG(trace)<<scal[0]<<":"<<scal[1]<<":"<<scal[2]<<":"<<scal[3];
	ret=TranslateAD2Lunar(adcal,lcal);
	LOG(trace)<<ret;
	LOG(trace)<<lcal[0]<<":"<<lcal[1]<<":"<<lcal[2]<<":"<<lcal[3];
	lcal[0]=2012;
	lcal[1]=12;
	lcal[2]=29;
	lcal[3]=1;
	ret=TranslateLunar2AD(lcal,adcal);
	LOG(trace)<<ret;
	LOG(trace)<<adcal[0]<<":"<<adcal[1]<<":"<<adcal[2];
	return 0;
}
