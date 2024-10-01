#ifndef ENABLE_GLOG
#include "common/log.h"
namespace google {
  void InitGoogleLogging(const char* argv0)
  {
  }
  void ShutdownGoogleLogging()
  {
  }
}
#endif
