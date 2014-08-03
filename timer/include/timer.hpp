#ifndef __TIMER_HPP__
#define __TIMER_HPP__

/* uncomment the following line to enable the output of timer log,
 * it might cause segment error when program exits
 */
//#define TIMER_ENABLE_LOG

#include <boost/shared_ptr.hpp>
#include <boost/weak_ptr.hpp>
#include <boost/thread/thread_only.hpp>
#include <limits>
#include <set>
#include <list>
#ifdef TIMER_ENABLE_LOG
#include "log.hpp"
#endif /* TIMER_ENABLE_LOG */

template<typename OWNER_T,typename TIMERID_T, TIMERID_T startidx> class Timer
{
	public:
		typedef void (*TimeOutFunc)(TIMERID_T);
		Timer(TIMERID_T start_timerid=startidx);
		~Timer();
		TIMERID_T timer_new(TimeOutFunc func, boost::shared_ptr<OWNER_T> ptshare=nullptr, TIMERID_T timerid=std::numeric_limits<TIMERID_T>::min());
		void timer_start(TIMERID_T timerid, boost::chrono::steady_clock::duration interval=boost::chrono::seconds(1), long count=1);
		void timer_stop(TIMERID_T timerid);
		void timer_delete(TIMERID_T timerid);
		void timer_loop();
	protected:
		class Node
		{
			public:
				Node(TimeOutFunc func, boost::shared_ptr<OWNER_T> ptshare, TIMERID_T timerid)
					:m_func(func)
					,m_parent(ptshare)
					,m_id(timerid)
					,m_count(0)
				{
#ifdef TIMER_ENABLE_LOG
					LOG(debug)<<"Timer::Node::Node["<<m_id<<"]";
#endif /* TIMER_ENABLE_LOG */
				}
				~Node() {
#ifdef TIMER_ENABLE_LOG
					LOG(debug)<<"Timer::Node::~Node["<<m_id<<"]";
#endif /* TIMER_ENABLE_LOG */
				}
				const TIMERID_T& id() const { return m_id; }
				bool valid() const { return !m_parent.expired(); }
				const boost::chrono::steady_clock::time_point& nexttime() const { return m_nexttime; }
				long count() const { return m_count; }
				void setInterval(boost::chrono::steady_clock::duration interval)
				{
					m_interval=interval;
#ifdef TIMER_ENABLE_LOG
					LOG(debug)<<"Timer::Node::setInterval[id="<<m_id<<",interval(ns)="<<m_interval.count()<<"]";
#endif /* TIMER_ENABLE_LOG */
				}
				void setCount(const long count)
				{
					m_count=count;
#ifdef TIMER_ENABLE_LOG
					LOG(debug)<<"Timer::Node::setCount[id="<<m_id<<",count="<<m_count<<"]";
#endif /* TIMER_ENABLE_LOG */
				}
				void renew(boost::chrono::steady_clock::time_point tp=boost::chrono::steady_clock::now()) { if (m_count!=0) {m_nexttime=tp+m_interval;} }
				void fire()
				{
					if (m_count==0) {
					} else {
						if (m_count>0) {
							m_count--;
						}
#ifdef TIMER_ENABLE_LOG
						LOG(debug)<<"Timer::Node::fire[id="<<m_id<<",count="<<m_count<<"]";
#endif /* TIMER_ENABLE_LOG */
						m_func(m_id);
					}
				}
			private:
				TimeOutFunc m_func;
				boost::weak_ptr<OWNER_T> m_parent;
				TIMERID_T m_id;
				long m_count;
				boost::chrono::steady_clock::duration m_interval;
				boost::chrono::steady_clock::time_point m_nexttime;
		};
		struct SharedNodeCmp
		{
			bool operator() (const boost::shared_ptr<Node> &n1, const boost::shared_ptr<Node> &n2) const
			{
				return n1->id()<n2->id();
			}
		};
		void wakeup_thread(bool adopt, bool terminate);
		boost::shared_ptr<Node> get_node_by_timerid(TIMERID_T timerid)
		{
			boost::shared_ptr<Node> node=nullptr;
			for(auto &elem:m_nodelist) {
				if (elem->id()==timerid) {
					node=elem;
					break;
				} else if (elem->id()>timerid) {
					break;
				}
			}
			return node;
		}
	private:
		boost::shared_ptr<OWNER_T> m_sharedOwner;
		TIMERID_T m_start;
		TIMERID_T m_current;
		boost::thread m_thread;
		boost::condition_variable m_cond;
		boost::mutex m_condmutex;
		bool m_termflag;
		std::set<boost::shared_ptr<Node>,SharedNodeCmp> m_nodelist;
		std::list<boost::weak_ptr<Node>> m_timerlist;
};

template<typename OWNER_T,typename TIMERID_T,TIMERID_T startidx>
Timer<OWNER_T,TIMERID_T,startidx>::Timer(TIMERID_T start_timerid)
	:m_sharedOwner(new OWNER_T())
	,m_start(start_timerid<=std::numeric_limits<TIMERID_T>::min()?std::numeric_limits<TIMERID_T>::min()+1:start_timerid)
	,m_current(m_start)
	,m_thread(&Timer<OWNER_T,TIMERID_T,startidx>::timer_loop,this)
	,m_termflag(false)
{
}
template<typename OWNER_T,typename TIMERID_T,TIMERID_T startidx>
Timer<OWNER_T,TIMERID_T,startidx>::~Timer()
{
	if (m_thread.joinable()) {
		wakeup_thread(false,true);
		m_thread.join();
	}
}
template<typename OWNER_T,typename TIMERID_T,TIMERID_T startidx>
TIMERID_T Timer<OWNER_T,TIMERID_T,startidx>::timer_new(TimeOutFunc func, boost::shared_ptr<OWNER_T> ptshare, TIMERID_T timerid)
{
	TIMERID_T newid;
	boost::lock_guard<boost::mutex> lg(m_condmutex);
#ifdef TIMER_ENABLE_LOG
	LOG(debug)<<"Timer::timer_new[request-id="<<timerid<<"]";
#endif /* TIMER_ENABLE_LOG */
	if ((timerid<m_start) && (timerid>std::numeric_limits<TIMERID_T>::min()) && (get_node_by_timerid(timerid)==nullptr)) {
		newid=timerid;
	} else {
		if (get_node_by_timerid(m_current)==nullptr) {
			newid=m_current;
			do {
				if (m_current>=std::numeric_limits<TIMERID_T>::max()) {
					m_current=m_start;
				} else {
					m_current++;
				}
				if (m_current==newid) {
					// No empty id available
					break;
				}
			} while(get_node_by_timerid(m_current)!=nullptr);
		} else {
			// No empty id available
			newid=std::numeric_limits<TIMERID_T>::min();
		}
	}
	if (newid!=std::numeric_limits<TIMERID_T>::min()) {
		if (ptshare==nullptr) {
#ifdef TIMER_ENABLE_LOG
			LOG(debug)<<"Timer::timer_new[id="<<newid<<",owner=None]";
#endif /* TIMER_ENABLE_LOG */
			boost::shared_ptr<Node> temp(new Node(func,m_sharedOwner,newid));
			m_nodelist.insert(temp);
			m_timerlist.push_back(boost::weak_ptr<Node>(temp));
		} else {
#ifdef TIMER_ENABLE_LOG
			LOG(debug)<<"Timer::timer_new[id="<<newid<<",owner="<<ptshare<<"]";
#endif /* TIMER_ENABLE_LOG */
			boost::shared_ptr<Node> temp(new Node(func,ptshare,newid));
			m_nodelist.insert(temp);
			m_timerlist.push_back(boost::weak_ptr<Node>(temp));
		}
	} else {
#ifdef TIMER_ENABLE_LOG
		LOG(warning)<<"Timer::timer_new[id=None,owner=None]";
#endif /* TIMER_ENABLE_LOG */
	}
	return newid;
}

template<typename OWNER_T,typename TIMERID_T,TIMERID_T startidx>
void Timer<OWNER_T,TIMERID_T,startidx>::timer_start(TIMERID_T timerid, boost::chrono::steady_clock::duration interval, long count)
{
	boost::lock_guard<boost::mutex> lg(m_condmutex);
	auto elem=get_node_by_timerid(timerid);
	if (elem!=nullptr) {
#ifdef TIMER_ENABLE_LOG
		LOG(debug)<<"Timer::timer_start[id="<<timerid<<"]";
#endif /* TIMER_ENABLE_LOG */
		elem->setInterval(interval);
		elem->setCount(count);
		elem->renew();
		wakeup_thread(true,false);
	} else {
#ifdef TIMER_ENABLE_LOG
		LOG(warning)<<"Timer::timer_start[id="<<timerid<<"]";
#endif /* TIMER_ENABLE_LOG */
	}
}
template<typename OWNER_T,typename TIMERID_T,TIMERID_T startidx>
void Timer<OWNER_T,TIMERID_T,startidx>::timer_stop(TIMERID_T timerid)
{
	boost::lock_guard<boost::mutex> lg(m_condmutex);
	auto elem=get_node_by_timerid(timerid);
	if (elem!=nullptr) {
#ifdef TIMER_ENABLE_LOG
		LOG(debug)<<"Timer::timer_stop[id="<<timerid<<"]";
#endif /* TIMER_ENABLE_LOG */
		elem->setCount(0);
	} else {
#ifdef TIMER_ENABLE_LOG
		LOG(warning)<<"Timer::timer_stop[id="<<timerid<<"]";
#endif /* TIMER_ENABLE_LOG */
	}
}
template<typename OWNER_T,typename TIMERID_T,TIMERID_T startidx>
void Timer<OWNER_T,TIMERID_T,startidx>::timer_delete(TIMERID_T timerid)
{
	boost::lock_guard<boost::mutex> lg(m_condmutex);
	auto pos=m_nodelist.begin();
	for(;pos!=m_nodelist.end();++pos) {
		if ((*pos)->id==timerid) {
#ifdef TIMER_ENABLE_LOG
			LOG(debug)<<"Timer::timer_delete[id="<<timerid<<"]";
#endif /* TIMER_ENABLE_LOG */
			m_nodelist.erase(pos);
			break;
		} else if ((*pos)->id()>timerid) {
#ifdef TIMER_ENABLE_LOG
			LOG(warning)<<"Timer::timer_delete[id="<<timerid<<"]";
#endif /* TIMER_ENABLE_LOG */
			break;
		}
	}
}
template<typename OWNER_T,typename TIMERID_T,TIMERID_T startidx>
void Timer<OWNER_T,TIMERID_T,startidx>::timer_loop()
{
	boost::unique_lock<boost::mutex> ul(m_condmutex);
	boost::chrono::steady_clock::time_point now;
	boost::chrono::steady_clock::duration waittime;
	auto npos=m_nodelist.end();
	auto tpos=m_timerlist.end();
	while(true) {
		if (m_termflag) {
			break;
		}
		/* remove nodes whose parent is deleted from nodelist */
		for(npos=m_nodelist.begin();npos!=m_nodelist.end();) {
			if (!(*npos)->valid()) {
				m_nodelist.erase(npos++);
			} else {
				++npos;
			}
		}
		/* remove nodes which is expired from timerlist */
		m_timerlist.remove_if(
				[](boost::weak_ptr<Timer<OWNER_T,TIMERID_T,startidx>::Node> & item) {
					return item.expired();
				});
		/* sort timerlist */
		m_timerlist.sort(
				[](boost::weak_ptr<Timer<OWNER_T,TIMERID_T,startidx>::Node> & item1, boost::weak_ptr<Timer<OWNER_T,TIMERID_T,startidx>::Node> & item2) {
					if (item2.lock()->count()==0) {
						return true;
					} else if (item1.lock()->count()==0) {
						return false;
					} else {
						return item1.lock()->nexttime()<=item2.lock()->nexttime();
					}
				});
		/* find timeout nodes, adjust their nexttimes, call their callback functions */
		now=boost::chrono::steady_clock::now();
		for(tpos=m_timerlist.begin();tpos!=m_timerlist.end();++tpos) {
			if ((*tpos).lock()->nexttime()<=now) {
				auto elem=(*tpos).lock();
				if (elem->count()!=0) {
					elem->fire();
					elem->renew(now);
				} else {
					break;
				}
			} else {
				break;
			}
		}
		m_timerlist.sort(
				[](boost::weak_ptr<Timer<OWNER_T,TIMERID_T,startidx>::Node> & item1, boost::weak_ptr<Timer<OWNER_T,TIMERID_T,startidx>::Node> & item2) {
					if (item2.lock()->count()==0) {
						return true;
					} else if (item1.lock()->count()==0) {
						return false;
					} else {
						return item1.lock()->nexttime()<=item2.lock()->nexttime();
					}
				});
		/* find nearest time for the next timeout */
		if (m_timerlist.empty()) {
			waittime=boost::chrono::seconds(10);
		} else {
			auto elem=m_timerlist.front().lock();
			if (elem->count()==0) {
				waittime=boost::chrono::seconds(10);
			} else {
				waittime=elem->nexttime()-now;
			}
		}
#ifdef TIMER_ENABLE_LOG
		LOG(trace)<<"Timer::timer_loop[wait_time(ns)="<<waittime.count()<<"]";
#endif /* TIMER_ENABLE_LOG */
		m_cond.wait_for(ul,waittime);
#ifdef TIMER_ENABLE_LOG
		LOG(trace)<<"Timer::timer_loop[wake_up]";
#endif /* TIMER_ENABLE_LOG */
	}
}
template<typename OWNER_T,typename TIMERID_T,TIMERID_T startidx>
void Timer<OWNER_T,TIMERID_T,startidx>::wakeup_thread(bool adopt, bool terminate)
{
	if (adopt) {
		m_termflag=terminate;
	} else {
		boost::lock_guard<boost::mutex> lg(m_condmutex);
		m_termflag=terminate;
	}
	m_cond.notify_one();
}

typedef Timer<int,unsigned long,1024> BasicTimer;
typedef boost::shared_ptr<BasicTimer> SharedTimer;
void timerinit();
SharedTimer getSharedTimer();
#ifdef TIMER_DEFINE_VAR
	SharedTimer _g_shared_timer;
#endif /* TIMER_DEFINE_VAR */

#endif /* __TIMER_HPP__ */
