#ifndef TEST_MOCK_PROJECT1_H_
#define TEST_MOCK_PROJECT1_H_

#ifdef ENABLE_GMOCK
#include "gmock/gmock.h"
#include "project1/project1.h"

class MockProject1 : public Project1 {

public:
	MOCK_METHOD1(inner_foo, int (int i));
};
#endif

#endif /* TEST_MOCK_PROJECT1_H_ */