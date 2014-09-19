#include "lunar.hpp"

LunarCalc::LunarCalc()
{
	initData();
}

bool LunarCalc::setADDateTime(int year,int month,int day,int hour,int minute,int second)
{
	if ((year<1900) || (year>3000)
		|| (month<1) || (month>12)
		|| (day<1) || (day>31)
		|| (hour<0) || (hour>23)
		|| (minute<0) || (minute>59)
		|| (second<0) || (second>59))
	{
		return false;
	}
	initData();
	ad_year2=year%100;
	ad_year1=(year-ad_year2)/100;
	ad_month=month;
	ad_day=day;
	ad_hour=hour;
	ad_minute=minute;
	ad_second=second;
	return true;
}

void LunarCalc::initData()
{
	ad_year1 = 0;
	ad_year2 = 0;
	ad_month = 0;
	ad_day = 0;
	ad_hour = 0;
	ad_minute = 0;
	ad_second = 0;
	s_year = 0;
	s_month = 0;
	s_day = 0;
	s_hour = 0;
	s_yeargroup = 0;
	l_year = 0;
	l_month = 0;
	l_day = 0;
	l_hour = 0;
	l_leapmonth = 0;
}

