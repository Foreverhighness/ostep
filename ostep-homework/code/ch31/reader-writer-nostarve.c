#include "common_threads.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

//
// Your code goes in the structure and functions below
//

typedef struct __rwlock_t {
  int reader;
  sem_t lock;
  sem_t reader_lock;
  sem_t write_lock;
} rwlock_t;

void rwlock_init(rwlock_t *rw) {
  rw->reader = 0;
  Sem_init(&rw->lock, 1);
  Sem_init(&rw->reader_lock, 1);
  Sem_init(&rw->write_lock, 1);
}

void rwlock_acquire_readlock(rwlock_t *rw) {
  Sem_wait(&rw->lock);
  Sem_post(&rw->lock);

  Sem_wait(&rw->reader_lock);
  rw->reader += 1;
  if (rw->reader == 1) {
    Sem_wait(&rw->write_lock);
  }
  Sem_post(&rw->reader_lock);
}

void rwlock_release_readlock(rwlock_t *rw) {
  Sem_wait(&rw->reader_lock);
  rw->reader -= 1;
  if (rw->reader == 0) {
    Sem_post(&rw->write_lock);
  }
  Sem_post(&rw->reader_lock);
}

void rwlock_acquire_writelock(rwlock_t *rw) {
  Sem_wait(&rw->lock);
  Sem_wait(&rw->write_lock);
}

void rwlock_release_writelock(rwlock_t *rw) {
  Sem_post(&rw->lock);
  Sem_post(&rw->write_lock);
}

//
// Don't change the code below (just use it!)
//

int loops;
int value = 0;

rwlock_t lock;

void *reader(void *arg) {
  int i;
  for (i = 0; i < loops; i++) {
    rwlock_acquire_readlock(&lock);
    printf("read %d\n", value);
    rwlock_release_readlock(&lock);
  }
  return NULL;
}

void *writer(void *arg) {
  int i;
  for (i = 0; i < loops; i++) {
    rwlock_acquire_writelock(&lock);
    value++;
    printf("write %d\n", value);
    rwlock_release_writelock(&lock);
  }
  return NULL;
}

int main(int argc, char *argv[]) {
  int num_readers = 4;
  int num_writers = 2;
  loops = 10;
  if (argc >= 2) {
    num_readers = atoi(argv[1]);
  }
  if (argc >= 3) {
    num_writers = atoi(argv[2]);
  }
  if (argc >= 4) {
    loops = atoi(argv[3]);
  }

  pthread_t pr[num_readers], pw[num_writers];

  rwlock_init(&lock);

  printf("begin\n");

  int i;
  for (i = 0; i < num_readers; i++)
    Pthread_create(&pr[i], NULL, reader, NULL);
  for (i = 0; i < num_writers; i++)
    Pthread_create(&pw[i], NULL, writer, NULL);

  for (i = 0; i < num_readers; i++)
    Pthread_join(pr[i], NULL);
  for (i = 0; i < num_writers; i++)
    Pthread_join(pw[i], NULL);

  printf("end: value %d\n", value);

  return 0;
}
