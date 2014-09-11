### JavaScrip
#### 概要说明
##### 文件构成
直接写在网页文件中，或者在网页中包含源文件(*.js)组成。
##### 格式要求
正常情况下没有缩进和换行的要求，要求每条语句后面有分号**;**，某些情况下可以省略。
##### 程序入口
无。通过绑定网页的事件来调用某个函数。
##### 编译执行
无法编译，在浏览器中解释执行。
#### 数据类型
##### 布尔型
有（true,false）。包括基本类型和对象类型两种。
##### 整数型
无。
##### 小数型
有。包括基本类型和对象类型两种。
##### 字符型
只有字符串类型。包括基本类型和对象类型两种。
只读类型，通过字符串函数str.replace()等来改变内容，实际上是重新生成了一个新的字符串。
chardata=str.charAt(idx);
newstr=str.concat(str-data);
int-pos=str.indexOf(value,startidx);
arrayOfFoundStr=str.match(/regexp/);
str.replace(old-value,new-value);
str.replace(/regexp/,new-value);
int-pos=str.search(/regexp/);
substring=str.slice(startidx,stopidx);
arrayOfSubStr=str.split(sep\[,max-count\]);
##### 其它类型
无。
##### 顺序存储结构
Array。
/* declare */
var varname=\[\];
var varname=new Array();
var varname=\[value1,value2\];
var varname=new Array(value1,value2);
var varname=new Array(count);
/* iterate */
for (var i=0; i<varname.length; ++i)
{
	varname[i];
}
var sumValue=0;
varname.forEach(function(x) {sumValue+=x;});
/* method */
str_data=varname.join(str-sep);
varname.reverse();
varname.sort();
varname.sort(function(a,b) {return a-b;});
newarray=varname.concat(another-array);
subarray=varname.slice(start-idx,stop-idx);
subarray=varname.splice(start-idx,count); /* varname is modified */
varname.splice(start-idx,count,value1,value2); /* insert/replace values in varname */
newlength=varname.push(value); /* append data in the end */
popped-data=varname.pop(); /* remove data in the end */
newlength=varname.unshift(value); /* append data in the front */
popped-data=varname.shift(); /* remove data in the front */
varname.indexOf(value);
newarray=varname.map(function(x){return x*x;});
newarray=varname.filter(function(x){return x<3;});
newarray=varname.filter(function(x,i){return i%2==0;});
boolvalue=varname.every(function(x){return x<10;});
boolvalue=varname.some(function(x){return x<10;});
value=varname.reduce(function(x,y){return x*y;},1);
value=varname.reduce(function(x,y){return (x>y)?x:y;});
/* varname.reduceRight(func)===varname.reverse().reduce(func) */
##### KV存储结构
Object。
var varname={
	prop:value,
	$prop:value, // "$" is a hint for private-property, but no effect in fact
	get prop() { },
	set prop(value) { }
	};
##### 类型转换
布尔、小数和字符串类型之间会隐式转换。
x+""->String(x)
+x->Number(x)
!!x->Boolean(x)
##### 类型检查
* typedef，返回值：
	- undefined	"undefined"
	- null	"object"
	- true/false	"boolean"
	- number/NaN	"number"
	- string	"string"
	- function	"function"
	- non-function object	"object"
* instancof
#### 变量
##### 命名规则
\[a-zA-Z_\]\[a-zA-Z_0-9\]+
##### 变量申明
变量申明的形式：
var 变量名\[=初期值\]\[, 变量名\[=初期值\]\];
##### 有效范围
若变量申明在函数之内，则为局部变量，整个函数之内。
若变量申明在函数之外，则为全局变量。
##### 变量赋值
基本类型为值传递，对象类型为引用传递。
#### 运算符
##### 算术运算符
- **+**,**-**
- **++**,**--**
- *****,**/**,**%**
##### 逻辑运算符
- **==**,**!=**
	loose compare, automatically cast values into a comparable type
- **===**,**!==**
	strict compare
- **||**,**&&**
- **!**
- **?:**
##### 位运算符
- **|**,**&**
- **~**,**^**
- **<<**,**>>**,**>>>**
##### 赋值运算符
- **=**
- **+/**,**-=**,***=**,**/=**
- **|=**,**&=**
#### 流程控制
##### 分支
	<!-- lang: javascript -->
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
	<!-- lang: javascript -->
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
函数实体：
function funcname(\[参数名1\[,参数名2\]\])
{
	/* 参数检查 */
	/* 因为调用时允许传入比申明时多或少的参数个数，使用参数时可以无视形参名，直接用arguments数组 */
	/* 函数内部处理 */
	return 返回类型数据;
}
var varname=function \[funcname\](\[参数名1\[,参数名2\]\])
{
	/* 参数检查 */
	/* 函数内部处理 */
	return 返回类型数据;
};
函数调用：
- 一般函数
	funcname(\[参数名1\[,参数名2\]\]);
- 成员函数
	obj.funcname(\[参数名1\[,参数名2\]\]);
- 构造体
	new funcname(\[参数名1\[,参数名2\]\]);
- 一般函数作为成员函数
	funcname.call(obj,\[参数名1\[,参数名2\]\]);
	funcname.apply(obj,\[\[参数名1\[,参数名2\]\]\]);
	call的第2个参数开始是函数第1个参数，apply的第2个参数是函数所有参数组成的数组。
#### 面向对象
有。
function ClassName(construct-vars)
{
	/* set instance-specified member */
	/* this.XXX=YYY; */
}
ClassName.prototype={
	constructor:ClassName,
	member-func:function(){},
	static-member:value
	};
#### 其它常用知识
- **Math**
ceil(x),floor(x),round(x)
sin(x),cos(x),tan(x)
asin(x),acos(x),atan(x),atan2(y,x)
exp(x),log(x),pow(x,y),sqrt(x)
min(x,y),max(x,y)
abs(x),random()
- **Date and Time**
var varname=new Date();
action	property-name
get/set	FullYear
get/set	Month(0~11)
get/set	Date(1~31)
get		Day(0~6)
get/set	Hours(0~23)
get/set	Minutes(0~59)
get/set	Seconds(0~59)
get/set	Milliseconds(0~999)
get/set	FullYear

