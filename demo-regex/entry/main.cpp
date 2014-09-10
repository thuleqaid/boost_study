#include "log.hpp"
#include <boost/regex.hpp>
#include <string>

void test_it1()
{
	boost::regex pat(R"([[:lower:]]+)");
	std::string text="aBBcccDDDDeeeeeFFFFFFggggggg";
	boost::sregex_iterator i(text.begin(),text.end(),pat);
	boost::sregex_iterator j;
	while(i!=j)
	{
		LOG(trace)<<i->size();
		LOG(trace)<<*i;
		i++;
	}
}
void test_it2()
{
	boost::regex pat(R"([[:lower:]]+)");
	std::string text="aBBcccDDDDeeeeeFFFFFFggggggg";
	boost::sregex_token_iterator i(text.begin(),text.end(),pat,-1);
	boost::sregex_token_iterator j;
	while(i!=j)
	{
		LOG(debug)<<*i;
		i++;
	}
}
int main(int argc, char **argv)
{
	loginit(LEVEL_TRACE);
	//LOG(trace)<< "trace message";
	//LOG(debug)<< "debug message";
	//LOG(info)<< "info message";
	//LOG(warning)<< "warning message";
	//LOG(error)<< "error message";
	//LOG(fatal)<< "fatal message";
	test_it1();
	test_it2();
	return 0;
}
