#include "project1/project1.h"

Project1::~Project1() {
}

int Project1::inner_foo(int i) {
	return i * i;
}

void Project1::foo(int &i) {
	i = inner_foo(i);
}


void independentMethod(int &i) {
	i = 0;
}