#ifndef PROJECT1_H_
#define PROJECT1_H_

#include <iostream> // IO access

class Project1 {

public:
	virtual ~Project1();
	virtual int inner_foo(int i);
	void foo(int &i);

};

void independentMethod(int &i);

#endif /* PROJECT1_H_ */