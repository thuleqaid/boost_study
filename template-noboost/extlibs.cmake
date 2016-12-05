set(EXTLIBS)

set(GOOGLE_LIBS_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/extlibs")
set(_copy_dll OFF)
set(_find_gflags OFF)
set(_find_glog OFF)
set(_find_gtest OFF)
set(_find_gmock OFF)
set(_link_gflags OFF)
set(_link_glog OFF)

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
  set(_find_gmock ON)
endif ()

if (_find_gflags)
  set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "${GOOGLE_LIBS_ROOT}")
  add_definitions(-DENABLE_GFLAGS)
  find_package(gflags REQUIRED)
endif ()
if (_find_glog)
  set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "${GOOGLE_LIBS_ROOT}/Lib/cmake/glog")
  add_definitions(-DENABLE_GLOG)
  find_package(glog REQUIRED)
endif ()
if (_find_gtest)
  add_library(gtest UNKNOWN IMPORTED)
  add_library(gtest_main UNKNOWN IMPORTED)
  if (MSVC)
    set_target_properties(gtest PROPERTIES
      IMPORTED_LOCATION ${GOOGLE_LIBS_ROOT}/Lib/gtest.lib
      INTERFACE_INCLUDE_DIRECTORIES "${GOOGLE_LIBS_ROOT}/Include"
    )
    set_target_properties(gtest_main PROPERTIES
      IMPORTED_LOCATION ${GOOGLE_LIBS_ROOT}/Lib/gtest_main.lib
      INTERFACE_INCLUDE_DIRECTORIES "${GOOGLE_LIBS_ROOT}/Include"
    )
  else ()
    set_target_properties(gtest PROPERTIES
      IMPORTED_LOCATION ${GOOGLE_LIBS_ROOT}/Lib/libgtest.a
      INTERFACE_INCLUDE_DIRECTORIES "${GOOGLE_LIBS_ROOT}/Include"
    )
    set_target_properties(gtest_main PROPERTIES
      IMPORTED_LOCATION ${GOOGLE_LIBS_ROOT}/Lib/libgtest_main.a
      INTERFACE_INCLUDE_DIRECTORIES "${GOOGLE_LIBS_ROOT}/Include"
    )
  endif ()
  add_definitions(-DENABLE_GTEST)
endif ()
if (_find_gmock)
  add_library(gmock UNKNOWN IMPORTED)
  add_library(gmock_main UNKNOWN IMPORTED)
  if (MSVC)
    set_target_properties(gmock PROPERTIES
      IMPORTED_LOCATION ${GOOGLE_LIBS_ROOT}/Lib/gmock.lib
      INTERFACE_INCLUDE_DIRECTORIES "${GOOGLE_LIBS_ROOT}/Include"
    )
    set_target_properties(gmock_main PROPERTIES
      IMPORTED_LOCATION ${GOOGLE_LIBS_ROOT}/Lib/gmock_main.lib
      INTERFACE_INCLUDE_DIRECTORIES "${GOOGLE_LIBS_ROOT}/Include"
    )
  else ()
    set_target_properties(gmock PROPERTIES
      IMPORTED_LOCATION ${GOOGLE_LIBS_ROOT}/Lib/libgmock.a
      INTERFACE_INCLUDE_DIRECTORIES "${GOOGLE_LIBS_ROOT}/Include"
    )
    set_target_properties(gmock_main PROPERTIES
      IMPORTED_LOCATION ${GOOGLE_LIBS_ROOT}/Lib/libgmock_main.a
      INTERFACE_INCLUDE_DIRECTORIES "${GOOGLE_LIBS_ROOT}/Include"
    )
  endif ()
  add_definitions(-DENABLE_GMOCK)
endif ()
if (_link_gflags)
  set(EXTLIBS ${EXTLIBS} gflags)
endif ()
if (_link_glog)
  set(EXTLIBS ${EXTLIBS} glog::glog)
endif ()

if (MINGW AND _copy_dll)
  # Copy libstdc++-6.dll to binary dir
  string(REGEX REPLACE "^(.+/)[^/]+$" "\\1libstdc++-6.dll" LIBSTDCXX ${CMAKE_CXX_COMPILER})
  file(COPY ${LIBSTDCXX} DESTINATION ${CMAKE_BINARY_DIR})
endif ()

unset(GOOGLE_LIBS_ROOT)
unset(_copy_dll)
unset(_find_gflags)
unset(_find_glog)
unset(_find_gtest)
unset(_find_gmock)
unset(_link_gflags)
unset(_link_glog)
