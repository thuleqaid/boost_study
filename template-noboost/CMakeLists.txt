cmake_minimum_required(VERSION 2.8)

set(PROJECT_NAME MyProject)
project(${PROJECT_NAME} CXX)

# check os
if(WIN32)
  add_definitions(-DWIN32)
else()
  add_definitions(-DUNIX)
endif()

option(GDB "Build with debug info." OFF)
option(GLOG "Build with Google log library." OFF)
option(GFLAGS "Build with Google flags library." OFF)
option(GMOCK "Test with Google mock library." OFF)
option(GTEST "Test with Google test library." OFF)

set(CMAKE_CXX_FLAGS " -std=c++11 -Wall")
if (GDB)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
endif ()

set(ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(MODULE_DIR "${ROOT_DIR}/modules")
set(TEST_ROOT_DIR "${ROOT_DIR}/tests")

# Generate modules list
set(MODULE_LIST )
file(GLOB dirs "${MODULE_DIR}/*")
foreach (item ${dirs})
  if(IS_DIRECTORY ${item})
    string(CONCAT makefile ${item} "/CMakeLists.txt")
    if((EXISTS ${makefile}) AND (NOT (IS_DIRECTORY ${makefile})))
      string(REGEX REPLACE "^.+/([^/]+)$" "\\1" moditem ${item})
      set(MODULE_LIST ${MODULE_LIST} ${moditem})
    endif ()
  endif ()
endforeach ()

include_directories(${ROOT_DIR}/include)
foreach (moditem ${MODULE_LIST})
  add_subdirectory(${MODULE_DIR}/${moditem})
endforeach ()

include("${ROOT_DIR}/extlibs.cmake")
add_executable(${PROJECT_NAME} main.cpp)
if (EXTLIBS)
  target_link_libraries(${PROJECT_NAME} ${EXTLIBS})
endif ()

foreach (moditem ${MODULE_LIST})
  target_link_libraries(${PROJECT_NAME} ${moditem})
endforeach ()

################################
# Document
################################
find_package(Doxygen)
if(DOXYGEN_FOUND)
    set(doxyfile_in ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in)
    set(doxyfile ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)
    configure_file(${doxyfile_in} ${doxyfile} @ONLY)
    add_custom_target(doc
        COMMAND ${DOXYGEN_EXECUTABLE} ${doxyfile}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Generating API documentation with Doxygen"
        VERBATIM)
endif()

################################
# Testing
################################
if (GMOCK OR GTEST)
  enable_testing()

  foreach (moditem ${MODULE_LIST})
    aux_source_directory(${TEST_ROOT_DIR}/${moditem}/src srcfiles)
    add_executable(test_${moditem} ${srcfiles})
    target_include_directories(test_${moditem} PRIVATE
                                               ${TEST_ROOT_DIR}/${moditem}/inc
                                               ${MODULE_DIR}/${moditem}/inc)
    target_link_libraries(test_${moditem} ${MODULE_LIST})
    if (EXTLIBS)
      target_link_libraries(${PROJECT_NAME} ${EXTLIBS})
    endif ()
    if (GMOCK)
      target_link_libraries(test_${moditem} gmock gmock_main)
    endif ()
    if (GTEST)
      target_link_libraries(test_${moditem} gtest gtest_main)
    endif ()
    add_test(NAME Test_${moditem} COMMAND test_${moditem})
  endforeach ()
endif()
