#option(GDB "switch for debug information for GDB" ON)
#option(BOOST "switch for Boost library" ON)
#option(BOOSTLOG "switch for Boost.log library" ON)
#option(BOOSTTEST "switch for Boost.test library" ON)
#option(BOOSTTHREAD "switch for Boost.thread library" ON)
#option(BOOSTPO "switch for Boost.program_options library" ON)
#option(BOOSTFILESYSTEM "switch for Boost.filesystem library" ON)

set(BOOST_LIBS "boost_atomic"
               "boost_chrono"
               "boost_container"
               "boost_context"
               "boost_contract"
               "boost_coroutine"
               "boost_date_time"
               "boost_filesystem"
               "boost_graph"
               "boost_iostreams"
               "boost_locale"
               "boost_log"
               "boost_log_setup"
               "boost_math_tr1"
               "boost_math_tr1f"
               "boost_math_tr1l"
               "boost_math_c99"
               "boost_math_c99f"
               "boost_math_c99l"
               "boost_prg_exec_monitor"
               "boost_program_options"
               "boost_random"
               "boost_regex"
               "boost_serialization"
               "boost_signals"
               "boost_stacktrace_noop"
               "boost_stacktrace_windbg"
               "boost_system"
               "boost_thread"
               "boost_timer"
               "boost_type_erasure"
               "boost_unit_test_framework"
               "boost_wave"
               "boost_wserialization"
               )
if(WIN32)
	set(BOOST_INC_ROOT "E:/Boost/include/boost-1_67")
	set(BOOST_LIB_ROOT "E:/Boost/lib")
	set(BOOST_LIB_PREFIX "lib")
	set(BOOST_LIB_SURFIX "-mgw81-mt-x64-1_67.dll")
else()
	set(BOOST_INC_ROOT "/usr/local/include")
	set(BOOST_LIB_ROOT "/usr/local/lib")
	set(BOOST_LIB_PREFIX "")
	set(BOOST_LIB_SURFIX "")
endif()

foreach (item IN LISTS BOOST_LIBS)
	set(BOOST_LIB_${item} "${BOOST_LIB_PREFIX}${item}${BOOST_LIB_SURFIX}")
	set(_copy_${item} OFF)
endforeach ()

if (NOT MSVC)
	if(GDB)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
	endif(GDB)
endif()

include_directories(${BOOST_INC_ROOT})
if(BOOST)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-parentheses")
	add_definitions(-DBOOST_ALL_DYN_LINK)
	link_directories(${BOOST_LIB_ROOT})
	if(BOOSTLOG)
		# Setting for Boost.log Library
		add_definitions(-DDEBUGLOG)
		link_libraries(${BOOST_LIB_boost_log} ${BOOST_LIB_boost_log_setup} ${BOOST_LIB_boost_date_time} ${BOOST_LIB_boost_filesystem} ${BOOST_LIB_boost_system} ${BOOST_LIB_boost_thread})
		set(_copy_boost_log ON)
		set(_copy_boost_log_setup ON)
		set(_copy_boost_date_time ON)
		set(_copy_boost_filesystem ON)
		set(_copy_boost_system ON)
		set(_copy_boost_thread ON)
		set(_copy_boost_regex ON)
		link_libraries(pthread)
	endif(BOOSTLOG)
	if(BOOSTTEST)
		# Setting for Boost.test Library
		link_libraries(${BOOST_LIB_boost_unit_test_framework})
		set(_copy_boost_unit_test_framework ON)
	endif(BOOSTTEST)
	if(BOOSTTHREAD)
		# Setting for Boost.thread Library
		link_libraries(${BOOST_LIB_boost_thread} ${BOOST_LIB_boost_system} ${BOOST_LIB_boost_chrono} ${BOOST_LIB_boost_date_time})
		set(_copy_boost_thread ON)
		set(_copy_boost_system ON)
		set(_copy_boost_chrono ON)
		set(_copy_boost_date_time ON)
		link_libraries(pthread)
	endif(BOOSTTHREAD)
	if(BOOSTPO)
		# Setting for Boost.program_options Library
		add_definitions(-DBOOST_PO)
		link_libraries(${BOOST_LIB_boost_program_options})
		set(_copy_boost_program_options ON)
	endif(BOOSTPO)
	if(BOOSTFILESYSTEM)
		# Setting for Boost.filesystem Library
		link_libraries(${BOOST_LIB_boost_filesystem})
		set(_copy_boost_filesystem ON)
	endif(BOOSTFILESYSTEM)
endif(BOOST)

if (MINGW)
	# Copy libstdc++-6.dll to binary dir
	string(REGEX REPLACE "^(.+/)[^/]+$" "\\1libstdc++-6.dll" LIBSTDCXX ${CMAKE_CXX_COMPILER})
	file(COPY ${LIBSTDCXX} DESTINATION ${EXECUTABLE_OUTPUT_PATH})
	foreach (item IN LISTS BOOST_LIBS)
		if(${_copy_${item}})
			file(COPY ${BOOST_LIB_ROOT}/${BOOST_LIB_${item}} DESTINATION ${EXECUTABLE_OUTPUT_PATH})
		endif()
	endforeach ()
endif ()

foreach (item IN LISTS BOOST_LIBS)
	unset(BOOST_LIB_${item})
	unset(_copy_${item})
endforeach ()
unset(BOOST_LIBS)
unset(BOOST_INC_ROOT)
unset(BOOST_LIB_ROOT)
unset(BOOST_LIB_PREFIX)
unset(BOOST_LIB_SURFIX)
