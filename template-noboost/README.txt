Cxx Project Template
1. Architecture
   Executable file is consists of main.cpp and library files(one for each folder in modules folder).
2. How to add one module
   Make a copy of folder in modules folder.
   modules/xxx/inc: in-module header files
   modules/xxx/src: module source files
   include/xxx:     cross-module header files
3. Google Libraries
   https://github.com/google/googletest
   https://github.com/google/glog
   https://github.com/gflags/gflags