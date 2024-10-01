#ifndef __RING_BUFFER_H__
#define __RING_BUFFER_H__
#ifdef COMMON_RINGBUFFER_ENABLE

#include "common/common.h"
#include "common/log.h"

// #define RING_BUFFER_COUNT (USIZE)2
// #define RING_BUFFER_LENGTH (USIZE)8

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

template<typename NODE_T, USIZE RING_BUFFER_COUNT, USIZE RING_BUFFER_LENGTH> class RingBuffer {
public:
  RingBuffer(const NODE_T &default_value, RingBufferFullStrategy default_strategy=RINGBUFFER_FULL_ERROR);
  RingBufferStatus getStatus(ISIZE index=0);
  BOOL produce(const NODE_T &value, ISIZE index=0);
  BOOL consume(NODE_T &value, ISIZE index=0);
  BOOL getFirst(NODE_T &value, ISIZE index=0);
  BOOL setFirst(const NODE_T &value, ISIZE index=0);
  BOOL getLast(NODE_T &value, ISIZE index=0);
  BOOL setLast(const NODE_T &value, ISIZE index=0);
  VD setStrategy(RingBufferFullStrategy strategy, ISIZE index=-1);
  RingBufferFullStrategy getStrategy(ISIZE index=0);
private:
  BOOL getValueByPos(NODE_T &value, USIZE pos, ISIZE index=0);
  BOOL setValueByPos(const NODE_T &value, USIZE pos, ISIZE index=0);
  NODE_T nodes[RING_BUFFER_COUNT][RING_BUFFER_LENGTH];
  USIZE points_w[RING_BUFFER_COUNT];
  USIZE points_r[RING_BUFFER_COUNT];
  RingBufferFullStrategy strategies[RING_BUFFER_COUNT];
};

template<typename NODE_T, USIZE RING_BUFFER_COUNT, USIZE RING_BUFFER_LENGTH>
RingBuffer<NODE_T, RING_BUFFER_COUNT, RING_BUFFER_LENGTH>::RingBuffer(const NODE_T &default_value, RingBufferFullStrategy default_strategy)
{
  for (USIZE i = 0; i < RING_BUFFER_COUNT; i++) {
    points_r[i] = 0;
    points_w[i] = 0;
    strategies[i] = default_strategy;
    for (USIZE j = 0; j < RING_BUFFER_LENGTH; j++) {
      nodes[i][j] = default_value;
    }
  }
}

template<typename NODE_T, USIZE RING_BUFFER_COUNT, USIZE RING_BUFFER_LENGTH>
RingBufferStatus RingBuffer<NODE_T, RING_BUFFER_COUNT, RING_BUFFER_LENGTH>::getStatus(ISIZE index)
{
  RingBufferStatus ret = RINGBUFFER_STATUS_OUTOFRANGE;
  if (index == -1) {
    if (points_r[0] == points_w[0]) {
      ret = RINGBUFFER_STATUS_EMPTY;
    } else if (((points_w[0] + 1) % RING_BUFFER_LENGTH) == points_r[0]) {
      ret = RINGBUFFER_STATUS_FULL;
    } else {
      ret = RINGBUFFER_STATUS_PARTLY;
    }
    for (USIZE i = 1; i < RING_BUFFER_COUNT; i++) {
      if (points_r[i] == points_w[i]) {
        if (RINGBUFFER_STATUS_EMPTY != ret) {
#ifdef RINGBUFFER_ENABLE_LOG
          LOG(INFO)<<"status different from: "<<i;
#endif /* RINGBUFFER_ENABLE_LOG */
          ret = RINGBUFFER_STATUS_INCONSISTENT;
          break;
        }
      } else if (((points_w[i] + 1) % RING_BUFFER_LENGTH) == points_r[i]) {
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
  } else if ((index >= 0) && (index < RING_BUFFER_COUNT)) {
    if (points_r[index] == points_w[index]) {
      ret = RINGBUFFER_STATUS_EMPTY;
    } else if (((points_w[index] + 1) % RING_BUFFER_LENGTH) == points_r[index]) {
      ret = RINGBUFFER_STATUS_FULL;
    } else {
      ret = RINGBUFFER_STATUS_PARTLY;
    }
  } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"index out of range: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
  }
  return ret;
}

template<typename NODE_T, USIZE RING_BUFFER_COUNT, USIZE RING_BUFFER_LENGTH>
BOOL RingBuffer<NODE_T, RING_BUFFER_COUNT, RING_BUFFER_LENGTH>::produce(const NODE_T &value, ISIZE index)
{
  BOOL ret = FALSE;
  auto sts = getStatus(index);
  if ((RINGBUFFER_STATUS_EMPTY == sts) || (RINGBUFFER_STATUS_PARTLY == ret)) {
    nodes[index][points_w[index]] = value;
    points_w[index] = (points_w[index] + 1) % RING_BUFFER_LENGTH;
    ret = TRUE;
  } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"full / index out of range: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
  }
  return ret;
}

template<typename NODE_T, USIZE RING_BUFFER_COUNT, USIZE RING_BUFFER_LENGTH>
BOOL RingBuffer<NODE_T, RING_BUFFER_COUNT, RING_BUFFER_LENGTH>::consume(NODE_T &value, ISIZE index)
{
  BOOL ret = FALSE;
  auto sts = getStatus(index);
  if ((RINGBUFFER_STATUS_FULL == sts) || (RINGBUFFER_STATUS_PARTLY == ret)) {
    value = nodes[index][points_r[index]];
    points_r[index] = (points_r[index] + 1) % RING_BUFFER_LENGTH;
    ret = TRUE;
  } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"empty / index out of range: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
  }
  return ret;
}

template<typename NODE_T, USIZE RING_BUFFER_COUNT, USIZE RING_BUFFER_LENGTH>
BOOL RingBuffer<NODE_T, RING_BUFFER_COUNT, RING_BUFFER_LENGTH>::getValueByPos(NODE_T &value, USIZE pos, ISIZE index)
{
  BOOL ret = FALSE;
  auto sts = getStatus(index);
  if (pos >= RING_BUFFER_LENGTH) {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"pos out of range: "<<pos;
#endif /* RINGBUFFER_ENABLE_LOG */
  } else if ((0 <= index) || (RING_BUFFER_COUNT > index)) {
    value = nodes[index][pos];
    ret = TRUE;
  } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"empty / index out of range: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
  }
  return ret;
}

template<typename NODE_T, USIZE RING_BUFFER_COUNT, USIZE RING_BUFFER_LENGTH>
BOOL RingBuffer<NODE_T, RING_BUFFER_COUNT, RING_BUFFER_LENGTH>::setValueByPos(const NODE_T &value, USIZE pos, ISIZE index)
{
  BOOL ret = FALSE;
  if (pos >= RING_BUFFER_LENGTH) {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"pos out of range: "<<pos;
#endif /* RINGBUFFER_ENABLE_LOG */
  } else if ((0 <= index) || (RING_BUFFER_COUNT > index)) {
    nodes[index][pos] = value;
    ret = TRUE;
  } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"empty / index out of range: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
  }
  return ret;
}

template<typename NODE_T, USIZE RING_BUFFER_COUNT, USIZE RING_BUFFER_LENGTH>
BOOL RingBuffer<NODE_T, RING_BUFFER_COUNT, RING_BUFFER_LENGTH>::getFirst(NODE_T &value, ISIZE index)
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

template<typename NODE_T, USIZE RING_BUFFER_COUNT, USIZE RING_BUFFER_LENGTH>
BOOL RingBuffer<NODE_T, RING_BUFFER_COUNT, RING_BUFFER_LENGTH>::setFirst(const NODE_T &value, ISIZE index)
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

template<typename NODE_T, USIZE RING_BUFFER_COUNT, USIZE RING_BUFFER_LENGTH>
BOOL RingBuffer<NODE_T, RING_BUFFER_COUNT, RING_BUFFER_LENGTH>::getLast(NODE_T &value, ISIZE index)
{
  BOOL ret = FALSE;
  auto sts = getStatus(index);
  if ((RINGBUFFER_STATUS_FULL == sts) || (RINGBUFFER_STATUS_PARTLY == ret)) {
    ret = getValueByPos(value, (points_w[index] + RING_BUFFER_LENGTH - 1) % RING_BUFFER_LENGTH, index);
  } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"empty / index out of range: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
  }
  return ret;
}

template<typename NODE_T, USIZE RING_BUFFER_COUNT, USIZE RING_BUFFER_LENGTH>
BOOL RingBuffer<NODE_T, RING_BUFFER_COUNT, RING_BUFFER_LENGTH>::setLast(const NODE_T &value, ISIZE index)
{
  BOOL ret = FALSE;
  auto sts = getStatus(index);
  if ((RINGBUFFER_STATUS_FULL == sts) || (RINGBUFFER_STATUS_PARTLY == ret)) {
    ret = setValueByPos(value, (points_w[index] + RING_BUFFER_LENGTH - 1) % RING_BUFFER_LENGTH, index);
  } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"empty / index out of range: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
  }
  return ret;
}

template<typename NODE_T, USIZE RING_BUFFER_COUNT, USIZE RING_BUFFER_LENGTH>
VD RingBuffer<NODE_T, RING_BUFFER_COUNT, RING_BUFFER_LENGTH>::setStrategy(RingBufferFullStrategy strategy, ISIZE index)
{
  if (index == -1) {
    for (USIZE i = 0; i < RING_BUFFER_COUNT; i++) {
      strategies[i] = strategy;
    }
  } else if ((index >= 0) && (index < RING_BUFFER_COUNT)) {
    strategies[index] = strategy;
  } else {
#ifdef RINGBUFFER_ENABLE_LOG
    LOG(WARNING)<<"index out of range: "<<index;
#endif /* RINGBUFFER_ENABLE_LOG */
  }
}

template<typename NODE_T, USIZE RING_BUFFER_COUNT, USIZE RING_BUFFER_LENGTH>
RingBufferFullStrategy RingBuffer<NODE_T, RING_BUFFER_COUNT, RING_BUFFER_LENGTH>::getStrategy(ISIZE index)
{
  RingBufferFullStrategy ret = RINGBUFFER_FULL_OUTOFRANGE;
  if (index == -1) {
    ret = strategies[0];
    for (USIZE i = 1; i < RING_BUFFER_COUNT; i++) {
      if (ret != strategies[i]) {
        ret = RINGBUFFER_FULL_INCONSISTENT;
        break;
      }
    }
  } else if ((index >= 0) && (index < RING_BUFFER_COUNT)) {
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
