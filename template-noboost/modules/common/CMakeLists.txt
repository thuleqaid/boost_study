cmake_minimum_required(VERSION 2.8)

# Use folder name as the project name
string(REGEX REPLACE "^.+/([^/]+)$" "\\1" PROJECT_NAME ${CMAKE_CURRENT_SOURCE_DIR})

project(${PROJECT_NAME} CXX)

if (GLOG)
    get_target_property(glog_cxxflags glog::glog INTERFACE_COMPILE_DEFINITIONS)
    add_compile_definitions(${glog_cxxflags})
    get_target_property(glog_includes glog::glog INTERFACE_INCLUDE_DIRECTORIES)
    include_directories(SYSTEM ${glog_includes})
endif ()
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/inc)
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/src srcfiles)

add_library(${PROJECT_NAME} ${srcfiles})
