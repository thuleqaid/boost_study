#ifndef CONFIGLOADER_H
#define CONFIGLOADER_H
#include <string>

class ConfigLoader
{
public:
    static ConfigLoader* sharedInstance()
    {
        if (m_instance==0)
        {
            m_instance=new ConfigLoader();
        }
        return ConfigLoader::m_instance;
    }
    int logPort() const { return m_log_port; }
    const std::string& dbPort() const { return m_db_port; }
    const std::string& dbAddr() const { return m_db_addr; }
    const std::string& dbUser() const { return m_db_user; }
    const std::string& dbPasswd() const { return m_db_passwd; }
    const std::string& dbName() const { return m_db_name; }
    const std::string& localName() const { return m_local_name; }
    const std::string& localDomain() const { return m_local_domain; }
    const std::string& localUser() const { return m_local_user; }

private:
    ConfigLoader() { initialize(); }
    void initialize();
    int m_log_port;
    std::string m_db_port;
    std::string m_db_addr;
    std::string m_db_user;
    std::string m_db_passwd;
    std::string m_db_name;
    std::string m_local_name;
    std::string m_local_domain;
    std::string m_local_user;
    static ConfigLoader* m_instance;
};

#endif // CONFIGLOADER_H
