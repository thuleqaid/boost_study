cmake_minimum_required(VERSION 2.8)

# Use folder name as the project name
string(REGEX REPLACE "^.+/([^/]+)$" "\\1" PROJECT_NAME ${CMAKE_CURRENT_SOURCE_DIR})

project(${PROJECT_NAME} CXX)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/inc)
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/src srcfiles)

add_library(${PROJECT_NAME} ${srcfiles})
