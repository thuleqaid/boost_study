#ifndef DBCLIENT_H
#define DBCLIENT_H
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QVariant>
#include <string>

class DBClient
{
public:
    DBClient(const std::string& ipaddr,
             const std::string& user,
             const std::string& passwd,
             const std::string& dbname,
             const std::string& port);
    void addRecord(const std::string& pc, const std::string& user, const std::string& action, const std::string& detail);
private:
    std::string m_db_addr;
    std::string m_db_user;
    std::string m_db_passwd;
    std::string m_db_name;
    std::string m_db_port;
    QSqlDatabase m_db;
};

#endif // DBCLIENT_H
