#ifndef DEBUGLOG
	#define LOG_DEFINE_VAR
#endif /* DEBUGLOG */
#include "log.hpp"
#ifdef DEBUGLOG
	#include <vector>
	#include <utility>
	#include <boost/log/utility/setup/console.hpp>
	#include <boost/log/utility/setup/file.hpp>
	namespace logging=boost::log;
#endif /* DEBUGLOG */

#ifdef DEBUGLOG
static logging::trivial::severity_level loglevel(E_LOGLEVEL level)
{
	const std::vector<std::pair<E_LOGLEVEL,logging::trivial::severity_level>> table={
		{LEVEL_TRACE,logging::trivial::trace},
		{LEVEL_DEBUG,logging::trivial::debug},
		{LEVEL_INFO,logging::trivial::info},
		{LEVEL_WARNING,logging::trivial::warning},
		{LEVEL_ERROR,logging::trivial::error},
		{LEVEL_FATAL,logging::trivial::fatal},
	};
	logging::trivial::severity_level boostlevel=logging::trivial::trace;
	for (auto &elem:table)
	{
		if (elem.first==level) {
			boostlevel=elem.second;
			break;
		}
	}
	return boostlevel;
}
#endif /* DEBUGLOG */

void loginit(E_LOGLEVEL eloglevel, std::string filename, bool console)
{
#ifdef DEBUGLOG
	logging::core::get()->set_filter
	(
		logging::trivial::severity >= loglevel(eloglevel)
	);
	if (!filename.empty())
	{
		logging::add_file_log(filename);
		if (console) {
			logging::add_console_log();
		}
	}
#endif /* DEBUGLOG */
}

