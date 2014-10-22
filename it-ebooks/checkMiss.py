#!/usr/bin/python
import re
import os

def verifyFile(filename):
	pat=re.compile(r'</html>',re.I)
	ret=False
	with open(filename,'r') as fh:
		for line in fh.readlines():
			if pat.search(line):
				ret=True
				break
	return ret

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

def genConf(misslist,filename='curl-conf'):
    rooturl="http://it-ebooks.info/book/"
    outdir="html"
    with open(filename,'w') as fh:
        for i in misslist:
            fh.write("url = \"%s%d/\"\n"%(rooturl,i))
            fh.write("output = \"%s/%04d.html\"\n"%(outdir,i))

def main(pathname='html'):
	miss=[]
	for i in range(getContentLatest(),getLocalLatest(pathname)):
		fullname='%s/%04d.html'%(pathname,i+1)
		if os.path.isfile(fullname):
			if verifyFile(fullname):
				continue
			else:
				miss.insert(0,i+1)
		else:
			miss.append(i+1)
	genConf(miss)

if __name__ == '__main__':
	main()
