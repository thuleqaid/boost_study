set(EXTLIBS)

set(GOOGLE_LIBS_ROOT "${ROOT_DIR}/extlibs")
set(_copy_dll OFF)
set(_find_gflags OFF)
set(_find_glog OFF)
set(_find_gtest OFF)
set(_find_gmock OFF)
set(_find_uchardet OFF)
set(_link_gflags OFF)
set(_link_glog OFF)
set(_link_uchardet OFF)

if (GFLAGS)
  set(_copy_dll ON)
  set(_find_gflags ON)
  set(_link_gflags ON)
endif ()
if (GLOG)
  set(_copy_dll ON)
  set(_find_gflags ON)
  set(_find_glog ON)
  set(_link_gflags OFF)
  set(_link_glog ON)
endif ()
if (GTEST)
  set(_copy_dll ON)
  set(_find_gtest ON)
endif ()
if (GMOCK)
  set(_copy_dll ON)
  set(_find_gtest ON)
  set(_find_gmock ON)
endif ()
if (UCHARDET)
  set(_copy_dll ON)
  set(_find_uchardet ON)
  set(_link_uchardet ON)
endif ()

if (_find_gflags)
  set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "${GOOGLE_LIBS_ROOT}")
  add_definitions(-DENABLE_GFLAGS)
  find_package(gflags REQUIRED)
endif ()
if (_find_glog)
  set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "${GOOGLE_LIBS_ROOT}/lib/cmake/glog")
  add_definitions(-DENABLE_GLOG)
  find_package(glog REQUIRED)
endif ()
if (_find_gtest)
  add_library(gtest UNKNOWN IMPORTED)
  add_library(gtest_main UNKNOWN IMPORTED)
  if (MSVC)
    set_target_properties(gtest PROPERTIES
      IMPORTED_LOCATION ${GOOGLE_LIBS_ROOT}/lib/gtest.lib
      INTERFACE_INCLUDE_DIRECTORIES "${GOOGLE_LIBS_ROOT}/include"
    )
    set_target_properties(gtest_main PROPERTIES
      IMPORTED_LOCATION ${GOOGLE_LIBS_ROOT}/lib/gtest_main.lib
      INTERFACE_INCLUDE_DIRECTORIES "${GOOGLE_LIBS_ROOT}/include"
    )
  else ()
    set_target_properties(gtest PROPERTIES
      IMPORTED_LOCATION ${GOOGLE_LIBS_ROOT}/lib/libgtest.a
      INTERFACE_INCLUDE_DIRECTORIES "${GOOGLE_LIBS_ROOT}/include"
    )
    set_target_properties(gtest_main PROPERTIES
      IMPORTED_LOCATION ${GOOGLE_LIBS_ROOT}/lib/libgtest_main.a
      INTERFACE_INCLUDE_DIRECTORIES "${GOOGLE_LIBS_ROOT}/include"
    )
  endif ()
  add_definitions(-DENABLE_GTEST)
endif ()
if (_find_gmock)
  add_library(gmock UNKNOWN IMPORTED)
  add_library(gmock_main UNKNOWN IMPORTED)
  if (MSVC)
    set_target_properties(gmock PROPERTIES
      IMPORTED_LOCATION ${GOOGLE_LIBS_ROOT}/lib/gmock.lib
      INTERFACE_INCLUDE_DIRECTORIES "${GOOGLE_LIBS_ROOT}/include"
    )
    set_target_properties(gmock_main PROPERTIES
      IMPORTED_LOCATION ${GOOGLE_LIBS_ROOT}/lib/gmock_main.lib
      INTERFACE_INCLUDE_DIRECTORIES "${GOOGLE_LIBS_ROOT}/include"
    )
  else ()
    set_target_properties(gmock PROPERTIES
      IMPORTED_LOCATION ${GOOGLE_LIBS_ROOT}/lib/libgmock.a
      INTERFACE_INCLUDE_DIRECTORIES "${GOOGLE_LIBS_ROOT}/include"
    )
    set_target_properties(gmock_main PROPERTIES
      IMPORTED_LOCATION ${GOOGLE_LIBS_ROOT}/lib/libgmock_main.a
      INTERFACE_INCLUDE_DIRECTORIES "${GOOGLE_LIBS_ROOT}/include"
    )
  endif ()
  add_definitions(-DENABLE_GTEST)
  add_definitions(-DENABLE_GMOCK)
endif ()
if (_find_uchardet)
  set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "${GOOGLE_LIBS_ROOT}/lib/cmake/uchardet")
  add_definitions(-DENABLE_UCHARDET)
  find_package(uchardet REQUIRED)
endif ()
if (_link_gflags)
  set(EXTLIBS ${EXTLIBS} gflags)
endif ()
if (_link_glog)
  set(EXTLIBS ${EXTLIBS} glog::glog)
endif ()
if (_link_uchardet)
  set(EXTLIBS ${EXTLIBS} uchardet::libuchardet)
endif ()

if (MINGW AND _copy_dll)
  string(REGEX REPLACE "^(.+/)[^/]+$" "\\1" CXX_DIR ${CMAKE_CXX_COMPILER})
  # MinGW
  file(COPY_FILE "${CXX_DIR}/libstdc++-6.dll" "${CMAKE_BINARY_DIR}/libstdc++-6.dll" RESULT STATUS)
  # LLVM
  file(COPY_FILE "${CXX_DIR}/libc++.dll" "${CMAKE_BINARY_DIR}/libc++.dll" RESULT STATUS)
  file(COPY_FILE "${CXX_DIR}/libunwind.dll" "${CMAKE_BINARY_DIR}/libunwind.dll" RESULT STATUS)
  if (_find_glog)
    # Copy libglog.dll to binary dir
    file(COPY ${GOOGLE_LIBS_ROOT}/bin/libglog.dll DESTINATION ${CMAKE_BINARY_DIR})
  endif ()
  if (_find_uchardet)
    # Copy libuchardet.dll to binary dir
    file(COPY ${GOOGLE_LIBS_ROOT}/bin/libuchardet.dll DESTINATION ${CMAKE_BINARY_DIR})
  endif ()
endif ()

unset(GOOGLE_LIBS_ROOT)
unset(_copy_dll)
unset(_find_gflags)
unset(_find_glog)
unset(_find_gtest)
unset(_find_gmock)
unset(_find_uchardet)
unset(_link_gflags)
unset(_link_glog)
unset(_link_uchardet)
