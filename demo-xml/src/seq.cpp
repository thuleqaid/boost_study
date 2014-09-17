#include "seq.hpp"
#include <sstream>

SeqNode::SeqNode()
	:m_call_type(SeqNode::E_UNKNOWN)
{
}
void SeqNode::setCallType(E_CallType calltype)
{
	m_call_type=calltype;
}
void SeqNode::setTaskSrc(const std::string& src)
{
	m_task_src=src;
}
void SeqNode::setTaskDst(const std::string& dst)
{
	m_task_dst=dst;
}
void SeqNode::setFunction(const std::string& func)
{
	m_func_name=func;
}
void SeqNode::setReturn(const std::string& ret)
{
	m_func_ret=ret;
}
void SeqNode::appendFuncParam(const std::string& param)
{
	m_func_param.push_back(param);
}
void SeqNode::appendFuncExtra(const std::string& extra)
{
	m_func_extra.push_back(extra);
}
void SeqNode::appendFuncMemo(const std::string& memo)
{
	m_func_memo.push_back(memo);
}
void SeqNode::printTree(std::ostream &out,int tabcnt)
{
	std::string prefix(tabcnt,'\t');
	out<<prefix<<m_task_src<<" --> "<<m_task_dst<<"\n";
	for (auto &child:m_child)
	{
		child->printTree(out,tabcnt+1);
	}
	out<<prefix<<m_task_src<<" <-- "<<m_task_dst<<"\n";
}
std::string SeqNode::toString()
{
	std::ostringstream os;
	os<<"["<<m_task_src<<"]--"<<m_call_type<<"-->["<<m_task_dst<<"]";
	return os.str();
}

SeqNodeSP CreateNode()
{
	SeqNodeSP p(new SeqNode());
	return p;
}
void AppendChild(SeqNodeSP parent, SeqNodeSP child)
{
	child->m_parent=parent;
	parent->m_child.push_back(child);
}
void SetMember(SeqNodeSP node,const std::string& key, const std::string& value)
{
	SeqNode::E_CallType call_type;
	if (key=="from")
	{
		node->setTaskSrc(value);
	}
	else if (key=="to")
	{
		node->setTaskDst(value);
	}
	else if (key=="type")
	{
		if (value=="sync")
		{
			call_type=SeqNode::E_SYNC;
		}
		else if (value=="async")
		{
			call_type=SeqNode::E_ASYNC;
		}
		else if (value=="async_wait")
		{
			call_type=SeqNode::E_ASYNC_WAIT;
		}
		node->setCallType(call_type);
	}
	else if (key=="function")
	{
		node->setFunction(value);
	}
	else if (key=="return")
	{
		node->setReturn(value);
	}
}
