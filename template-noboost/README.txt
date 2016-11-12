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
   Install instructions:(For MinGW in Windows)
      ## make output dir
      mkdir extlibs
      cd extlibs
      set ROOT_PATH=%cd%
      cd ..
      ## download gflags, googletest and glog
      git clone --depth=1 https://github.com/gflags/gflags
      git clone --depth=1 https://github.com/google/googletest
      git clone --depth=1 https://github.com/google/glog
      ## compile gflags
      mkdir build-gflags
      cd build-gflags
      cmake -G "MinGW Makefiles" -DBUILD_STATIC_LIBS=ON -DINSTALL_HEADERS=ON -DINSTALL_SHARED_LIBS=ON -DINSTALL_STATIC_LIBS=ON -DCMAKE_INSTALL_PREFIX="%ROOT_PATH%" ../gflags
      make install
      cd ..
      ## compile googletest
      mkdir build-gtest
      cd build-gtest
      cmake -G "MinGW Makefiles" -Dgtest_disable_pthreads=ON -DCMAKE_INSTALL_PREFIX="%ROOT_PATH%" ../googletest
      make install
      cd ..
      ## compile glog(must after gflags as glog requires gflags)
      mkdir build-glog
      cd build-glog
      cmake -G "MinGW Makefiles" -DCMAKE_PREFIX_PATH="%ROOT_PATH%" -DCMAKE_INSTALL_PREFIX="%ROOT_PATH%" ../glog
      make install
      cd ..
