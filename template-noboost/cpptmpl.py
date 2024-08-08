# -*- coding:utf-8 -*-
import os
import sys
import re
import collections
import datetime


class NewModule():
    TmplInfo = collections.namedtuple(
        'TmplInfo', ['destpath', 'tmplpath', 'raw', 'dynamic'])
    tmplinfo = (
        (  # Global files
            TmplInfo(
                destpath='include/basemodule/modulelist.h',
                tmplpath='global_inc.tmpl',
                raw=True,
                dynamic=True),
            TmplInfo(
                destpath='modules/basemodule/src/modulelist.cpp',
                tmplpath='global_src.tmpl',
                raw=True,
                dynamic=True),
        ),
        (  # Module files
            TmplInfo(
                destpath='include/{MODNAME_LOWER}/{MODNAME_LOWER}.h',
                tmplpath='out_inc.tmpl',
                raw=False,
                dynamic=False),
            TmplInfo(
                destpath='modules/{MODNAME_LOWER}/CMakeLists.txt',
                tmplpath='CMakeLists.tmpl',
                raw=True,
                dynamic=False),
            TmplInfo(
                destpath='modules/{MODNAME_LOWER}/inc/{MODNAME_LOWER}_inner.h',
                tmplpath='in_inc.tmpl',
                raw=False,
                dynamic=True),
            TmplInfo(
                destpath='modules/{MODNAME_LOWER}/src/{MODNAME_LOWER}.cpp',
                tmplpath='in_src.tmpl',
                raw=False,
                dynamic=True),
        ),
        (  # SubModule Files
            TmplInfo(
                destpath='modules/{MODNAME_LOWER}/inc/{MODNAME_LOWER_ABBREV}{SUBMODNAME_LOWER}.h',
                tmplpath='sub_inc.tmpl',
                raw=False,
                dynamic=False),
            TmplInfo(
                destpath='modules/{MODNAME_LOWER}/src/{MODNAME_LOWER_ABBREV}{SUBMODNAME_LOWER}.cpp',
                tmplpath='sub_src.tmpl',
                raw=False,
                dynamic=False),
            TmplInfo(
                destpath='tests/{MODNAME_LOWER}/inc/{MODNAME_LOWER_ABBREV}{SUBMODNAME_LOWER}_mock.h',
                tmplpath='sub_test_inc.tmpl',
                raw=False,
                dynamic=False),
            TmplInfo(
                destpath='tests/{MODNAME_LOWER}/src/{MODNAME_LOWER_ABBREV}{SUBMODNAME_LOWER}.cpp',
                tmplpath='sub_test_src.tmpl',
                raw=False,
                dynamic=False),
        )
    )

    def __init__(self, rootpath='.', tmplpath='.'):
        self._rootpath = os.path.abspath(rootpath)
        self._tmplpath = os.path.abspath(tmplpath)
        self._basicinfo = {}
        self._subinfo = []

    def addModule(self, modname, modname_abbrev, submods):
        self._basicinfo = {
            'DATE': datetime.datetime.now().strftime('%Y/%m/%d'),
            'MODNAME_UPPER': modname.upper(),
            'MODNAME_CAP': modname.capitalize(),
            'MODNAME_LOWER': modname.lower(),
            'MODNAME_UPPER_ABBREV': modname_abbrev.upper(),
            'MODNAME_CAP_ABBREV': modname_abbrev.capitalize(),
            'MODNAME_LOWER_ABBREV': modname_abbrev.lower()
        }
        self._subinfo = []
        for item in submods:
            self._subinfo.append({
                'SUBMODNAME_UPPER': item.upper(),
                'SUBMODNAME_CAP': item.capitalize(),
                'SUBMODNAME_LOWER': item.lower()
            })
        self._addModFiles()
        self._addSubModFiles()

    def _addModFiles(self):
        flag = False
        for item in self.tmplinfo[1]:
            tmplpath = os.path.join(
                self._tmplpath, item.tmplpath.format(**self._basicinfo))
            with open(tmplpath, 'r', encoding='utf-8') as fh:
                tmpldata = fh.read()
            destpath = os.path.join(
                self._rootpath, item.destpath.format(**self._basicinfo))
            destfolder = os.path.dirname(destpath)
            if not os.path.isdir(destfolder):
                os.makedirs(destfolder)
            if not os.path.isfile(destpath):
                flag = True
                with open(destpath, 'w', encoding='utf-8', newline='\n') as fh:
                    if item.raw:
                        fh.write(tmpldata)
                    else:
                        fh.write(tmpldata.format(**self._basicinfo))

        if flag:  # new module
            pat = re.compile(
                r'/\*\s+TAG-INSERT-(?P<pos>START|END)#(?P<name>\S+)\s+\*/')
            tmpl_modid1 = '	MODID_{MODNAME_UPPER} = MODID_START,\n'
            tmpl_modid2 = '	MODID_{MODNAME_UPPER},\n'
            tmpl_include = '#include "{MODNAME_LOWER}/{MODNAME_LOWER}.h"\n'
            tmpl_modulelist = '	mods[E_MODID::MODID_{MODNAME_UPPER}] = new {MODNAME_CAP}();\n'
            for item in self.tmplinfo[0]:
                if item.dynamic:
                    destpath = os.path.join(
                        self._rootpath, item.destpath.format(**self._basicinfo))
                    with open(destpath, 'r', encoding='utf-8') as fh:
                        startpos = -1
                        newlines = []
                        for lineidx, line in enumerate(fh.readlines()):
                            patret = pat.search(line)
                            if patret:
                                if patret.group('pos') == 'START':
                                    startpos = lineidx
                                elif patret.group('pos') == 'END':
                                    if patret.group('name') == 'GlobalModId':
                                        if lineidx == startpos + 1:
                                            newlines.append(
                                                tmpl_modid1.format(**self._basicinfo))
                                        else:
                                            newlines.append(
                                                tmpl_modid2.format(**self._basicinfo))
                                    elif patret.group('name') == 'GlobalInclude':
                                        newlines.append(
                                            tmpl_include.format(**self._basicinfo))
                                    elif patret.group('name') == 'GlobalModuleList':
                                        newlines.append(
                                            tmpl_modulelist.format(**self._basicinfo))
                                    startpos = -1
                            newlines.append(line)
                    with open(destpath, 'w', encoding='utf-8', newline='\n') as fh:
                        fh.writelines(newlines)

    def _addSubModFiles(self):
        newsubs = set()
        for item in self.tmplinfo[2]:
            tmplpath = os.path.join(
                self._tmplpath, item.tmplpath.format(**self._basicinfo))
            with open(tmplpath, 'r', encoding='utf-8') as fh:
                tmpldata = fh.read()
            for subidx, submod in enumerate(self._subinfo):
                destpath = os.path.join(
                    self._rootpath, item.destpath.format(**self._basicinfo, **submod))
                destfolder = os.path.dirname(destpath)
                if not os.path.isdir(destfolder):
                    os.makedirs(destfolder)
                if not os.path.isfile(destpath):
                    newsubs.add(subidx)
                    with open(destpath, 'w', encoding='utf-8', newline='\n') as fh:
                        if item.raw:
                            fh.write(tmpldata)
                        else:
                            fh.write(tmpldata.format(
                                **self._basicinfo, **submod))

        if len(newsubs) > 0:  # new submodule(s)
            newsubs = tuple(newsubs)
            pat = re.compile(
                r'/\*\s+TAG-INSERT-(?P<pos>START|END)#(?P<name>\S+)\s+\*/')
            tmpl_modid1 = '	E_{MODNAME_UPPER_ABBREV}_{SUBMODNAME_UPPER} = MODID_START,\n'
            tmpl_modid2 = '	E_{MODNAME_UPPER_ABBREV}_{SUBMODNAME_UPPER},\n'
            tmpl_include = '#include "{MODNAME_LOWER_ABBREV}{SUBMODNAME_LOWER}.h"\n'
            tmpl_modulelist = '	mods[E_{MODNAME_UPPER}_MODID::E_{MODNAME_UPPER_ABBREV}_{SUBMODNAME_UPPER}] = new {MODNAME_CAP_ABBREV}{SUBMODNAME_CAP}();\n'
            for item in self.tmplinfo[1]:
                if item.dynamic:
                    destpath = os.path.join(
                        self._rootpath, item.destpath.format(**self._basicinfo))
                    with open(destpath, 'r', encoding='utf-8') as fh:
                        startpos = -1
                        newlines = []
                        for lineidx, line in enumerate(fh.readlines()):
                            patret = pat.search(line)
                            if patret:
                                if patret.group('pos') == 'START':
                                    startpos = lineidx
                                elif patret.group('pos') == 'END':
                                    for subidx, subpos in enumerate(newsubs):
                                        if patret.group('name') == 'LocalModId':
                                            if (lineidx == startpos + 1) and subidx == 0:
                                                newlines.append(tmpl_modid1.format(
                                                    **self._basicinfo, **self._subinfo[subpos]))
                                            else:
                                                newlines.append(tmpl_modid2.format(
                                                    **self._basicinfo, **self._subinfo[subpos]))
                                        elif patret.group('name') == 'LocalInclude':
                                            newlines.append(tmpl_include.format(
                                                **self._basicinfo, **self._subinfo[subpos]))
                                        elif patret.group('name') == 'LocalModuleList':
                                            newlines.append(tmpl_modulelist.format(
                                                **self._basicinfo, **self._subinfo[subpos]))
                                    startpos = -1
                            newlines.append(line)
                    with open(destpath, 'w', encoding='utf-8', newline='\n') as fh:
                        fh.writelines(newlines)


if __name__ == '__main__':
    if len(sys.argv) < 4:
        print("{} ModuleName AbbrevModuleName SubModuleName SubModuleName ...".
              format(sys.argv[0]))
        sys.exit(0)
    else:
        xx = NewModule('.', './tmpl')
        xx.addModule(sys.argv[1], sys.argv[2], sys.argv[3:])
