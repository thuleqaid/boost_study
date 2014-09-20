cmake_minimum_required(VERSION 2.8)
project(caltrans C)

set(ROOT_DIR ".")
# Setting for Link
# Setting for Source/Header files
set(SRCROOT "${ROOT_DIR}")
#file(GLOB SOURCE ${SRCROOT}/src/*.cpp)
aux_source_directory(${SRCROOT}/src SOURCE)
include_directories(${SRCROOT}/include)

add_library(${PROJECT_NAME} ${SOURCE})
