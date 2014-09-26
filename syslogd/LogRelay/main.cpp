#include <QCoreApplication>
#include "syslogd.h"
#include <windows.h>
#include <iostream>

int main(int argc, char *argv[])
{
    if (argc==2 && strcmp(argv[1],"-h")==0)
    {
        char szPath[MAX_PATH]={0};
        STARTUPINFO si;
        PROCESS_INFORMATION pi;
        ZeroMemory(&si,sizeof(si));
        si.cb=sizeof(si);
        ZeroMemory(&pi,sizeof(pi));
        GetModuleFileName(NULL,(LPWCH)szPath,MAX_PATH);
        if (!CreateProcess(NULL,				// No module name (use command line)
                           (LPWSTR)	szPath,		// Comand line
                           NULL,				// Process handle not inheritable
                           NULL,				// Thread handle not inheritable
                           FALSE,				// Set handle inheritance to FALSE
                           CREATE_NO_WINDOW,	// No creation flag
                           NULL,				// Use parent's environment block
                           NULL,				// Use parent's starting directory
                           &si,					// Pointer to STARTUPINFO struct
                           &pi))				// Pointer to PROCESS_INFORMATION struct
        {
            std::cout<<"Failed"<<std::endl;
        }
        return 0;
    }
    QCoreApplication::addLibraryPath("./plugins");
    QCoreApplication a(argc, argv);
    Syslogd sld;

    return a.exec();
}
