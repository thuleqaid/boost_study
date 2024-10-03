#ifndef _LOGSEQ_INNER_H_
#define _LOGSEQ_INNER_H_
#ifdef COMMON_LOGSEQ_ENABLE

#include <vector>
#include "common/logseq.h"
#include "common/ringbuffer.h"

#define LOGSEQ_DEFAULT_HISTORY_SIZE 32

class LogSeq {
 public:
  typedef RingBuffer<U4> LogBuffer;
  LogSeq(const U4 history_size, const U1 count_bits);
  ~LogSeq();
  VD mark(const std::string& label);
  std::vector<std::string> getLabels() const;
  std::vector<U4> getHistory() const;
 private:
  U1 count_reserve;
  U4 count_mask;
  U4 label_mask;
  U4 max_label_count;
  LogBuffer history;
  std::vector<std::string> labels;
};

#endif /* COMMON_LOGSEQ_ENABLE */
#endif /* _LOGSEQ_INNER_H_ */
