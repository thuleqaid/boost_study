cmake_minimum_required(VERSION 2.8)
project(projname CXX)
set(EXECUTABLE_OUTPUT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${ROOT_DIR}/bin")
# check os
if(WIN32)
	add_definitions(-DWIN32)
else()
	add_definitions(-DUNIX)
endif()
# Setting for Complie
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall")
## [Start]set options here
option(GDB "switch for debug information for GDB" ON)
option(BOOST "switch for Boost library" ON)
option(BOOSTLOG "switch for Boost.log library" ON)
option(BOOSTPO "switch for Boost.program_options library" ON)
## [Stop]set options here
set(ROOT_DIR ".")
include("${ROOT_DIR}/boost.cmake" OPTIONAL)
include("${ROOT_DIR}/main.cmake")
# Setting for Link
add_executable(${PROJECT_NAME} ${SOURCE} ${ENTRY})
