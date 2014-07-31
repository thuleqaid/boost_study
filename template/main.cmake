if(GDB)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
endif(GDB)
## [Start]include cmake file here
include("${ROOT_DIR}/boostlog.cmake")
## [Stop]include cmake file here

# Setting for Source/Header files
set(SRCROOT "${ROOT_DIR}")
#file(GLOB SOURCE ${SRCROOT}/src/*.cpp)
aux_source_directory(${SRCROOT}/src SOURCE)
aux_source_directory(${SRCROOT}/entry ENTRY)
include_directories(${SRCROOT}/include)
