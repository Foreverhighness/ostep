#include <stdio.h>

#include "common_threads.h"

int balance = 0;
pthread_mutex_t mu = PTHREAD_MUTEX_INITIALIZER;

void *worker(void *arg) {

  balance++; // unprotected access

  return NULL;
}

int main(int argc, char *argv[]) {
  pthread_t p;
  Pthread_create(&p, NULL, worker, NULL);
  Pthread_mutex_lock(&mu);
  balance++; // protected access
  Pthread_mutex_unlock(&mu);
  Pthread_join(p, NULL);
  return 0;
}
