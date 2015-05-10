/* Usage:
 * 1. create an instance
 * 2. add groups/options
 *    options between startGroup(groupdesc) and stopGroup() will in the group "groupdesc"
 *    options outside startGroup(groupdesc) and stopGroup() will in the default group
 *    startGroup(groupdesc) will automatically stop the last group
 *    option types:
 *      (1) Bool
 *      (2) Integer
 *      (3) Decimal
 *      (4) Text
 *      (5) VarText(array of text)
 *      (6) File
 *      (2)~(4):
 *        addXXXOption(opt-name,opt-desc)
 *        addXXXOptionD(opt-name,opt-desc,default-value)
 *        addXXXOptionI(opt-name,opt-desc,implicit-value)
 *        addXXXOptionDI(opt-name,opt-desc,default-value,implicit-value)
 *        getXXXOption(optname,default-value)
 *      (1),(5):
 *        addXXXOption(opt-name,opt-desc)
 *        getXXXOption(optname)
 *      (6):
 *        addXXXOption(opt-name,opt-desc)
 *      *XXX is option type
 * 3. set option's position
 *    example:
 *      archiver --compression=9 --out-file=outfile1 --out-file=outfile2 --input-file=/etc/passwd
 *    if setOptionPostion("input-file",-1) or setOptionPostion("input-file",1):
 *      archiver --compression=9 --out-file=outfile1 --out-file=outfile2 /etc/passwd
 *    if setOptionPostion("output-file",2).setOptionPostion("input-file",-1):
 *      archiver --compression=9 outfile1 outfile2 /etc/passwd
 * 4. parse command line
 *    first parse the command line and record unrecognized options
 *    if any File option is specified, parse the file as a config file
 * 5. show help message
 *    showHelp() function will show help messages and return true
 *      if "-h" is specified or encounter parse exception
 *    otherwise, it will simply return false
 * 6. get options and unrecognized options
 *
 */
#ifndef __ARGV_HPP__
#define __ARGV_HPP__
#include <boost/program_options.hpp>
#include <string>
#include <vector>
#include <memory>
#include <utility>
#include <iostream>
#include <fstream>

class Argv
{
	public:
		Argv(const std::string& defaultdesc="Allowed options",bool helpopt=true,const std::string& helpdesc="produce this help");
		~Argv();
		bool parse(int argc,char* argv[]);
		void startGroup(const std::string& groupdesc="",bool visible=true);
		void stopGroup();
		bool showHelp(std::ostream& os, bool force=false);
		Argv& addBoolOption(const std::string& optname,const std::string& optdesc);
		bool getBoolOption(const std::string& optname);
		Argv& addIntegerOption(const std::string& optname,const std::string& optdesc);
		Argv& addIntegerOptionD(const std::string& optname,const std::string& optdesc,long defvalue);
		Argv& addIntegerOptionI(const std::string& optname,const std::string& optdesc,long impvalue);
		Argv& addIntegerOptionDI(const std::string& optname,const std::string& optdesc,long defvalue,long impvalue);
		long getIntegerOption(const std::string& optname,long defaultvalue=0);
		Argv& addDecimalOption(const std::string& optname,const std::string& optdesc);
		Argv& addDecimalOptionD(const std::string& optname,const std::string& optdesc,double defvalue);
		Argv& addDecimalOptionI(const std::string& optname,const std::string& optdesc,double impvalue);
		Argv& addDecimalOptionDI(const std::string& optname,const std::string& optdesc,double defvalue,double impvalue);
		double getDecimalOption(const std::string& optname,double defaultvalue=0);
		Argv& addTextOption(const std::string& optname,const std::string& optdesc);
		Argv& addTextOptionD(const std::string& optname,const std::string& optdesc,const std::string& defvalue);
		Argv& addTextOptionI(const std::string& optname,const std::string& optdesc,const std::string& impvalue);
		Argv& addTextOptionDI(const std::string& optname,const std::string& optdesc,const std::string& defvalue,const std::string& impvalue);
		std::string getTextOption(const std::string& optname,const std::string& defaultvalue="");
		Argv& addVarTextOption(const std::string& optname,const std::string& optdesc);
		std::vector<std::string> getVarTextOption(const std::string& optname);
		Argv& addFileOption(const std::string& optname,const std::string& optdesc);
		Argv& setOptionPostion(const std::string& optname,int pos);
		const std::vector<std::string>& getUnrecognized() const;
	private:
		enum ParseStatus {
			PARSE_INIT,
			PARSE_OK,
			PARSE_NG,
		};
		ParseStatus m_status;
		std::vector< std::pair<std::shared_ptr<boost::program_options::options_description>,bool> > m_options;
		int m_curidx;
#ifdef BOOST_PO
		boost::program_options::variables_map m_varmap;
#endif
		std::vector<std::string> m_optseti;
		std::vector<std::string> m_optsetd;
		std::vector<std::string> m_optsett;
		std::vector<std::string> m_optsetv;
		std::vector<std::string> m_optsetf;
		std::vector< std::pair<std::string,int> > m_optpos;
		std::vector<std::string> m_unrecognized;
	protected:
		bool validOption(const std::string& optname);
		void addRecord(const std::string& optname,std::vector<std::string>& collection);
		bool validRecord(const std::string& optname,std::vector<std::string>& collection);
		void addRecordI(const std::string& optname) { addRecord(optname,m_optseti); }
		bool validRecordI(const std::string& optname) { return validRecord(optname,m_optseti); }
		void addRecordD(const std::string& optname) { addRecord(optname,m_optsetd); }
		bool validRecordD(const std::string& optname) { return validRecord(optname,m_optsetd); }
		void addRecordT(const std::string& optname) { addRecord(optname,m_optsett); }
		bool validRecordT(const std::string& optname) { return validRecord(optname,m_optsett); }
		void addRecordV(const std::string& optname) { addRecord(optname,m_optsetv); }
		bool validRecordV(const std::string& optname) { return validRecord(optname,m_optsetv); }
		void addRecordF(const std::string& optname) { addRecord(optname,m_optsetf); }
		bool validRecordF(const std::string& optname) { return validRecord(optname,m_optsetf); }
};

#endif /* __ARGV_HPP__ */
