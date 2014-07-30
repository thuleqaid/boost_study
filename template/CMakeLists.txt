cmake_minimum_required(VERSION 2.8)
project(projname CXX)
# Setting for Complie
set(CMAKE_CXX_COMPILER "/usr/bin/g++")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall")
option(GDB "switch for debug information for GDB" ON)
if(GDB)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
endif(GDB)
## [Start]add option and include cmake file here
## [Stop]add option and include cmake file here
# Setting for Source/Header files
set(SRCROOT ".")
#file(GLOB SOURCE ${SRCROOT}/src/*.cpp)
aux_source_directory(${SRCROOT}/src SOURCE)
include_directories(${SRCROOT}/include)
# Setting for Link
add_executable(${PROJECT_NAME} ${SOURCE})
