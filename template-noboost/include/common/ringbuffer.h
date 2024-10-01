#ifndef __RING_BUFFER_H__
#define __RING_BUFFER_H__
#ifdef COMMON_RINGBUFFER_ENABLE

#include <vector>
#include "common/common.h"
#include "common/log.h"

typedef enum {
  RINGBUFFER_FULL_ERROR,
  RINGBUFFER_FULL_OVERWRITE,
  RINGBUFFER_FULL_INCONSISTENT,
  RINGBUFFER_FULL_OUTOFRANGE
} RingBufferFullStrategy;

typedef enum {
  RINGBUFFER_STATUS_EMPTY,
  RINGBUFFER_STATUS_PARTLY,
  RINGBUFFER_STATUS_FULL,
  RINGBUFFER_STATUS_INCONSISTENT,
  RINGBUFFER_STATUS_OUTOFRANGE
} RingBufferStatus;

template<typename NODE_T> class RingBuffer {
public:
  RingBuffer(const NODE_T &default_value, USIZE buffer_length, USIZE buffer_count=1, RingBufferFullStrategy default_strategy=RINGBUFFER_FULL_ERROR);
  RingBufferStatus getStatus(ISIZE index=0);
  BOOL produce(const NODE_T &value, ISIZE index=0);
  BOOL consume(NODE_T &value, ISIZE index=0);
  BOOL getFirst(NODE_T &value, ISIZE index=0);
  BOOL setFirst(const NODE_T &value, ISIZE index=0);
  BOOL getLast(NODE_T &value, ISIZE index=0);
  BOOL setLast(const NODE_T &value, ISIZE index=0);
  BOOL setStrategy(const RingBufferFullStrategy &strategy, ISIZE index=-1);
  RingBufferFullStrategy getStrategy(ISIZE index=0);
private:
  BOOL getValueByPos(NODE_T &value, USIZE pos, ISIZE index=0);
  BOOL setValueByPos(const NODE_T &value, USIZE pos, ISIZE index=0);
  USIZE bufcount;
  USIZE buflength;
  std::vector<std::vector<NODE_T>> nodes;
  std::vector<USIZE> counts;
  std::vector<USIZE> points_r;
  std::vector<RingBufferFullStrategy> strategies;
};

template<typename NODE_T>
RingBuffer<NODE_T>::RingBuffer(const NODE_T &default_value, USIZE buffer_length, USIZE buffer_count, RingBufferFullStrategy default_strategy)
  :bufcount(buffer_count>0?buffer_count:1),
   buflength(buffer_length>0?buffer_length:1),
   nodes(bufcount, std::vector<NODE_T>(buflength, default_value)),
   counts(bufcount, 0),
   points_r(bufcount, 0),
   strategies(bufcount, default_strategy)
{
#ifdef RINGBUFFER_ENABLE_LOG
  LOG(INFO)<<"Buffer_Count="<<bufcount<<" Buffer_Length="<<buflength;
#endif /* RINGBUFFER_ENABLE_LOG */
}

template<typename NODE_T>
RingBufferStatus RingBuffer<NODE_T>::getStatus(ISIZE index)
{
  RingBufferStatus ret = RINGBUFFER_STATUS_OUTOFRANGE;
  if (index == -1) {
    if (0 == counts[0]) {
      ret = RINGBUFFER_STATUS_EMPTY;
    } else if (buflength == counts[0]) {
      ret = RINGBUFFER_STATUS_FULL;
    } else {
      ret = RINGBUFFER_STATUS_PARTLY;
    }
    for (USIZE i = 1; i < bufcount; i++) {
      if (0 == counts[i]) {
        if (RINGBUFFER_STATUS_EMPTY != ret) {
#ifdef RINGBUFFER_ENABLE_LOG
          LOG(INFO)<<"status different from: "<<i;
#endif /* RINGBUFFER_ENABLE_LOG */
          ret = RINGBUFFER_STATUS_INCONSISTENT;
          break;
        }
      } else if (buflength == counts[i]) {
        if (RINGBUFFER_STATUS_FULL != ret) {
#ifdef RINGBUFFER_ENABLE_LOG
          LOG(INFO)<<"status different from: "<<i;
#endif /* RINGBUFFER_ENABLE_LOG */
          ret = RINGBUFFER_STATUS_INCONSISTENT;
          break;
        }
      } else {
        if (RINGBUFFER_STATUS_PARTLY != ret) {
#ifdef RINGBUFFER_ENABLE_LOG
          LOG(INFO)<<"status different from: "<<i;
#endif /* RINGBUFFER_ENABLE_LOG */
          ret = RINGBUFFER_STATUS_INCONSISTENT;
          break;
        }
      }
    }
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(INFO)<<"status[-1]="<<ret;
#endif /* RINGBUFFER_ENABLE_LOG */
  } else if ((index >= 0) && (index < bufcount)) {
    if (0 == counts[index]) {
      ret = RINGBUFFER_STATUS_EMPTY;
    } else if (buflength == counts[index]) {
      ret = RINGBUFFER_STATUS_FULL;
    } else {
      ret = RINGBUFFER_STATUS_PARTLY;
    }
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(INFO)<<"status["<<index<<"]="<<ret;
#endif /* RINGBUFFER_ENABLE_LOG */
  } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"index out of range: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
  }
  return ret;
}

template<typename NODE_T>
BOOL RingBuffer<NODE_T>::produce(const NODE_T &value, ISIZE index)
{
  BOOL ret = FALSE;
  auto sts = getStatus(index);
  if ((RINGBUFFER_STATUS_EMPTY == sts) || (RINGBUFFER_STATUS_PARTLY == sts)) {
    auto pos = (points_r[index] + counts[index]) % buflength;
    nodes[index][pos] = value;
    counts[index]++;
    ret = TRUE;
  } else if (RINGBUFFER_STATUS_FULL == sts) {
    if (RINGBUFFER_FULL_OVERWRITE == strategies[index]) {
      auto pos = points_r[index];
      nodes[index][pos] = value;
      points_r[index] = (points_r[index] + 1) % buflength;
      ret = TRUE;
    } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"full: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
    }
  } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"index out of range: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
  }
#ifdef RINGBUFFER_ENABLE_LOG
  LOG(INFO)<<"points_r["<<index<<"]="<<points_r[index]<<" count="<<counts[index];
#endif /* RINGBUFFER_ENABLE_LOG */
  return ret;
}

template<typename NODE_T>
BOOL RingBuffer<NODE_T>::consume(NODE_T &value, ISIZE index)
{
  BOOL ret = FALSE;
  auto sts = getStatus(index);
  if ((RINGBUFFER_STATUS_FULL == sts) || (RINGBUFFER_STATUS_PARTLY == sts)) {
    value = nodes[index][points_r[index]];
    points_r[index] = (points_r[index] + 1) % buflength;
    counts[index]--;
    ret = TRUE;
  } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"empty / index out of range: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
  }
  return ret;
}

template<typename NODE_T>
BOOL RingBuffer<NODE_T>::getValueByPos(NODE_T &value, USIZE pos, ISIZE index)
{
  BOOL ret = FALSE;
  if (pos >= buflength) {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"pos out of range: "<<pos;
#endif /* RINGBUFFER_ENABLE_LOG */
  } else if ((0 <= index) || (bufcount > index)) {
    value = nodes[index][pos];
    ret = TRUE;
  } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"empty / index out of range: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
  }
  return ret;
}

template<typename NODE_T>
BOOL RingBuffer<NODE_T>::setValueByPos(const NODE_T &value, USIZE pos, ISIZE index)
{
  BOOL ret = FALSE;
  if (pos >= buflength) {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"pos out of range: "<<pos;
#endif /* RINGBUFFER_ENABLE_LOG */
  } else if ((0 <= index) || (bufcount > index)) {
    nodes[index][pos] = value;
    ret = TRUE;
  } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"empty / index out of range: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
  }
  return ret;
}

template<typename NODE_T>
BOOL RingBuffer<NODE_T>::getFirst(NODE_T &value, ISIZE index)
{
  BOOL ret = FALSE;
  auto sts = getStatus(index);
  if ((RINGBUFFER_STATUS_FULL == sts) || (RINGBUFFER_STATUS_PARTLY == ret)) {
    ret = getValueByPos(value, points_r[index], index);
  } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"empty / index out of range: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
  }
  return ret;
}

template<typename NODE_T>
BOOL RingBuffer<NODE_T>::setFirst(const NODE_T &value, ISIZE index)
{
  BOOL ret = FALSE;
  auto sts = getStatus(index);
  if ((RINGBUFFER_STATUS_FULL == sts) || (RINGBUFFER_STATUS_PARTLY == ret)) {
    ret = setValueByPos(value, points_r[index], index);
  } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"empty / index out of range: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
  }
  return ret;
}

template<typename NODE_T>
BOOL RingBuffer<NODE_T>::getLast(NODE_T &value, ISIZE index)
{
  BOOL ret = FALSE;
  auto sts = getStatus(index);
  if ((RINGBUFFER_STATUS_FULL == sts) || (RINGBUFFER_STATUS_PARTLY == ret)) {
    auto pos = (points_r[index] + counts[index] + buflength - 1) % buflength;
    ret = getValueByPos(value, pos, index);
  } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"empty / index out of range: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
  }
  return ret;
}

template<typename NODE_T>
BOOL RingBuffer<NODE_T>::setLast(const NODE_T &value, ISIZE index)
{
  BOOL ret = FALSE;
  auto sts = getStatus(index);
  if ((RINGBUFFER_STATUS_FULL == sts) || (RINGBUFFER_STATUS_PARTLY == ret)) {
    auto pos = (points_r[index] + counts[index] + buflength - 1) % buflength;
    ret = setValueByPos(value, pos, index);
  } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"empty / index out of range: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
  }
  return ret;
}

template<typename NODE_T>
BOOL RingBuffer<NODE_T>::setStrategy(const RingBufferFullStrategy &strategy, ISIZE index)
{
  BOOL ret = TRUE;
  if (index == -1) {
    for (USIZE i = 0; i < bufcount; i++) {
      strategies[i] = strategy;
    }
  } else if ((index >= 0) && (index < bufcount)) {
    strategies[index] = strategy;
  } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"index out of range: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
    ret = FALSE;
  }
  return ret;
}

template<typename NODE_T>
RingBufferFullStrategy RingBuffer<NODE_T>::getStrategy(ISIZE index)
{
  RingBufferFullStrategy ret = RINGBUFFER_FULL_OUTOFRANGE;
  if (index == -1) {
    ret = strategies[0];
    for (USIZE i = 1; i < bufcount; i++) {
      if (ret != strategies[i]) {
        ret = RINGBUFFER_FULL_INCONSISTENT;
        break;
      }
    }
  } else if ((index >= 0) && (index < bufcount)) {
    ret = strategies[index];
  } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"index out of range: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
  }
  return ret;
}

#endif /* COMMON_RINGBUFFER_ENABLE */
#endif /* __RING_BUFFER_H__ */
