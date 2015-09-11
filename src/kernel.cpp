#if !defined(__cplusplus)
#include <stdbool.h> /* C doesn't have booleans by default. */
#endif
#include <stddef.h>
#include <stdint.h>
#include <kernel/tty.h>
#include <stdio.h>

/* Check if the compiler thinks we are targeting the wrong operating system. */
#if defined(__linux__)
#error \
    "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

/* This tutorial will only work for the 32-bit ix86 targets. */
#if !defined(__i386__)
#error "This tutorial needs to be compiled with a ix86-elf compiler"
#endif

void sleep(int ms) {
  // TODO - force no optimization on this, so far -O0 should work well enough
  int x = 50000 * ms;
  while (x--)
    ;
}

struct derp {
  derp() { printf("derp()\n"); }
  ~derp() { printf("~derp()\n"); }
};

derp d;

// __attribute__((constructor)) void foo() { printf("foo is a ctor\n"); }

#if defined(__cplusplus)
extern "C" {
#endif

void kernel_early() {
  terminal_initialize();
  printf("early\n");
}

void kernel_main() {
  /* Since there is no support for newlines in terminal_putchar
         * yet, '\n' will produce some VGA specific character instead.
         * This is normal.
         */
  int i = 1;

  while (i++ < 20) {
    /* putchar('c'); */
    /* puts("hello"); */
    /* terminal_putchar('0' + (i % 10)); */
    /* terminal_putchar('\n'); */
  }
  printf("main() exited\n");
}

#if defined(__cplusplus)
}
#endif
