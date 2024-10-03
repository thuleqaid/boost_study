#ifdef COMMON_LOGSEQ_ENABLE
#include <algorithm>
#include "common/log.h"
#include "logseq_inner.h"

LogSeq::LogSeq(const U4 history_size, const U1 count_bits)
  :count_reserve(count_bits>=32?0:count_bits)
  ,count_mask((1<<count_reserve) - 1)
  ,label_mask(count_reserve==0?0xffffffff:(1<<(32-count_reserve))-1)
  ,max_label_count(count_reserve==0?label_mask-3:label_mask)
  ,history(0, history_size<=0?LOGSEQ_DEFAULT_HISTORY_SIZE:history_size)
{
  history.setStrategy(RINGBUFFER_FULL_OVERWRITE);
}

LogSeq::~LogSeq()
{
}

VD LogSeq::mark(const std::string& label)
{
  auto pos = find(labels.begin(), labels.end(), label);
  auto idx = labels.size();
  if (pos != labels.end()) {
    idx = distance(labels.begin(), pos);
#ifdef LOGSEQ_ENABLE_LOG
    LOG(INFO)<<"insert old mark: "<<labels[idx]<<EOL;
#endif /* LOGSEQ_ENABLE_LOG */
  } else {
    if (idx < max_label_count) {
      labels.push_back(label);
#ifdef LOGSEQ_ENABLE_LOG
    LOG(INFO)<<"add new mark: "<<labels[idx]<<EOL;
#endif /* LOGSEQ_ENABLE_LOG */
    } else {
#ifdef LOGSEQ_ENABLE_LOG
    LOG(WARNING)<<"count of labels beyond max value"<<EOL;
#endif /* LOGSEQ_ENABLE_LOG */
    }
  }
  if (idx < max_label_count) {
    if (count_reserve > 0) {
      U4 value = 0;
      if (TRUE == history.getLast(value)) {
        if ((value >> count_reserve) != idx) {
          value = ((idx & label_mask) << count_reserve) | 0x01;
          history.produce(value);
        } else {
          U4 count = value & count_mask;
          if (count < count_mask) {
            count++;
            value = (value & (~count_mask)) | count;
            history.setLast(value);
          }
#ifdef LOGSEQ_ENABLE_LOG
          LOG(INFO)<<"update count of last mark"<<EOL;
#endif /* LOGSEQ_ENABLE_LOG */
        }
      } else {
        value = ((idx & label_mask) << count_reserve) | 0x01;
        history.produce(value);
      }
    } else {
      history.produce(idx);
    }
  }
}
std::vector<std::string> LogSeq::getLabels() const
{
  return std::vector<std::string>(labels.begin(), labels.end());
}
std::vector<U4> LogSeq::getHistory() const
{
  return history.getAll();
}


static LogSeq *logseq = nullptr;
VD Logseq_init(const U4 history_size, const U1 count_bits)
{
  logseq = new LogSeq(history_size, count_bits);
}
VD Logseq_mark(const std::string& label)
{
  logseq->mark(label);
}
VD Logseq_destroy()
{
  delete logseq;
}

#endif /* COMMON_LOGSEQ_ENABLE */
