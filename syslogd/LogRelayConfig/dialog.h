#ifndef DIALOG_H
#define DIALOG_H

#include <QDialog>
#include <QMessageBox>

namespace Ui {
class LogRelayConfig;
}

class LogRelayConfig : public QDialog
{
    Q_OBJECT

public:
    explicit LogRelayConfig(QWidget *parent = 0);
    ~LogRelayConfig();

private:
    Ui::LogRelayConfig *ui;
    QMessageBox *m_msgbox;

private slots:
    void onBtnWrite();
    void onChkPassword(bool status);
    void onEdtPassword2(QString text);
};

#endif // DIALOG_H
