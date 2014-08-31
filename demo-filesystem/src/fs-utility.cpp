#include "fs-utility.hpp"
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
/* find executable file in the environment */
static void _saveToList(bfs::path file,std::vector<bfs::path>& vec,const std::string& filename)
{
	if (file.filename().generic_string()==filename)
	{
		vec.push_back(file);
	}
}
void findInPath(const std::string& filename, std::initializer_list<std::string> additions, int count)
{
	std::string env(std::getenv("PATH"));
	const std::string sep(":");
	std::string::size_type pos1(0),pos2;
	std::vector<std::string> pathlist;
	pathlist.reserve(additions.size());
	std::copy(additions.begin(),additions.end(),std::back_inserter(pathlist));
	while(true)
	{
		pos2=env.find(sep,pos1);
		if (std::string::npos==pos2)
		{
			if (env.size()-pos1>0)
			{
				pathlist.push_back(env.substr(pos1));
			}
			break;
		}
		else
		{
			if (pos2-pos1>0)
			{
				pathlist.push_back(env.substr(pos1,pos2-pos1));
			}
			pos1=pos2+1;
		}
	}
	std::copy(pathlist.cbegin(),pathlist.cend(),std::ostream_iterator<std::string>(std::cout,"\n"));
	std::vector<bfs::path> foundlist;
	for (auto &item:pathlist)
	{
		walk(bfs::path(item),std::bind(_saveToList,std::placeholders::_1,std::ref(foundlist),filename),false);
		if ((count>0) && (foundlist.size()>=count))
		{
			break;
		}
	}
	std::copy(foundlist.cbegin(),foundlist.cend(),std::ostream_iterator<bfs::path>(std::cout,"\n"));
}
