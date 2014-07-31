cmake_minimum_required(VERSION 2.8)
project(projname CXX)
# Setting for Complie
set(CMAKE_CXX_COMPILER "/usr/bin/g++")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall")
## [Start]set options here
option(GDB "switch for debug information for GDB" ON)
option(BOOST "switch for Boost library" ON)
option(BOOSTLOG "switch for Boost.log library" ON)
## [Stop]set options here
set(ROOT_DIR ".")
include("${ROOT_DIR}/boost.cmake" OPTIONAL)
include("${ROOT_DIR}/main.cmake")
# Setting for Link
add_executable(${PROJECT_NAME} ${SOURCE} ${ENTRY})
set(EXECUTABLE_OUTPUT_PATH "${ROOT_DIR}/bin")
