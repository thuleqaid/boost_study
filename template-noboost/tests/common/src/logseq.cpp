#ifdef COMMON_LOGSEQ_ENABLE
#include "gtest/gtest.h"
#include "logseq_mock.h"

TEST_F(TestClass, OverWrite_With_Counter)
{
  p->mark("aa");
  p->mark("bb");
  p->mark("cc");
  p->mark("dd");
  p->mark("ee");
  p->mark("ff");
  auto labels = p->getLabels();
  auto points = p->getHistory();
  EXPECT_EQ(labels.size(), 6);
  EXPECT_EQ(points.size(), 6);
  EXPECT_EQ(labels[0], "aa");
  EXPECT_EQ(labels[5], "ff");
  EXPECT_EQ(points[0], 0x01);
  EXPECT_EQ(points[5], 0x51);
  p->mark("gg");
  p->mark("hh");
  p->mark("cc");
  p->mark("cc");
  p->mark("ii");
  p->mark("ii");
  p->mark("ii");
  p->mark("ii");
  p->mark("ii");
  p->mark("ii");
  p->mark("ii");
  p->mark("ii");
  p->mark("ii");
  p->mark("ii");
  p->mark("ii");
  p->mark("ii");
  p->mark("ii");
  p->mark("ii");
  p->mark("ii");
  p->mark("ii");
  p->mark("ii");
  p->mark("ii");
  p->mark("ii");
  p->mark("ii");
  p->mark("ii");
  labels = p->getLabels();
  points = p->getHistory();
  EXPECT_EQ(labels.size(), 9);
  EXPECT_EQ(points.size(), 8);
  EXPECT_EQ(labels[0], "aa");
  EXPECT_EQ(labels[8], "ii");
  EXPECT_EQ(points[0], 0x21);
  EXPECT_EQ(points[6], 0x22);
  EXPECT_EQ(points[7], 0x8F);
}

TEST_F(TestClass, OverWrite_Without_Counter)
{
  p = new ObjectClass(8,0);
  p->mark("aa");
  p->mark("bb");
  p->mark("cc");
  p->mark("cc");
  p->mark("dd");
  p->mark("ee");
  p->mark("ff");
  auto labels = p->getLabels();
  auto points = p->getHistory();
  EXPECT_EQ(labels.size(), 6);
  EXPECT_EQ(points.size(), 7);
  EXPECT_EQ(labels[0], "aa");
  EXPECT_EQ(labels[5], "ff");
  EXPECT_EQ(points[0], 0x0);
  EXPECT_EQ(points[1], 0x1);
  EXPECT_EQ(points[2], 0x2);
  EXPECT_EQ(points[3], 0x2);
  EXPECT_EQ(points[4], 0x3);
  EXPECT_EQ(points[5], 0x4);
  EXPECT_EQ(points[6], 0x5);
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