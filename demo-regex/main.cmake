# Setting for Source/Header files
set(SRCROOT "${ROOT_DIR}")
#file(GLOB SOURCE ${SRCROOT}/src/*.cpp)
aux_source_directory(${SRCROOT}/src SOURCE)
aux_source_directory(${SRCROOT}/entry ENTRY)
include_directories(${SRCROOT}/include)
