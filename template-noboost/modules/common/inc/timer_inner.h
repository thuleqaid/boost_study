#ifndef _TIMER_INNER_H_
#define _TIMER_INNER_H_
#ifdef COMMON_TIMER_ENABLE

#include <thread>
#include <mutex>
#include <condition_variable>
#include <limits>
#include <set>
#include <list>
#include "common/timer.h"
#include "common/log.h"

template<typename OWNER_T,typename TIMERID_T, TIMERID_T startidx> class Timer
{
public:
  typedef void (*TimeOutFunc)(TIMERID_T);
  Timer(const TIMERID_T &start_timerid=startidx);
  ~Timer();
  TIMERID_T timer_new(const TimeOutFunc &func, const std::shared_ptr<OWNER_T> &ptshare=nullptr, const TIMERID_T &timerid=std::numeric_limits<TIMERID_T>::min());
  BOOL timer_start(const TIMERID_T &timerid, const std::chrono::steady_clock::duration &interval=std::chrono::seconds(1), const USIZE count=1);
  BOOL timer_stop(const TIMERID_T &timerid);
  BOOL timer_delete(const TIMERID_T &timerid);
  BOOL timer_running() const { return m_running; }
protected:
  class Node
  {
  public:
    Node(const TimeOutFunc &func, const std::shared_ptr<OWNER_T> &ptshare, const TIMERID_T &timerid)
      :m_func(func)
      ,m_parent(ptshare)
      ,m_id(timerid)
      ,m_count(0)
    {
#ifdef TIMER_ENABLE_LOG
      LOG(INFO)<<"Timer::Node::Node["<<m_id<<"]"<<EOL;
#endif /* TIMER_ENABLE_LOG */
    }
    ~Node() {
#ifdef TIMER_ENABLE_LOG
      LOG(INFO)<<"Timer::Node::~Node["<<m_id<<"]"<<EOL;
#endif /* TIMER_ENABLE_LOG */
    }
    const TIMERID_T& id() const { return m_id; }
    BOOL valid() const { return !m_parent.expired(); }
    const std::chrono::steady_clock::time_point& nexttime() const { return m_nexttime; }
    USIZE count() const { return m_count; }
    VD setInterval(const std::chrono::steady_clock::duration &interval)
    {
      m_interval=interval;
#ifdef TIMER_ENABLE_LOG
      LOG(INFO)<<"Timer::Node::setInterval[id="<<m_id<<",interval(ns)="<<m_interval.count()<<"]"<<EOL;
#endif /* TIMER_ENABLE_LOG */
    }
    VD setCount(const USIZE count)
    {
      m_count=count;
#ifdef TIMER_ENABLE_LOG
      LOG(INFO)<<"Timer::Node::setCount[id="<<m_id<<",count="<<m_count<<"]"<<EOL;
#endif /* TIMER_ENABLE_LOG */
    }
    VD renew(const std::chrono::steady_clock::time_point &base_tp)
    {
      if (m_count!=0) {
        m_nexttime=base_tp+m_interval;
      }
    }
    VD renew()
    {
      if (m_count!=0) {
        m_nexttime+=m_interval;
      }
    }
    VD fire()
    {
      if (m_count==0) {
      } else {
        if (m_count>0) {
          m_count--;
        }
#ifdef TIMER_ENABLE_LOG
        LOG(INFO)<<"Timer::Node::fire[id="<<m_id<<",count="<<m_count<<"]"<<EOL;
#endif /* TIMER_ENABLE_LOG */
        m_func(m_id);
      }
    }
  private:
    TimeOutFunc m_func;
    std::weak_ptr<OWNER_T> m_parent;
    TIMERID_T m_id;
    USIZE m_count;
    std::chrono::steady_clock::duration m_interval;
    std::chrono::steady_clock::time_point m_nexttime;
  };
  struct SharedNodeCmp
  {
    BOOL operator() (const std::shared_ptr<Node> &n1, const std::shared_ptr<Node> &n2) const
    {
      return n1->id()<n2->id();
    }
  };
  VD timer_loop();
  VD wakeup_thread(BOOL locked, BOOL terminate);
  std::shared_ptr<Node> get_node_by_timerid(const TIMERID_T &timerid)
  {
    std::shared_ptr<Node> node=nullptr;
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
  std::shared_ptr<OWNER_T> m_sharedOwner;
  TIMERID_T m_start;
  TIMERID_T m_current;
  std::thread m_thread;
  std::condition_variable m_cond;
  std::mutex m_condmutex;
  BOOL m_termflag;
  BOOL m_running;
  std::set<std::shared_ptr<Node>,SharedNodeCmp> m_nodelist;
  std::list<std::weak_ptr<Node>> m_timerlist;
};

template<typename OWNER_T,typename TIMERID_T,TIMERID_T startidx>
Timer<OWNER_T,TIMERID_T,startidx>::Timer(const TIMERID_T &start_timerid)
  :m_sharedOwner(new OWNER_T())
  ,m_start(start_timerid<=std::numeric_limits<TIMERID_T>::min()?std::numeric_limits<TIMERID_T>::min()+1:start_timerid)
  ,m_current(m_start)
  ,m_thread(&Timer<OWNER_T,TIMERID_T,startidx>::timer_loop,this)
  ,m_termflag(FALSE)
  ,m_running(FALSE)
{
}
template<typename OWNER_T,typename TIMERID_T,TIMERID_T startidx>
Timer<OWNER_T,TIMERID_T,startidx>::~Timer()
{
  if (m_thread.joinable()) {
    wakeup_thread(FALSE,TRUE);
    m_thread.join();
  }
}
template<typename OWNER_T,typename TIMERID_T,TIMERID_T startidx>
TIMERID_T Timer<OWNER_T,TIMERID_T,startidx>::timer_new(const TimeOutFunc &func, const std::shared_ptr<OWNER_T> &ptshare, const TIMERID_T &timerid)
{
  TIMERID_T newid;
  std::lock_guard<std::mutex> lg(m_condmutex);
#ifdef TIMER_ENABLE_LOG
  LOG(INFO)<<"Timer::timer_new[request-id="<<timerid<<"]"<<EOL;
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
      LOG(INFO)<<"Timer::timer_new[id="<<newid<<",owner=None]"<<EOL;
#endif /* TIMER_ENABLE_LOG */
      std::shared_ptr<Node> temp(new Node(func,m_sharedOwner,newid));
      m_nodelist.insert(temp);
      m_timerlist.push_back(std::weak_ptr<Node>(temp));
    } else {
#ifdef TIMER_ENABLE_LOG
      LOG(INFO)<<"Timer::timer_new[id="<<newid<<",owner="<<ptshare<<"]"<<EOL;
#endif /* TIMER_ENABLE_LOG */
      std::shared_ptr<Node> temp(new Node(func,ptshare,newid));
      m_nodelist.insert(temp);
      m_timerlist.push_back(std::weak_ptr<Node>(temp));
    }
  } else {
#ifdef TIMER_ENABLE_LOG
    LOG(WARNING)<<"Timer::timer_new[id=None,owner=None]"<<EOL;
#endif /* TIMER_ENABLE_LOG */
  }
  return newid;
}

template<typename OWNER_T,typename TIMERID_T,TIMERID_T startidx>
BOOL Timer<OWNER_T,TIMERID_T,startidx>::timer_start(const TIMERID_T &timerid, const std::chrono::steady_clock::duration &interval, const USIZE count)
{
  BOOL ret=TRUE;
  std::lock_guard<std::mutex> lg(m_condmutex);
  auto elem=get_node_by_timerid(timerid);
  if (elem!=nullptr) {
#ifdef TIMER_ENABLE_LOG
    LOG(INFO)<<"Timer::timer_start[id="<<timerid<<"]"<<EOL;
#endif /* TIMER_ENABLE_LOG */
    elem->setInterval(interval);
    elem->setCount(count);
    elem->renew(std::chrono::steady_clock::now());
    wakeup_thread(TRUE,FALSE);
    ret=TRUE;
  } else {
#ifdef TIMER_ENABLE_LOG
    LOG(WARNING)<<"Timer::timer_start[id="<<timerid<<"]"<<EOL;
#endif /* TIMER_ENABLE_LOG */
    ret=FALSE;
  }
  return ret;
}
template<typename OWNER_T,typename TIMERID_T,TIMERID_T startidx>
BOOL Timer<OWNER_T,TIMERID_T,startidx>::timer_stop(const TIMERID_T &timerid)
{
  BOOL ret=TRUE;
  std::lock_guard<std::mutex> lg(m_condmutex);
  auto elem=get_node_by_timerid(timerid);
  if (elem!=nullptr) {
#ifdef TIMER_ENABLE_LOG
    LOG(INFO)<<"Timer::timer_stop[id="<<timerid<<"]"<<EOL;
#endif /* TIMER_ENABLE_LOG */
    elem->setCount(0);
    ret=TRUE;
  } else {
#ifdef TIMER_ENABLE_LOG
    LOG(WARNING)<<"Timer::timer_stop[id="<<timerid<<"]"<<EOL;
#endif /* TIMER_ENABLE_LOG */
    ret=FALSE;
  }
  return ret;
}
template<typename OWNER_T,typename TIMERID_T,TIMERID_T startidx>
BOOL Timer<OWNER_T,TIMERID_T,startidx>::timer_delete(const TIMERID_T &timerid)
{
  BOOL ret=TRUE;
  std::lock_guard<std::mutex> lg(m_condmutex);
  auto elem=get_node_by_timerid(timerid);
  if (elem!=nullptr) {
#ifdef TIMER_ENABLE_LOG
    LOG(INFO)<<"Timer::timer_delete[id="<<timerid<<"]"<<EOL;
#endif /* TIMER_ENABLE_LOG */
    m_nodelist.erase(elem);
    ret=TRUE;
  } else {
#ifdef TIMER_ENABLE_LOG
    LOG(WARNING)<<"Timer::timer_delete[id="<<timerid<<"]"<<EOL;
#endif /* TIMER_ENABLE_LOG */
    ret=FALSE;
  }
  return ret;
}
template<typename OWNER_T,typename TIMERID_T,TIMERID_T startidx>
VD Timer<OWNER_T,TIMERID_T,startidx>::timer_loop()
{
  std::unique_lock<std::mutex> ul(m_condmutex);
  std::chrono::steady_clock::time_point now;
  std::chrono::steady_clock::duration waittime;
  auto npos=m_nodelist.end();
  auto tpos=m_timerlist.end();
  while(TRUE) {
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
                          [](std::weak_ptr<Timer<OWNER_T,TIMERID_T,startidx>::Node> & item) {
                            return item.expired();
                          });
    /* sort timerlist */
    m_timerlist.sort(
                     [](std::weak_ptr<Timer<OWNER_T,TIMERID_T,startidx>::Node> & item1, std::weak_ptr<Timer<OWNER_T,TIMERID_T,startidx>::Node> & item2) {
                       if (item2.lock()->count()==0) {
                         return TRUE;
                       } else if (item1.lock()->count()==0) {
                         return FALSE;
                       } else {
                         return item1.lock()->nexttime()<=item2.lock()->nexttime();
                       }
                     });
    /* find timeout nodes, adjust their nexttimes, call their callback functions */
    now=std::chrono::steady_clock::now();
    for(tpos=m_timerlist.begin();tpos!=m_timerlist.end();++tpos) {
      if ((*tpos).lock()->nexttime()<=now) {
        auto elem=(*tpos).lock();
        if (elem->count()!=0) {
          elem->fire();
          elem->renew();
        } else {
          break;
        }
      } else {
        break;
      }
    }
    m_timerlist.sort(
                     [](std::weak_ptr<Timer<OWNER_T,TIMERID_T,startidx>::Node> & item1, std::weak_ptr<Timer<OWNER_T,TIMERID_T,startidx>::Node> & item2) {
                       if (item2.lock()->count()==0) {
                         return TRUE;
                       } else if (item1.lock()->count()==0) {
                         return FALSE;
                       } else {
                         return item1.lock()->nexttime()<=item2.lock()->nexttime();
                       }
                     });
    /* find nearest time for the next timeout */
    if (m_timerlist.empty()) {
      waittime=std::chrono::seconds(10);
      m_running=FALSE;
    } else {
      auto elem=m_timerlist.front().lock();
      if (elem->count()==0) {
        waittime=std::chrono::seconds(10);
        m_running=FALSE;
      } else {
        waittime=elem->nexttime()-now;
        m_running=TRUE;
      }
    }
#ifdef TIMER_ENABLE_LOG
    LOG(INFO)<<"Timer::timer_loop[wait_time(ns)="<<waittime.count()<<"]"<<EOL;
#endif /* TIMER_ENABLE_LOG */
    m_cond.wait_for(ul,waittime);
  }
}
template<typename OWNER_T,typename TIMERID_T,TIMERID_T startidx>
VD Timer<OWNER_T,TIMERID_T,startidx>::wakeup_thread(BOOL locked, BOOL terminate)
{
  if (locked) {
    m_termflag=terminate;
  } else {
    std::lock_guard<std::mutex> lg(m_condmutex);
    m_termflag=terminate;
  }
  m_cond.notify_one();
}

typedef Timer<TIMER_OWNER_T,TIMER_ID_T,TIMER_AUTO_ID_START> BasicTimer;
typedef std::shared_ptr<BasicTimer> SharedTimer;

#endif /* COMMON_TIMER_ENABLE */
#endif /* _TIMER_INNER_H_ */
