#include <stddef.h>
#include <string.h>

typedef unsigned char* ucp;

size_t strlen(const char* p) {
  size_t s = 0;
  while (*p++) s++;

  return s;
}

int memcmp(const void* x, const void* y, size_t size) {
  const ucp a = (const ucp)x;
  const ucp b = (const ucp)y;
  for (size_t i = 0; i < size; ++i) {
    if (a[i] < b[i])
      return -1;
    else if (a[i] > b[i])
      return 1;
  }

  return 0;
}

void* memcpy(void* restrict dstptr, const void* restrict srcptr, size_t size) {
  ucp dst = (ucp)dstptr;
  const ucp src = (const ucp)srcptr;

  for (size_t i = 0; i < size; ++i) dst[i] = src[i];

  return dstptr;
}

void* memmove(void* dstptr, const void* srcptr, size_t size) {
  ucp dst = (ucp)dstptr;
  const ucp src = (const ucp)srcptr;

  if (dst < src) {
    for (size_t i = 0; i < size; i++) dst[i] = src[i];
  } else {
    for (size_t i = size; i; i--) dst[i - 1] = src[i - 1];
  }

  return dstptr;
}

void* memset(void* bufptr, int value, size_t size) {
  ucp buf = (ucp)bufptr;

  for (size_t i = 0; i < size; i++) buf[i] = (unsigned char)value;

  return bufptr;
}
