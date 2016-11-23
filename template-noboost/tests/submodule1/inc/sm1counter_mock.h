#ifndef _SM1COUNTER_MOCK_H_
#define _SM1COUNTER_MOCK_H_

#ifdef ENABLE_GMOCK
#include "gmock/gmock.h"
#endif
#include "sm1counter.h"

class SM1CounterTest : public ::testing::Test {
protected:
	SM1CounterTest() {
	}
	virtual ~SM1CounterTest() {
	}
	virtual void SetUp() {
		p = new SM1Counter();
	}
	virtual void TearDown() {
		delete p;
	}
	SM1Counter *p;
};

#ifdef ENABLE_GMOCK

using ::testing::_;
using ::testing::Invoke;

class SM1CounterMock : public SM1Counter
{
public:
	SM1CounterMock() {
		ON_CALL(*this, getCounter())
			.WillByDefault(Invoke(&real_, &SM1Counter::getCounter));
		ON_CALL(*this, countUp())
			.WillByDefault(Invoke(&real_, &SM1Counter::countUp));
	}
	MOCK_CONST_METHOD0(getCounter, I4 ());
	MOCK_METHOD0(countUp, VD ());
private:
	SM1Counter real_;
};

class SM1CounterMockTest : public ::testing::Test {
protected:
	SM1CounterMockTest() {
	}
	virtual ~SM1CounterMockTest() {
	}
	virtual void SetUp() {
		p = new SM1CounterMock();
	}
	virtual void TearDown() {
		delete p;
	}
	SM1CounterMock *p;
};
#endif

#endif /* _SM1COUNTER_MOCK_H_ */