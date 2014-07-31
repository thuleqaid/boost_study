cmake_minimum_required(VERSION 2.8)
project(test_projname CXX)
# Setting for Complie
set(CMAKE_CXX_COMPILER "/usr/bin/g++")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall")
## [Start]set options here
option(BOOST "switch for Boost library" ON)
option(BOOSTTEST "switch for Boost.test library" ON)
## [Stop]set options here
set(ROOT_DIR "..")
include("${ROOT_DIR}/boost.cmake" OPTIONAL)
include("${ROOT_DIR}/main.cmake")

aux_source_directory(. TESTSRC)
# Setting for Link
add_executable(${PROJECT_NAME} ${SOURCE} ${TESTSRC})
set(EXECUTABLE_OUTPUT_PATH "${ROOT_DIR}/bin")
