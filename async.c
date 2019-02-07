#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

typedef void(*FUNC)(void*);

FUNC CB;
pthread_t th;

void set(void* f) {
  CB = (FUNC)f;
  return;
}

void loop(void* handle){
  printf("=== enter ===\n");
  for (int i = 0; i < 10; i++) {
    CB(handle);
    printf("looped: %d\n", i);
  }
  printf("=== exit ===\n");
  return;
}

void call(void* handle) {
  pthread_create(&th, NULL, loop, handle);   
  return;
}

void join() {
  pthread_join(th, NULL);
  return;
}
