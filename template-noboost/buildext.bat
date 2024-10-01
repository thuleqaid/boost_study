mkdir extlibs
cd extlibs
set ROOT_PATH=%cd%
cd ..
mkdir build-gflags
cd build-gflags
cmake -G "MinGW Makefiles" -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC -DCMAKE_INSTALL_PREFIX="%ROOT_PATH%" ../extsrc/gflags-2.2.2
make install
cd ..
mkdir build-gtest
cd build-gtest
cmake -G "MinGW Makefiles" -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC -DCMAKE_INSTALL_PREFIX="%ROOT_PATH%" ../extsrc/googletest-1.15.2
make install
cd ..
mkdir build-glog
cd build-glog
cmake -G "MinGW Makefiles" -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC -DCMAKE_PREFIX_PATH="%ROOT_PATH%" -DCMAKE_INSTALL_PREFIX="%ROOT_PATH%" ../extsrc/glog-0.7.1
make install
cd ..
rmdir /S /Q build-gflags
rmdir /S /Q build-gtest
rmdir /S /Q build-glog
