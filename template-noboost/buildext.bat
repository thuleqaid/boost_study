@echo off
set ERROR_COLOR=[31;47m
set NORMAL_COLOR=[0m
mkdir extlibs
cd extlibs
set ROOT_PATH=%cd%
cd ..
if exist extsrc/gflags-2.2.2 (
  mkdir build-gflags
  cd build-gflags
  cmake -G "MinGW Makefiles" -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC -DCMAKE_INSTALL_PREFIX="%ROOT_PATH%" ../extsrc/gflags-2.2.2
  make install
  cd ..
  rmdir /S /Q build-gflags
) else (
  echo %ERROR_COLOR%Not found: extsrc/gflags-2.2.2%NORMAL_COLOR%
)
if exist extsrc/googletest-1.15.2 (
  mkdir build-gtest
  cd build-gtest
  cmake -G "MinGW Makefiles" -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC -DCMAKE_INSTALL_PREFIX="%ROOT_PATH%" ../extsrc/googletest-1.15.2
  make install
  cd ..
  rmdir /S /Q build-gtest
) else (
  echo %ERROR_COLOR%Not found: extsrc/googletest-1.15.2%NORMAL_COLOR%
)
if exist extsrc/glog-0.7.1 (
  mkdir build-glog
  cd build-glog
  cmake -G "MinGW Makefiles" -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC -DCMAKE_PREFIX_PATH="%ROOT_PATH%" -DCMAKE_INSTALL_PREFIX="%ROOT_PATH%" ../extsrc/glog-0.7.1
  make install
  cd ..
  rmdir /S /Q build-glog
) else (
  echo %ERROR_COLOR%Not found: extsrc/glog-0.7.1%NORMAL_COLOR%
)
