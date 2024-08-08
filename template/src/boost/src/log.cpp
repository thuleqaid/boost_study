#ifdef DEBUGLOG

#include <exception>
#include <fstream>

#include <boost/log/attributes.hpp>
#include <boost/log/utility/setup/from_stream.hpp>
#define BOOST_THREAD_PROVIDES_ONCE_CXX11
#include <boost/thread/once.hpp>

#include "boost/log.hpp"

namespace logging = boost::log;
namespace attrs = boost::log::attributes;
namespace src = boost::log::sources;

BOOST_LOG_INLINE_GLOBAL_LOGGER_DEFAULT(test_lg, src::severity_logger_mt< >)

const std::string ConfigLogger::s_config("log.conf");

src::severity_logger_mt< >& ConfigLogger::getLogger()
{
	static src::severity_logger_mt< >& lg = test_lg::get();
	static boost::once_flag once;
	boost::call_once(_init, once);
	return lg;
}

void ConfigLogger::configTemplate()
{
	std::ofstream settings(s_config);
	settings << "# Available Attributes:" << "\n";
	settings << "#   TimeStamp" << "\n";
	settings << "#   Message" << "\n";
	settings << "#   Severity" << "\n";
	settings << "#   ProcessID" << "\n";
	settings << "#   ThreadID" << "\n";
	settings << "#   Scope" << "\n";
	settings << "[Core]" << "\n";
	settings << "DisableLogging=false" << "\n";
	settings << "Filter=\"%Severity% >= 2\"" << "\n";
	settings << "[Sinks.1]" << "\n";
	settings << "Destination=Console" << "\n";
	settings << "Format=\"[%TimeStamp%][Level%Severity%]%Message%\"" << "\n";
	settings << "Filter=\"%Severity% > 3\"" << "\n";
	settings << "[Sinks.2]" << "\n";
	settings << "Destination=TextFile" << "\n";
	settings << "#FileName=\"log_%Y%m%d%H%M%S.txt\"" << "\n";
	settings << "FileName=\"log.txt\"" << "\n";
	settings << "AutoFlush=true" << "\n";
	settings << "Format=\"[%TimeStamp%]<%ProcessID%><%Scope%>%Message%\"" << "\n";
	settings.close();
}

void ConfigLogger::_init()
{
	try
	{
		std::ifstream settings(s_config);
		if (!settings.is_open())
		{
			logging::core::get()->set_logging_enabled(false);
		}
		else {
			// Read the settings and initialize logging library
			logging::init_from_stream(settings);
			// Add some attributes
			logging::core::get()->add_global_attribute("TimeStamp", attrs::local_clock());
			logging::core::get()->add_global_attribute("Scope", attrs::named_scope());
			logging::core::get()->add_global_attribute("ProcessID", attrs::current_process_id());
			logging::core::get()->add_global_attribute("ThreadID", attrs::current_thread_id());
		}
	}
	catch (std::exception& e)
	{
		//e.what();
		logging::core::get()->set_logging_enabled(false);
	}
}
#endif /* DEBUGLOG */

