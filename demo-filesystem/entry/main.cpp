#include "log.hpp"
#include "argv.hpp"
#include "fs-utility.hpp"

void item_action(const bfs::path& ipath)
{
	/* use file_status instead of is_xxx */
	bfs::file_status sts=bfs::status(ipath);
	/* status_error, file_not_found, regular_file, directory_file,
	 * symlink_file, block_file, character_file, fifo_file, socket_file,
	 * type_unknown
	 */
	if (sts.type()==bfs::regular_file)
	{
		std::cout<<ipath.generic_string()<<"\t"<<bfs::file_size(ipath)<<std::endl;
	}
	else if (sts.type()==bfs::directory_file)
	{
		std::cout<<ipath.generic_string()<<std::endl;
	}
	else
	{
		std::cout<<ipath.generic_string()<<std::endl;
	}
}
int main(int argc, char **argv)
{
	loginit(LEVEL_TRACE);
#if 0
	/* parse command line */
	std::string indir;
	Argv opts;
	opts.addBoolOption("recusive,r","recursive the directory");
	opts.startGroup("Hidden",false);
	opts.addTextOption("inputdir,d","directory for scan").setOptionPostion("inputdir,d",1);
	opts.stopGroup();
	if (!opts.parse(argc,argv))
	{
		/* command options parsing error */
		opts.showHelp(std::cout);
		LOG(error)<< "Input error";
		return 1;
	}
	else
	{
		indir=opts.getTextOption("inputdir","");
	}
	if (indir.size()<1)
	{
		/* inputdir isnot specified */
		opts.showHelp(std::cout,true);
		LOG(error)<< "Directory must be specified";
		return 1;
	}
	LOG(trace)<< "Current Path:"<<bfs::current_path().generic_string();
	LOG(trace)<< "Input directory:"<<indir;

	bfs::path p(indir);
	bfs::path fullp;
	/* checek input directory */
	if (!bfs::exists(p))
	{
		LOG(error)<<"Not exists";
		return 1;
	}
	else
	{
		if (!bfs::is_directory(p))
		{
			LOG(error)<<"Not a directory";
			return 1;
		}
		else
		{
			/* bfs::absolute will remain '..' or '.' */
			fullp=bfs::canonical(p);
			LOG(trace)<<"Full path:"<<fullp.generic_string();
		}
	}

	/* list files */
	walk(fullp,item_action,opts.getBoolOption("recusive"));

	/* generate a unique filename, used for temperary file */
	std::cout<<bfs::unique_path().generic_string()<<std::endl;

	/* make dir */
	bfs::path tmpfile("temp/abc/def");
	/* path.parent_path() must exist for bfs::create_directory(path) */
	/* makedirs(path) will call create_directory() repeatly until path is created */
	makedirs(tmpfile);
	/* create a temperary file */
	tmpfile/=bfs::unique_path();
	LOG(trace)<<tmpfile.generic_string();
	std::ofstream ofs(tmpfile.generic_string());
	ofs<<"test\n";
	ofs.close();
	/* remove directory */
	bfs::remove_all("temp");
	/* other file operation:
	 * copy, copy_directory, copy_file, copy_symlink
	 *   copy will automaticall choose copy_directory/copy_file/copy_symlink
	 * remove, remove_all
	 *   remove for file, remove_all for directory
	 * rename
	 */
#else
	findInPath("vim",{});
#endif
	return 0;
}
