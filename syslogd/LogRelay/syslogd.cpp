#ifdef QT_NO_DEBUG
#define QT_NO_DEBUG_OUTPUT
#endif
#include "syslogd.h"
#include <QDebug>

Syslogd::Syslogd(QObject *parent) :
    QObject(parent)
  ,m_status(false)
  ,m_token()
{
    m_config=ConfigLoader::sharedInstance();
    m_db=new DBClient(m_config->dbAddr(),
                      m_config->dbUser(),
                      m_config->dbPasswd(),
                      m_config->dbName(),
                      m_config->dbPort());
    initSocket();
}
Syslogd::~Syslogd()
{
    m_socket->close();
    qDebug()<<"Close socket";
}

void Syslogd::dataReceived()
{
    while(m_socket->hasPendingDatagrams())
    {
        QByteArray datagram;
        datagram.resize(m_socket->pendingDatagramSize());
        m_socket->readDatagram(datagram.data(),datagram.size());
        qDebug("Message Received:%s",datagram.data());
        if (m_token.parseMessage(datagram.data()))
        {
            qDebug()<<m_token.action().c_str()<<":"<<m_token.detail().c_str();
            m_db->addRecord(m_config->localName(),
                            m_config->localUser(),
                            m_token.action(),
                            m_token.detail());
        }
        else
        {
            /* for connection test */
            qWarning("Message Received:%s",datagram.data());
        }
    }
}

void Syslogd::initSocket()
{
    m_socket=new QUdpSocket(this);
    m_status=m_socket->bind(m_config->logPort());
    connect(m_socket,SIGNAL(readyRead()),this,SLOT(dataReceived()));
    qDebug()<<"Bind Port["<<m_config->logPort()<<"]:"<<m_status;
}
