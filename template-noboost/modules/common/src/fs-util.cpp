#include <iostream>
#include "common/fs-util.h"

VD makedirs(const bfs::path& inpath)
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
static VD _saveToList(const bfs::path& file,std::vector<bfs::path>& vec,const std::string& filename)
{
    if (file.filename().generic_string()==filename)
    {
        vec.push_back(file);
    }
}

VD findInPath(const std::string& filename, std::initializer_list<std::string> additions, std::vector<bfs::path>& result, ISIZE count)
{
  std::string env(std::getenv("PATH"));
#ifdef WIN32
  const std::string sep(";");
#else
  const std::string sep(":");
#endif
  std::string::size_type pos1(0),pos2;
  std::vector<std::string> pathlist;
  pathlist.reserve(additions.size());
  std::copy(additions.begin(),additions.end(),std::back_inserter(pathlist));
  while(TRUE) {
    pos2=env.find(sep,pos1);
    if (std::string::npos==pos2) {
      if (env.size()-pos1>0) {
        pathlist.push_back(env.substr(pos1));
      }
      break;
    } else {
      if (pos2-pos1>0) {
        pathlist.push_back(env.substr(pos1,pos2-pos1));
      }
      pos1=pos2+1;
    }
  }
  // std::copy(pathlist.cbegin(),pathlist.cend(),std::ostream_iterator<std::string>(std::cout,"\n"));
  for (auto &item:pathlist) {
    walk(bfs::path(item),std::bind(_saveToList,std::placeholders::_1,std::ref(result),filename),FALSE);
    if ((count>0) && (result.size()-count>=0)) {
      break;
    }
  }
}

#ifdef ENABLE_UCHARDET
#include <fstream>
#include <uchardet/uchardet.h>
std::string detect_coding(const bfs::path& fpath)
{
  std::string result;
  std::ifstream fp;
  fp.open(fpath, std::ios::in | std::ios::binary);
  if (fp.is_open()) {
    uchardet_t ud = uchardet_new();
    char buffer[1024];
    while (!fp.eof()) {
      fp.read(buffer, 1024);
      uchardet_handle_data(ud, buffer, fp.gcount());
    }
    uchardet_data_end(ud);
    fp.close();
    result += uchardet_get_charset(ud);
  }
  return result;
}
#endif
