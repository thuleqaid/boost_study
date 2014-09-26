#ifndef SYSLOGD_H
#define SYSLOGD_H

#include <QObject>
#include <QUdpSocket>
#include "messagetoken.h"
#include "configloader.h"
#include "dbclient.h"

class Syslogd : public QObject
{
    Q_OBJECT
public:
    explicit Syslogd(QObject *parent = 0);
    ~Syslogd();

signals:

public slots:
    void dataReceived();

private:
    QUdpSocket *m_socket;
    bool m_status;
    MessageToken m_token;
    ConfigLoader* m_config;
    DBClient *m_db;
    void initSocket();
};

#endif // SYSLOGD_H
