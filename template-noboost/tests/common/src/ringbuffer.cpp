#ifdef COMMON_RINGBUFFER_ENABLE
#include "gtest/gtest.h"
#include "ringbuffer_mock.h"

TEST_F(TestClass, Produce_Consume_No_Overwrite)
{
  EXPECT_EQ(p->setStrategy(RINGBUFFER_FULL_OVERWRITE, 2), FALSE);
  EXPECT_EQ(p->getStrategy(-1), RINGBUFFER_FULL_ERROR);
  EXPECT_EQ(p->produce(1), TRUE);
  EXPECT_EQ(p->produce(2), TRUE);
  EXPECT_EQ(p->produce(3), TRUE);
  EXPECT_EQ(p->produce(4), TRUE);
  EXPECT_EQ(p->produce(5), FALSE);
  U4 value = 0;
  EXPECT_EQ(p->consume(value), TRUE);
  EXPECT_EQ(value, 1);
  EXPECT_EQ(p->consume(value), TRUE);
  EXPECT_EQ(value, 2);
  EXPECT_EQ(p->consume(value), TRUE);
  EXPECT_EQ(value, 3);
  EXPECT_EQ(p->consume(value), TRUE);
  EXPECT_EQ(value, 4);
  EXPECT_EQ(p->consume(value), FALSE);
}

TEST_F(TestClass, Produce_Consume_With_Overwrite)
{
  EXPECT_EQ(p->setStrategy(RINGBUFFER_FULL_OVERWRITE, 1), TRUE);
  EXPECT_EQ(p->getStrategy(-1), RINGBUFFER_FULL_INCONSISTENT);
  EXPECT_EQ(p->produce(1, 1), TRUE);
  EXPECT_EQ(p->produce(2, 1), TRUE);
  EXPECT_EQ(p->produce(3, 1), TRUE);
  EXPECT_EQ(p->produce(4, 1), TRUE);
  EXPECT_EQ(p->produce(5, 1), TRUE);
  U4 value = 0;
  EXPECT_EQ(p->consume(value, 1), TRUE);
  EXPECT_EQ(value, 2);
  EXPECT_EQ(p->consume(value, 1), TRUE);
  EXPECT_EQ(value, 3);
  EXPECT_EQ(p->consume(value, 1), TRUE);
  EXPECT_EQ(value, 4);
  EXPECT_EQ(p->consume(value, 1), TRUE);
  EXPECT_EQ(value, 5);
  EXPECT_EQ(p->consume(value, 1), FALSE);
}

TEST_F(TestClass, Update_First_And_Last)
{
  U4 value = 0;
  p->produce(1);
  p->produce(2);
  p->produce(3);
  p->consume(value);
  p->produce(4);
  p->produce(5);
  EXPECT_EQ(p->getFirst(value), TRUE);
  EXPECT_EQ(value, 2);
  EXPECT_EQ(p->getLast(value), TRUE);
  EXPECT_EQ(value, 5);
  EXPECT_EQ(p->setFirst(11), TRUE);
  EXPECT_EQ(p->setLast(12), TRUE);
  EXPECT_EQ(p->getFirst(value), TRUE);
  EXPECT_EQ(value, 11);
  EXPECT_EQ(p->getLast(value), TRUE);
  EXPECT_EQ(value, 12);
}

#ifdef ENABLE_GMOCK

using ::testing::Return;
using ::testing::InSequence;

TEST_F(MockTestClass, XXX)
{
  EXPECT_EQ(0, 0);
}

#endif
#endif