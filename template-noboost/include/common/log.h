#ifndef _LOG_H_
#define _LOG_H_

#ifdef ENABLE_GLOG
#include <glog/logging.h>
/* GLOG命令行参数（Windows下不能直接使用，需要设置环境变更GLOG_xxx）
   -alsologtoemail (log messages go to these email addresses in addition to
   logfiles) type: string default: ""
   -alsologtostderr (log messages go to stderr in addition to logfiles)
   type: bool default: false
   -colorlogtostderr (color messages logged to stderr (if supported by
   terminal)) type: bool default: false
   -colorlogtostdout (color messages logged to stdout (if supported by
   terminal)) type: bool default: false
   -drop_log_memory (Drop in-memory buffers of log contents. Logs can grow
   very quickly and they are rarely read before they need to be evicted from
   memory. Instead, drop them from memory as soon as they are flushed to
   disk.) type: bool default: true
   -log_backtrace_at (Emit a backtrace when logging at file:linenum.)
   type: string default: ""
   -log_dir (If specified, logfiles are written into this directory instead of
   the default logging directory.) type: string default: ""
   -log_file_header (Write the file header at the start of each log file)
   type: bool default: true
   -log_link (Put additional links to the log files in this directory)
   type: string default: ""
   -log_prefix (Prepend the log prefix to the start of each log line)
   type: bool default: true
   -log_utc_time (Use UTC time for logging.) type: bool default: false
   -log_year_in_prefix (Include the year in the log prefix) type: bool
   default: true
   -logbuflevel (Buffer log messages logged at this level or lower (-1 means
   don't buffer; 0 means buffer INFO only; ...)) type: int32 default: 0
   -logbufsecs (Buffer log messages for at most this many seconds) type: int32
   default: 30
   -logcleansecs (Clean overdue logs every this many seconds) type: int32
   default: 300
   -logemaillevel (Email log messages logged at this level or higher (0 means
   email all; 3 means email FATAL only; ...)) type: int32 default: 999
   -logfile_mode (Log file mode/permissions.) type: int32 default: 436
   -logmailer (Mailer used to send logging email) type: string default: ""
   -logtostderr (log messages go to stderr instead of logfiles) type: bool
   default: false
   -logtostdout (log messages go to stdout instead of logfiles) type: bool
   default: false
   -max_log_size (approx. maximum log file size (in MB). A value of 0 will be
   silently overridden to 1.) type: uint32 default: 1800
   -minloglevel (Messages logged at a lower level than this don't actually get
   logged anywhere) type: int32 default: 0
   -stderrthreshold (log messages at or above this level are copied to stderr
   in addition to logfiles.  This flag obsoletes --alsologtostderr.)
   type: int32 default: 2
   -stop_logging_if_full_disk (Stop attempting to log to disk if the disk is
   full.) type: bool default: false
   -symbolize_stacktrace (Symbolize the stack trace in the tombstone)
   type: bool default: true
   -timestamp_in_logfile_name (put a timestamp at the end of the log file
   name) type: bool default: true
   -v (Show all VLOG(m) messages for m <= this. Overridable by --vmodule.)
   type: int32 default: 0
   -vmodule (per-module verbose level. Argument is a comma-separated list of
   <module name>=<log level>. <module name> is a glob pattern, matched
   against the filename base (that is, name ignoring .cc/.h./-inl.h). <log
   level> overrides any value given by --v.) type: string default: ""
*/
#define EOL ""
#else
#include <iostream>
#if defined(COMMON_LOG_OUTPUT_TO_STDERR)
#define LOG_OUTPUT_NULL false
#else
#define LOG_OUTPUT_NULL true
#endif
#define LOG(Lvl) if (LOG_OUTPUT_NULL) {} else std::cerr
namespace google {
  void InitGoogleLogging(const char* argv0);
  void ShutdownGoogleLogging();
}
#define EOL std::endl;
#endif

#endif /* _LOG_H_ */
