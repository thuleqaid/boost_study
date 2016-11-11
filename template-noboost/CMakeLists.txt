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

set(CMAKE_CXX_FLAGS "-Wall")
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

add_executable(${PROJECT_NAME} main.cpp)

foreach (moditem ${MODULE_LIST})
  target_link_libraries(${PROJECT_NAME} ${moditem})
endforeach ()

if (MINGW)
  # Copy libstdc++-6.dll to binary dir
  string(REGEX REPLACE "^(.+/)[^/]+$" "\\1libstdc++-6.dll" LIBSTDCXX ${CMAKE_CXX_COMPILER})
  file(COPY ${LIBSTDCXX} DESTINATION ${CMAKE_BINARY_DIR})
endif (MINGW)

################################
# Testing
################################
#if (GOOGLETEST)
#  enable_testing()
#
#  foreach (moditem ${MODULE_LIST})
#    aux_source_directory(${TEST_ROOT_DIR}/${moditem}/src srcfiles)
#    add_executable(test_${moditem} ${srcfiles})
#    target_link_libraries(test_${moditem} gtest gtest_main)
#    target_link_libraries(test_${moditem} ${MODULE_LIST})
#    add_test(NAME Test_${moditem} COMMAND test_${moditem})
#  endforeach ()
#endif()
