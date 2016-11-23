#include "gtest/gtest.h"
#include "sm1counter_mock.h"

TEST_F(SM1CounterTest, Initialize)
{
	/* 计数器初始值为COUNTER_MIN */
	EXPECT_EQ(p->getCounter(), SM1Counter::COUNTER_MIN);
}

TEST_F(SM1CounterTest, TimeUpCount)
{
	/* 第（COUNTER_MAX-COUNTER_MIN）次的isTimeUp()为True，计数器值还原为COUNTER_MIN */
	I4 i = 0;
	for (i = SM1Counter::COUNTER_MIN; i < SM1Counter::COUNTER_MAX; ++i) {
		if (p->isTimeUp()) {
			break;
		}
	}
	EXPECT_EQ(p->getCounter(), SM1Counter::COUNTER_MIN);
	EXPECT_EQ(i, SM1Counter::COUNTER_MAX - 1);
}

#ifdef ENABLE_GMOCK

using ::testing::Return;
using ::testing::InSequence;

TEST_F(SM1CounterMockTest, countUp_called) {
	EXPECT_CALL(*p, countUp());
	EXPECT_CALL(*p, getCounter()).WillRepeatedly(Return(0));
	EXPECT_EQ(true, p->isTimeUp());
	EXPECT_EQ(0, p->getCounter());
}

#endif
