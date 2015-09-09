#ifndef STRING_H
#define STRING_H

#include <stddef.h>

#if defined(__cplusplus)
extern "C" {
#endif

int memcmp(const void*, const void*, size_t);
void* memcpy(void* __restrict, const void* __restrict, size_t);
void* memmove(void*, const void*, size_t);
void* memset(void*, int, size_t);
size_t strlen(const char*);

#if defined(__cplusplus)
}
#endif

#endif /* STRING_H */
