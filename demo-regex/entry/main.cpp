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
void test_base()
{
	boost::regex pat(R"((?<addr>\d{6})(?<century>\d{2})(?<year>\d{2})(?<month>\d{2})(?<day>\d{2})(?<idx>\d{3})(?<crc>(\w)|(\d)))");
	std::string idnumber="12345620140102012X";
	boost::smatch match;
	bool b_match=boost::regex_search(idnumber,match,pat);
	if (b_match)
	{
		LOG(info)<<match.size();
		for(boost::smatch::size_type i=0;i<match.size();++i)
		{
			LOG(info)<<"Pos("<<i<<"):"<<match.position(i);
			/* use group index to select sub-match result */
			auto item=match[i];
			LOG(info)<<"  Match:"<<item.matched;
			LOG(info)<<"  Value:"<<item.str();
			LOG(info)<<"  Length:"<<item.length();
			LOG(info)<<"  From("<<std::distance(idnumber.cbegin(),item.first)<<") To("<<std::distance(idnumber.cbegin(),item.second)<<")";
		}
		/* use group name to select sub-match result */
		auto item=match["birth"];
		LOG(info)<<item.str();
		std::string id_15bit=boost::regex_replace(idnumber,pat,"$+{addr}${3}$+{month}$+{day}$+{idx}");
		LOG(info)<<id_15bit;
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
	test_base();
	return 0;
}
