#ifndef _SUBMODULE1_H_
#define _SUBMODULE1_H_

#include "basemodule/basemodule.h"

class SubModule1 : public BaseModule {
public:
	SubModule1();
	virtual ~SubModule1();
	virtual VD init( VD );
	virtual VD run( VD );
	virtual VD exit( U1 u1_code );
};

#endif /* _SUBMODULE1_H_ */
