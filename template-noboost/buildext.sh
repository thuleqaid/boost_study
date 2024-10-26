mkdir extlibs
cd extlibs
ROOT_PATH=$PWD
cd ..
mkdir build-gflags
cd build-gflags
cmake -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC -DCMAKE_INSTALL_PREFIX="$ROOT_PATH" ../extsrc/gflags-2.2.2
make install
cd ..
mkdir build-gtest
cd build-gtest
cmake -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC -DCMAKE_INSTALL_PREFIX="$ROOT_PATH" ../extsrc/googletest-1.15.2
make install
cd ..
mkdir build-glog
cd build-glog
cmake -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC -DCMAKE_PREFIX_PATH="$ROOT_PATH" -DCMAKE_INSTALL_PREFIX="$ROOT_PATH" ../extsrc/glog-0.7.1
make install
cd ..
mkdir build-uchardet
cd build-uchardet
cmake -DCMAKE_PREFIX_PATH="%ROOT_PATH%" -DCMAKE_INSTALL_PREFIX="%ROOT_PATH%" ../extsrc/uchardet-0.0.8
make install
cd ..
rm -rf build-gflags
rm -rf build-gtest
rm -rf build-glog
rm -rf build-uchardet
