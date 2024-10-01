#ifndef _TEST_H_
#define _TEST_H_

#ifdef ENABLE_GMOCK
#include "gmock/gmock.h"
#endif

#define DEFINE_TEST_(X) X##Test
#define DEFINE_MOCK_(X) X##Mock
#define DEFINE_TEST(X) DEFINE_TEST_(X)
#define DEFINE_MOCK(X) DEFINE_MOCK_(X)
#define TestClass DEFINE_TEST(TestPrefix)
#define MockObjectClass DEFINE_MOCK(TestPrefix)
#define MockTestClass DEFINE_TEST(DEFINE_MOCK(TestPrefix))

#endif /* _TEST_H_ */
