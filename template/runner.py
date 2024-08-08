# -*- coding:utf-8 -*-
import os
import sys
import shutil

def usage(prgname):
    print("Usage: "+prgname+" action [target]")
    print("  action: clean build rebuild")
    print("  target: main test testdir all")
    print("          use 'main' if not specified")
    print("          'testdir': subdirs in unittest except 'common'")

def walktargets(targets):
    cwd = os.getcwd()
    dirs = set()
    if len(targets) > 0:
        if 'main' in targets:
            dirs.add('.')
        elif 'all' in targets:
            dirs.add('.')
    else:
        dirs.add('.')
    os.chdir('unittest')
    for item in os.listdir():
        if item!='common' and os.path.isdir(item):
            if 'test' in targets:
                dirs.add(os.path.join('unittest', item))
            elif 'all' in targets:
                dirs.add(os.path.join('unittest', item))
            elif item in targets:
                dirs.add(os.path.join('unittest', item))
    os.chdir(cwd)
    return list(dirs)

def clean(targets):
    cwd = os.getcwd()
    for item in walktargets(targets):
        os.chdir(item)
        if os.path.isdir('build'):
            shutil.rmtree('build')
        os.chdir(cwd)

def build(targets):
    cwd = os.getcwd()
    for item in walktargets(targets):
        os.chdir(item)
        if os.path.isdir('build'):
            # cd build; make; cd ..
            os.chdir('build')
            os.system('make')
        else:
            # mkdir build; cd build; cmake ..; make; cd ..
            os.mkdir('build')
            os.chdir('build')
            os.system('cmake -G "MinGW Makefiles" ..')
            os.system('make')
        os.chdir(cwd)

def rebuild(targets):
    cwd = os.getcwd()
    for item in walktargets(targets):
        os.chdir(item)
        if os.path.isdir('build'):
            shutil.rmtree('build')
        os.mkdir('build')
        os.chdir('build')
        os.system('cmake -G "MinGW Makefiles" ..')
        os.system('make')
        os.chdir(cwd)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        usage(sys.argv[0])
    else:
        action = sys.argv[1].lower()
        if action == "clean":
            clean(sys.argv[2:])
        elif action == "build":
            build(sys.argv[2:])
        elif action == "rebuild":
            rebuild(sys.argv[2:])
        else:
            usage(sys.argv[0])
