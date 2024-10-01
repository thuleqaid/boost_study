/* Usage:
 *   1. 复制_tmpl_目录，modules目录下需要有同名的目录
 *   2. inc/src目录下可以根据需要复制多份文件
 *   3. inc/src中的文件，修改ToDo位置
 */
#ifndef _FOOBAR_MOCK_H_ /* ToDo */
#define _FOOBAR_MOCK_H_ /* ToDo */

#define ObjectClass FooBarClass /* ToDo:测试对象类型名（包含一个无参数的构造函数） */
#define TestPrefix ObjectClass /* ToDo(Optional):可以选用不同的名称，推荐与文件名有关联 */

#include "common/test.h"
#include "foobar.h" /* ToDo:测试对象类型头文件 */

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
    p = new ObjectClass();
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
  MockObjectClass()
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
    p = new MockObjectClass();
  }

  virtual void TearDown()
  {
    delete p;
  }

  MockObjectClass *p;
};
#endif /* ENABLE_GMOCK */

#endif
