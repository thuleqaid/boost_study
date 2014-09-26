#!/usr/local/bin/python
import sys
import socket

class MsgSender(object):
    def __init__(self,port=9999,remoteip=''):
        self.port=port
        self.remoteip=remoteip
    def send(self,strinfo):
        sock=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
        try:
            sock.connect((self.remoteip,self.port))
            sock.sendall(strinfo.encode('utf-8'))
        except socket.error:
            print('error')
        finally:
            sock.close()

if __name__ == '__main__':
    ms=MsgSender(port=514,remoteip="192.168.0.1")
    ms.send("test 1")
    ms.send("test 2")
    ms.send("test 3")
    ms.send("test 4")
