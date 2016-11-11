#include <iostream>
#include "project1/project1.h"

int main(int argc, char *argv[])
{
  std::cout << "Hello, World!" << std::endl;
  int x = 4;
  std::cout << x << std::endl;
  independentMethod(x);
  std::cout << x << std::endl;
  Project1 p;
  p.foo(x);
  std::cout << x << std::endl;
  return 0;
}
