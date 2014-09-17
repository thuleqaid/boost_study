#ifndef __SEQ_HPP__
#define __SEQ_HPP__
#include <string>
#include <vector>
#include <memory>
#include <iostream>

class SeqNode;
typedef std::shared_ptr<SeqNode> SeqNodeSP;

class SeqNode
{
	public:
		enum E_CallType {
			E_UNKNOWN,
			E_SYNC,
			E_ASYNC,
			E_ASYNC_WAIT
		};
		SeqNode();
		void printTree(std::ostream &out,int tabcnt=0);
		void setCallType(E_CallType calltype);
		void setTaskSrc(const std::string& src);
		void setTaskDst(const std::string& dst);
		void setFunction(const std::string& func);
		void setReturn(const std::string& ret);
		void appendFuncParam(const std::string& param);
		void appendFuncExtra(const std::string& extra);
		void appendFuncMemo(const std::string& memo);
		friend void AppendChild(SeqNodeSP parent, SeqNodeSP child);
	protected:
		std::string toString();
	private:
		E_CallType m_call_type;
		std::string m_task_src;
		std::string m_task_dst;
		std::string m_func_name;
		std::string m_func_ret;
		std::vector<std::string> m_func_param;
		std::vector<std::string> m_func_extra;
		std::vector<std::string> m_func_memo;
		std::vector< SeqNodeSP > m_child;
		std::weak_ptr<SeqNode> m_parent;
};
SeqNodeSP CreateNode();
void AppendChild(SeqNodeSP parent, SeqNodeSP child);
void SetMember(SeqNodeSP node,const std::string& key, const std::string& value);
#endif
