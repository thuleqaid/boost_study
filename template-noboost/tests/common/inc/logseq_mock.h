#ifndef _LOGSEQ_MOCK_H_
#define _LOGSEQ_MOCK_H_
#ifdef COMMON_LOGSEQ_ENABLE

#define ObjectClass LogSeq
#define TestPrefix ObjectClass

#include "common/test.h"
#include "logseq_inner.h"

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
    p = new ObjectClass(8, 4);
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
  MockObjectClass(const U4 history_size, const U1 count_bits)
    :ObjectClass(history_size, count_bits)
    ,real_(history_size, count_bits)
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
    p = new MockObjectClass(8, 4);
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
