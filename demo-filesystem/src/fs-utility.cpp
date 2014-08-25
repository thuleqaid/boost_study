#include "fs-utility.hpp"
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

void makedirs(const bfs::path& inpath)
{
	/* path must exist for bfs::canonical(path) */
	bfs::path fpath=bfs::absolute(inpath);
	if (!bfs::is_directory(inpath))
	{
		bfs::path cur;
		for(auto item=fpath.begin();item!=fpath.end();++item)
		{
			/* concatenation */
			cur/=*item;
			if(bfs::is_directory(cur))
			{
				/* in case of '..' and '.' */
				cur=bfs::canonical(cur);
			}
			else
			{
				/* create directory */
				bfs::create_directory(cur);
			}
		}
	}
}
