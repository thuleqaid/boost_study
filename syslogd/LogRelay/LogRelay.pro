#-------------------------------------------------
#
# Project created by QtCreator 2014-09-24T08:43:10
#
#-------------------------------------------------

QT       += core
QT       += network
QT       += sql

QT       -= gui

TARGET = LogRelay
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app


SOURCES += main.cpp \
    syslogd.cpp \
    configloader.cpp \
    messagetoken.cpp \
    dbclient.cpp

HEADERS += \
    syslogd.h \
    configloader.h \
    messagetoken.h \
    dbclient.h

INCLUDEPATH += C:/Boost/include/boost-1_55
