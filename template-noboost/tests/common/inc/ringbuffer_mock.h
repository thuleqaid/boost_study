#ifndef _RINGBUFFER_MOCK_H_
#define _RINGBUFFER_MOCK_H_
#ifdef COMMON_RINGBUFFER_ENABLE

#include "common/ringbuffer.h"
typedef RingBuffer<U4> U4RingBuffer;
#define ObjectClass U4RingBuffer
#define TestPrefix ObjectClass

#include "common/test.h"

class TestClass : public ::testing::Test
{
protected:
  TestClass()
  {
  }

  virtual ~TestClass()
  {
  }

  virtual void SetUp()
  {
    p = new ObjectClass(0, 4, 2);
  }

  virtual void TearDown()
  {
    delete p;
  }

  ObjectClass *p;
};

#ifdef ENABLE_GMOCK

using ::testing::_;
using ::testing::Invoke;

class MockObjectClass : public ObjectClass
{
public:
  MockObjectClass(const U4 &default_value, USIZE buffer_length, USIZE buffer_count=1, RingBufferFullStrategy default_strategy=RINGBUFFER_FULL_ERROR)
    :ObjectClass(default_value, default_strategy)
    ,real_(default_value, default_strategy)
  {
    /*
      ON_CALL(*this, func())
      .WillByDefault(Invoke(&real_, &RingBuffer::func));
    */
  }

private:
  ObjectClass real_;
};

class MockTestClass : public ::testing::Test
{
protected:
  MockTestClass()
  {
  }

  virtual ~MockTestClass()
  {
  }

  virtual void SetUp()
  {
    p = new MockObjectClass(0, 4, 2);
  }

  virtual void TearDown()
  {
    delete p;
  }

  MockObjectClass *p;
};
#endif /* ENABLE_GMOCK */

#endif
#endif
