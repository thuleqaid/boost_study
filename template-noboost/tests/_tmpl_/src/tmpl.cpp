#include "gtest/gtest.h"
#include "tmpl_mock.h" /* ToDo */

TEST_F(TestClass, XXX)
{
  EXPECT_EQ(0, 0);
}

#ifdef ENABLE_GMOCK

using ::testing::Return;
using ::testing::InSequence;

TEST_F(MockTestClass, XXX)
{
  EXPECT_EQ(0, 0);
}

#endif
