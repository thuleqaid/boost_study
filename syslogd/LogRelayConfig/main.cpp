#include "dialog.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication::addLibraryPath("./plugins");
    QApplication a(argc, argv);
    LogRelayConfig w;
    w.show();

    return a.exec();
}
