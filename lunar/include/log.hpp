#ifndef __LOG_HPP__
#define __LOG_HPP__
/* Usage:
 * 1. include "log.hpp"
 * 2. call loginit() in the very beginning
 * 3. LOG(trace/debug/info/warning/error/fatal)<< "log message";
 */
#include <string>
#ifdef DEBUGLOG
	#include <boost/log/trivial.hpp>
	#define LOG(x) BOOST_LOG_TRIVIAL(x)
#else /* DEBUGLOG */
	#include <ostream>
	#ifdef LOG_DEFINE_VAR
		std::ostream _NullLog_(0);
	#else /* LOG_DEFINE_VAR */
		extern std::ostream _NullLog_;
	#endif /* LOG_DEFINE_VAR */
	#define LOG(x) _NullLog_
#endif /* DEBUGLOG */

enum E_LOGLEVEL
{
	LEVEL_TRACE,
	LEVEL_DEBUG,
	LEVEL_INFO,
	LEVEL_WARNING,
	LEVEL_ERROR,
	LEVEL_FATAL
};

void loginit(E_LOGLEVEL eloglevel=LEVEL_TRACE, std::string filename="", bool console=true);
#endif
