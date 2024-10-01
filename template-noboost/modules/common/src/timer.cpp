#ifdef COMMON_TIMER_ENABLE
#include "timer_inner.h"

static SharedTimer _g_shared_timer;
VD Timer_init()
{
  _g_shared_timer.reset(new BasicTimer());
}
VD Timer_destroy()
{
  _g_shared_timer.reset();
}

TIMER_ID_T Timer_newTimer(const TimeOutFunc &func, const std::shared_ptr<TIMER_OWNER_T> &ptshare)
{
  return _g_shared_timer->timer_new(func, ptshare);
}

BOOL Timer_startTimer(const TIMER_ID_T &timerid, const std::chrono::steady_clock::duration &interval, const USIZE count)
{
  return _g_shared_timer->timer_start(timerid, interval, count);
}

BOOL Timer_stopTimer(const TIMER_ID_T &timerid)
{
  return _g_shared_timer->timer_stop(timerid);
}

BOOL Timer_deleteTimer(const TIMER_ID_T &timerid)
{
  return _g_shared_timer->timer_delete(timerid);
}

BOOL Timer_running()
{
  return _g_shared_timer->timer_running();
}
#endif /* COMMON_TIMER_ENABLE */
