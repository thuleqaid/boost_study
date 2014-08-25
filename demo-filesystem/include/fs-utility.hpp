#ifndef __FS_UTILITY_HPP__
#define __FS_UTILITY_HPP__
#include <boost/filesystem.hpp>
namespace bfs=boost::filesystem;

typedef void (*WalkAction)(const bfs::path& item);

/* walk throuth the directory */
bool walk(const bfs::path& inpath, WalkAction action, bool recursive=false);
/* make multi-level directory */
void makedirs(const bfs::path& inpath);

#endif /* __FS_UTILITY_HPP__ */
