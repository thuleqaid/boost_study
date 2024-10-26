#ifndef __FS_UTIL_H__
#define __FS_UTIL_H__
#include <string>
#include <filesystem>
namespace bfs=std::filesystem;
#include "common/common.h"

/* make multi-level directory */
VD makedirs(const bfs::path& inpath);

/* find executable file in the environment */
VD findInPath(const std::string& filename, std::initializer_list<std::string> additions, std::vector<bfs::path>& result, ISIZE count=-1);

#ifdef ENABLE_UCHARDET
/* detect encoding of text file */
std::string detect_coding(const bfs::path& fpath);
#endif

/* walk throuth the directory */
template<typename WalkAction>
BOOL walk(const bfs::path& inpath, WalkAction action, BOOL recursive)
{
  if (bfs::is_directory(inpath)) {
    if (recursive) {
      for(auto entry=bfs::recursive_directory_iterator(inpath);entry!=bfs::recursive_directory_iterator();++entry) {
        action(entry->path());
      }
    } else {
      for(auto entry=bfs::directory_iterator(inpath);entry!=bfs::directory_iterator();++entry) {
        action(entry->path());
      }
    }
    return TRUE;
  } else {
    return FALSE;
  }
}

#endif /* __FS_UTIL_H__ */
