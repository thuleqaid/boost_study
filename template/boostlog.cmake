#option(BOOSTLOG "switch for Boost.log library" OFF)
if(BOOSTLOG)
	# Setting for Boost.log Library
	add_definitions(-DDEBUGLOG)
	include_directories(/usr/local/include)
	link_directories(/usr/local/lib)
	link_libraries(boost_log boost_date_time boost_filesystem boost_system boost_thread)
	add_definitions(-DBOOST_ALL_DYN_LINK)
endif(BOOSTLOG)
