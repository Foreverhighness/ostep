#include "common_threads.h"

#include <assert.h>
#include <inttypes.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

//
// Here, you have to write (almost) ALL the code. Oh no!
// How can you show that a thread does not starve
// when attempting to acquire this mutex you build?
//

typedef struct __ns_mutex_t {
  int ticket;
  int turn;
  sem_t ticket_lock;
  sem_t lock;
} ns_mutex_t;

ns_mutex_t m;
int loops;

void ns_mutex_init(ns_mutex_t *m) {
  m->ticket = 0;
  m->turn = 0;
  Sem_init(&m->ticket_lock, 1);
  Sem_init(&m->lock, 1);
}

void ns_mutex_acquire(ns_mutex_t *m) {
  Sem_wait(&m->ticket_lock);
  int ticket = m->ticket;
  m->ticket += 1;
  Sem_post(&m->ticket_lock);

  for (;;) {
    Sem_wait(&m->lock);
    if (m->turn == ticket) {
      return;
    }
    Sem_post(&m->lock);
  }
}

void ns_mutex_release(ns_mutex_t *m) {
  m->turn += 1;
  Sem_post(&m->lock);
}

void *worker(void *arg) {
  int threadID = (int)(uintptr_t)arg;
  for (int i = 0; i != loops; ++i) {
    ns_mutex_acquire(&m);
    printf("%d: %d\n", threadID, i);
    ns_mutex_release(&m);
  }
  return NULL;
}

int main(int argc, char *argv[]) {
  int num_threads = 4;
  loops = 20;
  if (argc >= 2) {
    num_threads = atoi(argv[1]);
  }
  if (argc >= 3) {
    loops = atoi(argv[2]);
  }
  assert(num_threads > 0);

  pthread_t p[num_threads];

  printf("parent: begin\n");
  ns_mutex_init(&m);

  for (int i = 0; i < num_threads; ++i) {
    Pthread_create(&p[i], NULL, worker, (void *)(uintptr_t)i);
  }

  for (int i = 0; i < num_threads; ++i) {
    Pthread_join(p[i], NULL);
  }

  printf("parent: end\n");
  return 0;
}
