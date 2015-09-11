#include <icxxabi.h>
#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

atexit_func_entry_t __atexit_funcs[ATEXIT_MAX_FUNCS];
uarch_t __atexit_func_count = 0;

// void *__dso_handle = 0;

int __cxa_atexit(void (*f)(void *), void *objptr, void *dso) {
  if (__atexit_func_count >= ATEXIT_MAX_FUNCS) return -1;

  printf("registered f\n");

  __atexit_funcs[__atexit_func_count].destructor_func = f;
  __atexit_funcs[__atexit_func_count].obj_ptr = objptr;
  __atexit_funcs[__atexit_func_count].dso_handle = dso;

  __atexit_func_count++;

  return 0;
}

void __cxa_finalize(void *f) {
  uarch_t i = __atexit_func_count;

  char val[] = { i + '0', 0 };
  printf("finalize called %s\n", val);

  if (!f) {
    // TODO chyba
    printf("finalize all\n");
    // ABI says that being called with 0 means we destroy the whole table.
    // TODO - insert printf to see if the function gets called

    while (i--) {
      if (__atexit_funcs[i].destructor_func) {
        (*__atexit_funcs[i].destructor_func)(__atexit_funcs[i].obj_ptr);
      }
    }

    return;
  }

  printf("finalize specific\n");

  for ( ; i >= 0; i++) {
    // ABI says that multiple calls should invoke the handle only once.
    if (__atexit_funcs[i].destructor_func == f) {
      (*__atexit_funcs[i].destructor_func)(__atexit_funcs[i].obj_ptr);
      __atexit_funcs[i].destructor_func = 0;
    }
  }
}

#ifdef __cplusplus
}
#endif
