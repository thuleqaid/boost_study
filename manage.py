#!/usr/bin/python
import argparse
import os
import shutil

def parse_args():
	parser=argparse.ArgumentParser(description='CXX project maker')
	parser.add_argument('--nolog',action='store_true',dest='boostlog',help='new project with Boost.log')
	parser.add_argument('--notest',action='store_true',dest='boosttest',help='new project with Boost.test')
	parser.add_argument('projname',help='project name')
	args=parser.parse_args()
	outdict={}
	outdict['path'],outdict['name']=os.path.split(os.path.abspath(args.projname))
	outdict['log']=args.boostlog
	outdict['test']=args.boosttest
	return outdict

def projmaker(info):
	dir_template=os.path.abspath('template')
	if not os.path.isdir(dir_template):
		print('Error: template dir not found')
		return
	if not os.path.isdir(info['path']):
		print("Error: dir[%s] not exists"%(info['path'],))
		return
	dir_newproj=os.path.join(info['path'],info['name'])
	if os.path.isdir(dir_newproj):
		print("Error: dir[%s] already exists"%(dir_newproj,))
		return
	shutil.copytree(dir_template,dir_newproj,ignore=make_ignorefunc(dir_template,info['log'],info['test']))

def make_ignorefunc(basedir,flag_log,flag_test):
	loglist=('boostlog.cmake','include/log.hpp','src/log.cpp')
	testlist=('boosttest.cmake','unittest',)
	ignorelist=[]
	if flag_log:
		for item in loglist:
			ignorelist.append(os.path.join(basedir,item))
	if flag_test:
		for item in testlist:
			ignorelist.append(os.path.join(basedir,item))
	def ignorefunc(src,info):
		if len(ignorelist)<1:
			return ()
		else:
			outlist=[]
			for item in info:
				fullpath=os.path.join(src,item)
				if fullpath in ignorelist:
					outlist.append(item)
			return outlist
	return ignorefunc

if __name__ == '__main__':
	args=parse_args()
	projmaker(args)
