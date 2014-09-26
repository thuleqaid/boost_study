#include "configloader.h"
#include <cstdlib>

#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/xml_parser.hpp>
#include <iostream>

ConfigLoader* ConfigLoader::m_instance;

void ConfigLoader::initialize()
{
    m_log_port=514;
    m_local_name=std::string(std::getenv("computername"));
    m_local_domain=std::string(std::getenv("userdomain"));
    m_local_user=std::string(std::getenv("username"));
    boost::property_tree::ptree pt;
    read_xml("LogRelay.xml",pt);
    m_db_addr=pt.get<std::string>("mysql.ip");
    m_db_port=pt.get<std::string>("mysql.port");
    m_db_user=pt.get<std::string>("mysql.username");
    m_db_passwd=pt.get<std::string>("mysql.password");
    m_db_name=pt.get<std::string>("mysql.database");
}
