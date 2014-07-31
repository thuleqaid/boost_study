cmake_minimum_required(VERSION 2.8)
project(test_projname CXX)
# Setting for Complie
set(CMAKE_CXX_COMPILER "/usr/bin/g++")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall")
## [Start]set options here
option(GDB "switch for debug information for GDB" OFF)
option(BOOSTLOG "switch for Boost.log library" OFF)
## [Stop]set options here
set(ROOT_DIR "..")
include("${ROOT_DIR}/main.cmake")
include("${ROOT_DIR}/boosttest.cmake")

aux_source_directory(. TESTSRC)
# Setting for Link
add_executable(${PROJECT_NAME} ${SOURCE} ${TESTSRC})
