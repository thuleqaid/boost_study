#!/usr/bin/python
import re
import os
import sys
import urllib2

def getContentLatest(pathname='contents'):
    if not os.path.isfile(pathname):
        return 0
    fh=open(pathname,'r')
    line=fh.readlines()[-1]
    fh.close()
    idx,title=line.split('\t',1)
    return int(idx)

def getLocalLatest(pathname='html'):
    if not os.path.isdir(pathname):
        os.makedirs(pathname)
        return 0
    filelist=os.listdir(pathname)
    if len(filelist)<1:
        return 0
    fname=sorted(filelist,reverse=True)[0]
    name,ext=os.path.splitext(fname)
    return int(name)

def getRemoteLatest():
    pat=re.compile(r"Last Upload eBooks",re.I)
    pat2=re.compile(r'<a\s+href\s*\=\s*\"/book/(?P<no>\d+)/',re.I)
    flag=False
    lastno=''
    fh=urllib2.urlopen("http://it-ebooks.info/")
    for line in fh.readlines():
        if flag:
            retpat=pat2.search(line)
            if retpat:
                lastno=retpat.group('no')
                break
        else:
            if pat.search(line):
                flag=True
    fh.close()
    return int(lastno)

def genConf(startidx,stopidx,filename='curl-conf'):
    rooturl="http://it-ebooks.info/book/"
    outdir="html"
    with open(filename,'w') as fh:
        for i in range(startidx,stopidx+1):
            fh.write("url = \"%s%d/\"\n"%(rooturl,i))
            fh.write("output = \"%s/%04d.html\"\n"%(outdir,i))

if __name__ == '__main__':
    if len(sys.argv)>=3:
        no1=int(sys.argv[1])
        no2=int(sys.argv[2])
    else:
        no1=max(getLocalLatest(),getContentLatest())+1
        no2=getRemoteLatest()
    if no1<=no2:
        genConf(no1,no2)
        print("Updates:%d-%d"%(no1,no2))
    else:
        print("No updates")
