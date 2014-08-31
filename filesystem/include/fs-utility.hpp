#ifndef __FS_UTILITY_HPP__
#define __FS_UTILITY_HPP__
#include <boost/filesystem.hpp>
namespace bfs=boost::filesystem;

/* make multi-level directory */
void makedirs(const bfs::path& inpath);

/* walk throuth the directory */
template<typename WalkAction>
bool walk(const bfs::path& inpath, WalkAction action, bool recursive)
{
	if (bfs::is_directory(inpath))
	{
		if (recursive)
		{
			for(auto entry=bfs::recursive_directory_iterator(inpath);entry!=bfs::recursive_directory_iterator();++entry)
			{
				action(entry->path());
			}
		}
		else
		{
			for(auto entry=bfs::directory_iterator(inpath);entry!=bfs::directory_iterator();++entry)
			{
				action(entry->path());
			}
		}
		return true;
	}
	else
	{
		return false;
	}
}

/* find executable file in the environment */
void findInPath(const std::string& filename, std::initializer_list<std::string> additions, std::vector<bfs::path>& result, int count=-1);

#endif /* __FS_UTILITY_HPP__ */
