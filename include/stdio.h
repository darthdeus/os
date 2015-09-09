#ifndef STDIO_H
#define STDIO_H

#if defined(__cplusplus)
extern "C" {
#endif

int puts(const char*);
int printf(const char* __restrict, ...);
int putchar(int);

#if defined(__cplusplus)
}
#endif

#endif /* STDIO_H */
