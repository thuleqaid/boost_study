# Setting for Boost.test Library
include_directories(/usr/local/include)
link_directories(/usr/local/lib)
link_libraries(boost_unit_test_framework)
add_definitions(-DBOOST_ALL_DYN_LINK)
