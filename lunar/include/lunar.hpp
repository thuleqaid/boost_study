#ifndef __LUNAR_HPP__
#define __LUNAR_HPP__

class LunarCalc
{
	public:
		LunarCalc();
		bool setADDateTime(int year=2000,int month=1,int day=1,int hour=0,int minute=0,int second=0);
	protected:
		void initData();
	private:
		typedef unsigned char inttype;
		inttype ad_year1;
		inttype ad_year2;
		inttype ad_month;
		inttype ad_day;
		inttype ad_hour;
		inttype ad_minute;
		inttype ad_second;
		inttype s_year;
		inttype s_month;
		inttype s_day;
		inttype s_hour;
		inttype s_yeargroup;
		inttype l_year;
		inttype l_month;
		inttype l_day;
		inttype l_hour;
		inttype l_leapmonth;
};

#endif /* __LUNAR_HPP__ */
