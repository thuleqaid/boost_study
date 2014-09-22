#!/usr/bin/python
import re
import os

def getTitle(filename):
    pat=re.compile(r"<title>(?P<title>.+?)</title>",re.I)
    pat2=re.compile(r"\s+-\s+Free\s+Download\s+eBook\s+-\s+pdf$",re.I)
    title=''
    with open(filename,'r') as fh:
        for line in fh.readlines():
            retpat=pat.search(line)
            if retpat:
                title=retpat.group('title')
                title=pat2.sub("",title)
                break
    return title

def listPath(pathname='html',outfile='contents'):
    fh=open(outfile,'w')
    for fname in sorted(os.listdir(pathname)):
        fullname=os.path.join(pathname,fname)
        if os.path.isfile(fullname):
            name,ext=os.path.splitext(fname)
            if ext.upper()=='.HTML':
                fh.write("%s\t%s\n"%(name,getTitle(fullname)))
    fh.close()

if __name__ == '__main__':
    listPath()
