#ifndef __ARGV_UTILS_HPP__
#define __ARGV_UTILS_HPP__

#include <boost/optional.hpp>
#include "argv.hpp"

typedef boost::optional<Argv> ArgvUtils;

ArgvUtils simple_argv(int argc, char *argv[]);

#endif /* __ARGV_UTILS_HPP__ */

