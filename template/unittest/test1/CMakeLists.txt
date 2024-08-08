cmake_minimum_required(VERSION 2.8)
# Use folder name as the project name
string(REGEX REPLACE "^.+/([^/]+)$" "\\1" PROJECT_NAME ${CMAKE_CURRENT_SOURCE_DIR})
project(${PROJECT_NAME} CXX)
set(ROOT_DIR "../..")
set(TEST_COMMON_DIR "..")
set(EXECUTABLE_OUTPUT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${ROOT_DIR}/bin")
# Setting for Complie
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall")
## [Start]set options here
option(GDB "switch for debug information for GDB" ON)
option(BOOST "switch for Boost library" ON)
option(BOOSTTEST "switch for Boost.test library" ON)
## [Stop]set options here
include("${ROOT_DIR}/boost.cmake" OPTIONAL)
include("${ROOT_DIR}/main.cmake")
include_directories(${TEST_COMMON_DIR}/common)

aux_source_directory(. TESTSRC)
# Setting for Link
add_executable(${PROJECT_NAME} ${SOURCE} ${TESTSRC})
