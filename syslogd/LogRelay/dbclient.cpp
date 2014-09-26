#ifdef QT_NO_DEBUG
#define QT_NO_DEBUG_OUTPUT
#endif
#include "dbclient.h"
#include <QDebug>

DBClient::DBClient(const std::string &ipaddr, const std::string &user, const std::string &passwd, const std::string &dbname, const std::string& port)
    :m_db_addr(ipaddr)
    ,m_db_user(user)
    ,m_db_passwd(passwd)
    ,m_db_name(dbname)
    ,m_db_port(port)
{
    m_db=QSqlDatabase::addDatabase("QMYSQL");
    m_db.setHostName(QString(QByteArray::fromBase64(QByteArray(m_db_addr.c_str()))));
    m_db.setDatabaseName(QString(QByteArray::fromBase64(QByteArray(m_db_name.c_str()))));
    m_db.setUserName(QString(QByteArray::fromBase64(QByteArray(m_db_user.c_str()))));
    m_db.setPassword(QString(QByteArray::fromBase64(QByteArray(m_db_passwd.c_str()))));
    m_db.setPort(QByteArray::fromBase64(QByteArray(m_db_port.c_str())).toInt());
    m_db.open();
}

void DBClient::addRecord(const std::string &pc, const std::string &user, const std::string &action, const std::string &detail)
{
    qDebug()<<"addRecord:"<<pc.c_str()<<":"<<user.c_str()<<":"<<action.c_str()<<":"<<detail.c_str();
    if (!m_db.isOpen())
    {
        if (!m_db.open())
        {
            qDebug()<<"DB open error";
            return;
        }
    }
    QSqlQuery query;
    query.prepare("INSERT INTO vmlog (pc,user,action,detail) VALUES (:pc, :user, :action, :detail)");
    query.bindValue(":pc",pc.c_str());
    query.bindValue(":user",user.c_str());
    query.bindValue(":action",action.c_str());
    query.bindValue(":detail",detail.c_str());
    if (query.exec())
    {
        qDebug()<<"addRecord successed";
    }
    else
    {
        qDebug()<<"addRecord failed";
    }
}
