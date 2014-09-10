### C
#### 概要说明
##### 文件构成
由头文件(*.h)和源文件(*.c)组成。源文件通过**#include "头文件.h"**的方式，将头文件的内容全部复制到源文件中，因此，头文件可以看作是源文件的共通内容，即理论上不要头文件也可以。
##### 格式要求
正常情况下没有缩进和换行的要求，只要求每条语句后面有分号**;**。
##### 程序入口
一个程序有且仅有一个main函数。程序启动时系统调用main函数，main函数结束时程序结束。
main函数的形式：int main(int argc,char* argv[])
##### 编译执行
先将所有的源文件编译成二进制文件(*.o)，然后把所有的二进制文件链接成一个可执行文件。生成可执行文件之后，不再依赖于编译工具，只依赖于生成可执行文件的环境（操作系统等）。
#### 数据类型
##### 布尔型
没有这种类型，通过0和非0来决定False和True。
##### 整数型
包括有符号和无符号2类，无符号是在有符号类型前增加**unsigned**修饰。有符号类型主要有**short**、**int**和**long**。
##### 小数型
主要有**float**和**double**。
##### 字符型
主要有**char**。字符串由一个字符型的顺序存储结构来保存，最后一个字符用数值0来表示结束。
在数值范围比较小时，也会把字符型当作整数型来使用，因此也有无符号字符型。
##### 其它类型
- 指针，本身占用内存空间大小固定，值为另一块空间的地址。指针所指向的内存空间为另一个变量，或者由malloc分配、free释放的一段内存空间。没有指向一块有效的内存空间时，会导致程序异常退出甚至OS重新启动。
- 结构体，自定义类型，由多个类型数据集合而成。
- 共用体，自定义类型，由多个类型数据集合而成，但是多个类型共用同一块内存，所以正常情况下同时只有一个数据可用。
- 枚举型，自定义类型，相当于整数型的一个子集。
##### 顺序存储结构
数组。
##### KV存储结构
无。
##### 类型转换
数值类型之间的类型转换：**目标类型(原类型数据)**。其它类型之间的转换通常需要专门的函数。
##### 类型检查
C语言不是动态类型语言，不需要类型检查。
#### 变量
##### 命名规则
\[a-zA-Z_\]\[a-zA-Z_0-9\]+
##### 变量申明
申明在{}之内时，需要在紧接着{，不能被申明以外的代码打断。
变量申明的形式：
类型标识 变量标识\[=初期值\]\[, 变量标识\[=初期值\]\];
变量标识为变量名（一般变量）、*变量名（指针变量）或者变量名\[\]（数组变量）。
##### 有效范围
若变量申明在{}之内，则为局部变量，有效范围为{}之内。
若变量申明在{}之外，则为全局变量，有效范围为所有文件，但是在其它文件内要使用时，要先加一个外部变量的申明。
外部变量申明的形式：
extern 类型标识 变量标识\[, 变量标识\];
##### 变量赋值
C语言中所有的赋值都为值传递。
#### 运算符
##### 算术运算符
- **+**,**-**
- **++**,**--**
- *****,**/**,**%**
##### 逻辑运算符
- **==**,**!=**
- **||**,**&&**
- **!**
- **?:**
##### 位运算符
- **|**,**&**
- **~**,**^**
- **<<**,**>>**
##### 赋值运算符
- **=**
- **+/**,**-=**,***=**,**/=**
- **|=**,**&=**
#### 流程控制
##### 分支
	<!-- lang: cpp -->
	if ( BoolExpression ) {
		;
	} else if ( BoolExpression2 ) {
		;
	} else {
		;
	}
	switch ( int-value ) {
		case valu1:
			;
			break;
		case valu2:
			;
			break;
		default:
			;
			break;
	}
##### 循环
	<!-- lang: cpp -->
	while ( BoolExpression ) {
		; // continue/break
	}
	do {
		; // continue/break
	} while ( BoolExpression );
	/* for is equal to the belowing code
	 * init-statement;
	 * while ( BoolExpression ) {
	 * 	; // continue/break
	 * 	iterator-statement;
	 * }
	 */
	for (init-statement; BoolExpression; iterator-statement) {
		; // continue/break
	}
#### 函数
函数申明：
返回类型 函数名(\[参数类型1 \[参数名1\]\[,参数类型2 \[参数名2\]\]\]);
函数实体：
返回类型 函数名(\[参数类型1 参数名1\[,参数类型2 参数名2\]\])
{
	/* 局部变量申明 */
	/* 函数内部处理 */
	return 返回类型数据;
}
函数调用：
函数调用前，本文件中（包括#include的头文件）必须要有函数的申明或者实体。
#### 面向对象
无。
#### 其它常用知识
- **static**
- **const**
- **#define**
- **#if...#elif...#endif**