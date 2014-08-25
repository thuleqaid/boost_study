#include "argv.hpp"

Argv::Argv(const std::string& defaultdesc,bool helpopt,const std::string& helpdesc)
	:m_status(PARSE_INIT)
	,m_curidx(0)
{
	std::shared_ptr<boost::program_options::options_description> unnamed(new boost::program_options::options_description(defaultdesc));
	m_options.push_back(std::make_pair(unnamed,true));
	if (helpopt)
	{
		addBoolOption("help,h",helpdesc);
	}
}
Argv::~Argv()
{
}
bool Argv::parse(int argc,char* argv[])
{
	boost::program_options::options_description desc;
	for (auto &item: m_options)
	{
		desc.add(*item.first);
	}
	try
	{
		/* parse command line */
		boost::program_options::positional_options_description p;
		for (auto &item:m_optpos)
		{
			if (validOption(item.first)) {
				p.add(item.first.c_str(),item.second);
			}
		}
		auto parsed=boost::program_options::command_line_parser(argc,argv).options(desc).positional(p).allow_unregistered().run();
		boost::program_options::store(parsed,m_varmap);
		std::vector<std::string> result=boost::program_options::collect_unrecognized(parsed.options, boost::program_options::include_positional);
		m_unrecognized.reserve(m_unrecognized.size()+result.size());
		std::copy(result.cbegin(),result.cend(),std::back_inserter(m_unrecognized));
		/* parse config files */
		std::vector<std::string> files;
		for (auto &item:m_optsetf)
		{
			if (m_varmap.count(item)>0) {
				files.push_back(m_varmap[item].as<std::string>());
			}
		}
		for (auto &item:files)
		{
			std::ifstream ifs(item.c_str());
			if (ifs) {
				/* not collect unrecognized options */
				boost::program_options::store(boost::program_options::parse_config_file(ifs,desc,true),m_varmap);
			}
		}
		m_status=PARSE_OK;
	}
	catch(std::exception& )
	{
		m_status=PARSE_NG;
	}
	return (PARSE_OK==m_status);
}
void Argv::startGroup(const std::string& groupdesc,bool visible)
{
	std::shared_ptr<boost::program_options::options_description> named(new boost::program_options::options_description(groupdesc));
	m_options.push_back(std::make_pair(named,visible));
	m_curidx=m_options.size()-1;
}
void Argv::stopGroup()
{
	m_curidx=0;
}
bool Argv::showHelp(std::ostream& os, bool force)
{
	if (force || getBoolOption("help") || (PARSE_NG==m_status))
	{
		boost::program_options::options_description desc;
		for (auto &item: m_options)
		{
			if (item.second) {
				desc.add(*item.first);
			}
		}
		os<<desc;
		return true;
	}
	return false;
}
Argv& Argv::addBoolOption(const std::string& optname,const std::string& optdesc)
{
	auto opts=m_options[m_curidx].first;
	opts->add_options()(optname.c_str(),optdesc.c_str());
	return *this;
}
bool Argv::getBoolOption(const std::string& optname)
{
	if (PARSE_OK==m_status) {
		if (m_varmap.count(optname)>0) {
			return true;
		}
	}
	return false;
}
Argv& Argv::addIntegerOption(const std::string& optname,const std::string& optdesc)
{
	auto opts=m_options[m_curidx].first;
	opts->add_options()(optname.c_str(),boost::program_options::value<long>(),optdesc.c_str());
	addRecordI(optname);
	return *this;
}
Argv& Argv::addIntegerOptionD(const std::string& optname,const std::string& optdesc,long defvalue)
{
	auto opts=m_options[m_curidx].first;
	opts->add_options()(optname.c_str(),boost::program_options::value<long>()->default_value(defvalue),optdesc.c_str());
	addRecordI(optname);
	return *this;
}
Argv& Argv::addIntegerOptionI(const std::string& optname,const std::string& optdesc,long impvalue)
{
	auto opts=m_options[m_curidx].first;
	opts->add_options()(optname.c_str(),boost::program_options::value<long>()->implicit_value(impvalue),optdesc.c_str());
	addRecordI(optname);
	return *this;
}
Argv& Argv::addIntegerOptionDI(const std::string& optname,const std::string& optdesc,long defvalue,long impvalue)
{
	auto opts=m_options[m_curidx].first;
	opts->add_options()(optname.c_str(),boost::program_options::value<long>()->default_value(defvalue)->implicit_value(impvalue),optdesc.c_str());
	addRecordI(optname);
	return *this;
}
long Argv::getIntegerOption(const std::string& optname,long defaultvalue)
{
	long ret=defaultvalue;
	if (validRecordI(optname)) {
		if (PARSE_OK==m_status) {
			if (m_varmap.count(optname)>0) {
				ret=m_varmap[optname].as<long>();
			}
		}
	}
	return ret;
}
Argv& Argv::addDecimalOption(const std::string& optname,const std::string& optdesc)
{
	auto opts=m_options[m_curidx].first;
	opts->add_options()(optname.c_str(),boost::program_options::value<double>(),optdesc.c_str());
	addRecordD(optname);
	return *this;
}
Argv& Argv::addDecimalOptionD(const std::string& optname,const std::string& optdesc,double defvalue)
{
	auto opts=m_options[m_curidx].first;
	opts->add_options()(optname.c_str(),boost::program_options::value<double>()->default_value(defvalue),optdesc.c_str());
	addRecordD(optname);
	return *this;
}
Argv& Argv::addDecimalOptionI(const std::string& optname,const std::string& optdesc,double impvalue)
{
	auto opts=m_options[m_curidx].first;
	opts->add_options()(optname.c_str(),boost::program_options::value<double>()->implicit_value(impvalue),optdesc.c_str());
	addRecordD(optname);
	return *this;
}
Argv& Argv::addDecimalOptionDI(const std::string& optname,const std::string& optdesc,double defvalue,double impvalue)
{
	auto opts=m_options[m_curidx].first;
	opts->add_options()(optname.c_str(),boost::program_options::value<double>()->default_value(defvalue)->implicit_value(impvalue),optdesc.c_str());
	addRecordD(optname);
	return *this;
}
double Argv::getDecimalOption(const std::string& optname,double defaultvalue)
{
	double ret=defaultvalue;
	if (validRecordD(optname)) {
		if (PARSE_OK==m_status) {
			if (m_varmap.count(optname)>0) {
				ret=m_varmap[optname].as<double>();
			}
		}
	}
	return ret;
}
Argv& Argv::addTextOption(const std::string& optname,const std::string& optdesc)
{
	auto opts=m_options[m_curidx].first;
	opts->add_options()(optname.c_str(),boost::program_options::value<std::string>(),optdesc.c_str());
	addRecordT(optname);
	return *this;
}
Argv& Argv::addTextOptionD(const std::string& optname,const std::string& optdesc,const std::string& defvalue)
{
	auto opts=m_options[m_curidx].first;
	opts->add_options()(optname.c_str(),boost::program_options::value<std::string>()->default_value(defvalue),optdesc.c_str());
	addRecordT(optname);
	return *this;
}
Argv& Argv::addTextOptionI(const std::string& optname,const std::string& optdesc,const std::string& impvalue)
{
	auto opts=m_options[m_curidx].first;
	opts->add_options()(optname.c_str(),boost::program_options::value<std::string>()->implicit_value(impvalue),optdesc.c_str());
	addRecordT(optname);
	return *this;
}
Argv& Argv::addTextOptionDI(const std::string& optname,const std::string& optdesc,const std::string& defvalue,const std::string& impvalue)
{
	auto opts=m_options[m_curidx].first;
	opts->add_options()(optname.c_str(),boost::program_options::value<std::string>()->default_value(defvalue)->implicit_value(impvalue),optdesc.c_str());
	addRecordT(optname);
	return *this;
}
std::string Argv::getTextOption(const std::string& optname,const std::string& defaultvalue)
{
	if (validRecordT(optname)) {
		if (PARSE_OK==m_status) {
			if (m_varmap.count(optname)>0) {
				return m_varmap[optname].as<std::string>();
			}
		}
	}
	return defaultvalue;
}
Argv& Argv::addVarTextOption(const std::string& optname,const std::string& optdesc)
{
	auto opts=m_options[m_curidx].first;
	opts->add_options()(optname.c_str(),boost::program_options::value< std::vector<std::string> >(),optdesc.c_str());
	addRecordV(optname);
	return *this;
}
std::vector<std::string> Argv::getVarTextOption(const std::string& optname)
{
	std::vector<std::string> ret;
	if (validRecordV(optname)) {
		if (PARSE_OK==m_status) {
			if (m_varmap.count(optname)>0) {
				ret=m_varmap[optname].as<std::vector< std::string> >();
			}
		}
	}
	return ret;
}
Argv& Argv::addFileOption(const std::string& optname,const std::string& optdesc)
{
	auto opts=m_options[m_curidx].first;
	opts->add_options()(optname.c_str(),boost::program_options::value<std::string>(),optdesc.c_str());
	addRecordF(optname);
	return *this;
}
void Argv::addRecord(const std::string& optname,std::vector<std::string>& collection)
{
	auto pos=optname.find(',');
	if (std::string::npos == pos)
	{
		collection.push_back(optname);
	}
	else
	{
		collection.push_back(optname.substr(0,pos));
	}
}
bool Argv::validRecord(const std::string& optname,std::vector<std::string>& collection)
{
	//return std::count(collection.cbegin(),collection.cend(),optname)>0;
	return std::find(collection.cbegin(),collection.cend(),optname)!=collection.cend();
}
Argv& Argv::setOptionPostion(const std::string& optname,int pos)
{
	auto cpos=optname.find(',');
	std::string name;
	if (std::string::npos == cpos)
	{
		m_optpos.push_back(std::make_pair(optname,pos));
	}
	else
	{
		m_optpos.push_back(std::make_pair(optname.substr(0,cpos),pos));
	}
	return *this;
}
bool Argv::validOption(const std::string& optname)
{
	return (validRecordF(optname) || validRecordV(optname) || validRecordI(optname) || validRecordD(optname) || validRecordT(optname));
}
const std::vector<std::string>& Argv::getUnrecognized() const
{
	return m_unrecognized;
}
