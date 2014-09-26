#include "dialog.h"
#include "ui_dialog.h"
#include <string>
#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/xml_parser.hpp>

LogRelayConfig::LogRelayConfig(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::LogRelayConfig)
{
    ui->setupUi(this);
    m_msgbox=new QMessageBox(this);
    m_msgbox->setWindowTitle(windowTitle());
    m_msgbox->setIcon(QMessageBox::Warning);
}

LogRelayConfig::~LogRelayConfig()
{
    delete ui;
}

void LogRelayConfig::onBtnWrite()
{
    if(!ui->chk_passwd->isChecked())
    {
        if(ui->edt_passwd1->text()!=ui->edt_passwd2->text())
        {
            m_msgbox->setText(tr("Passwords donot match"));
            m_msgbox->exec();
            return;
        }
    }
    std::string ip(ui->edt_ip->text().toUtf8().toBase64().data());
    std::string port(ui->edt_port->text().toUtf8().toBase64().data());
    std::string username(ui->edt_user->text().toUtf8().toBase64().data());
    std::string password(ui->edt_passwd1->text().toUtf8().toBase64().data());
    std::string dbname(ui->edt_db->text().toUtf8().toBase64().data());
    boost::property_tree::ptree pt;
    pt.put("mysql.ip",ip);
    pt.put("mysql.port",port);
    pt.put("mysql.username",username);
    pt.put("mysql.password",password);
    pt.put("mysql.database",dbname);
    write_xml("LogRelay.xml",pt);
    m_msgbox->setText(tr("Write Successed"));
    m_msgbox->exec();
}

void LogRelayConfig::onChkPassword(bool status)
{
    ui->edt_passwd2->setDisabled(status);
    if (status)
    {
        ui->edt_passwd1->setEchoMode(QLineEdit::Normal);
    }
    else
    {
        ui->edt_passwd1->setEchoMode(QLineEdit::Password);
        ui->edt_passwd2->setText("");
    }
}

void LogRelayConfig::onEdtPassword2(QString text)
{
    if(ui->edt_passwd1->text()==text)
    {
        ui->edt_passwd2->setStyleSheet("* {background-color:white}");
    }
    else
    {
        ui->edt_passwd2->setStyleSheet("* {background-color:red}");
    }
}
