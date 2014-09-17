#include "seq.hpp"
#include "ptree_xml.hpp"
#include "log.hpp"

SeqNodeSP parseXML(const std::string& filename)
{
	return loadXML<SeqNodeSP>(filename, CreateNode, AppendChild, SetMember);
}

int main(int argc, char **argv)
{
	loginit(LEVEL_TRACE);
	SeqNodeSP node=parseXML("NTV_create.xml");
	node->printTree(std::cout);
	//LOG(trace)<< "trace message";
	//LOG(debug)<< "debug message";
	//LOG(info)<< "info message";
	//LOG(warning)<< "warning message";
	//LOG(error)<< "error message";
	//LOG(fatal)<< "fatal message";
	return 0;
}
