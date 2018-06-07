#ifndef __LOG_HPP__
#define __LOG_HPP__
/* Usage:
 * 1.  include "log.hpp"
 * 2a. LOG(loglevel_int, "log message");
 * 2b. LOG_TAG("tagname");
 */
#ifdef DEBUGLOG
	#define LOG(nlvl, msg) BOOST_LOG_SEV((ConfigLogger::getLogger()), nlvl) << msg
	#define LOG_TAG(tag_name) BOOST_LOG_NAMED_SCOPE(tag_name)
	#define LOG_IF(nlvl, condition, msg) if (condition) { LOG(nlvl, msg); }
	#define LOG_TAG_IF(tag_name, condition) if (condition) { LOG_TAG(tag_name); }
#else /* DEBUGLOG */
	#define LOG(nlvl, msg)
	#define LOG_TAG(tag_name)
	#define LOG_IF(nlvl, condition, msg)
	#define LOG_TAG_IF(tag_name, condition)
#endif /* DEBUGLOG */

#ifdef DEBUGLOG
#include <string>
#include <boost/log/common.hpp>
class ConfigLogger
{
	public:
		static boost::log::sources::severity_logger_mt< >& getLogger();
		static void configTemplate();
	private:
		static void _init();
		static const std::string s_config;
};
#endif /* DEBUGLOG */

#endif
