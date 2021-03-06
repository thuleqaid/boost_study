#option(GDB "switch for debug information for GDB" ON)
if(GDB)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
endif(GDB)

#option(BOOST "switch for Boost library" ON)
#option(BOOSTLOG "switch for Boost.log library" ON)
#option(BOOSTTEST "switch for Boost.test library" ON)
#option(BOOSTTHREAD "switch for Boost.thread library" ON)
#option(BOOSTPO "switch for Boost.program_options library" ON)
#option(BOOSTFILESYSTEM "switch for Boost.filesystem library" ON)
if(BOOST)
	include_directories(/usr/local/include)
	link_directories(/usr/local/lib)
	add_definitions(-DBOOST_ALL_DYN_LINK)
	if(BOOSTLOG)
		# Setting for Boost.log Library
		add_definitions(-DDEBUGLOG)
		link_libraries(boost_log boost_date_time boost_filesystem boost_system boost_thread)
	endif(BOOSTLOG)
	if(BOOSTTEST)
		# Setting for Boost.test Library
		link_libraries(boost_unit_test_framework)
	endif(BOOSTTEST)
	if(BOOSTTHREAD)
		# Setting for Boost.thread Library
		link_libraries(boost_thread boost_system boost_chrono boost_date_time)
	endif(BOOSTTHREAD)
	if(BOOSTPO)
		# Setting for Boost.program_options Library
		link_libraries(boost_program_options)
	endif(BOOSTPO)
	if(BOOSTFILESYSTEM)
		# Setting for Boost.filesystem Library
		link_libraries(boost_filesystem)
	endif(BOOSTFILESYSTEM)
endif(BOOST)
