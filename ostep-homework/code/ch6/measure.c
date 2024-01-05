#define _GNU_SOURCE

#include <assert.h>
#include <pthread.h>
#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/sysinfo.h>
#include <sys/time.h>
#include <time.h>

static const int samples = 1024;

static const int loops = 1 * 1000 * 1000;
static int result = 0;

// attention: it will broken on -O2 optimization
static void *work(void *args) {
  for (int i = 0; i != loops; ++i) {
    ++result;
  }
  return NULL;
}

static void ensure_only_one_cpu() {
  const int num_threads = get_nprocs();
  pthread_t tid[num_threads];
  for (int i = 0; i != num_threads; ++i) {
    assert(pthread_create(&tid[i], NULL, &work, NULL) == 0);
  }
  for (int i = 0; i != num_threads; ++i) {
    assert(pthread_join(tid[i], NULL) == 0);
  }
  assert(result == loops * num_threads);
}

static void set_core_to_one() {
  cpu_set_t cpuset;
  CPU_ZERO(&cpuset);
  CPU_SET(0, &cpuset);
  sched_setaffinity(0, sizeof(cpuset), &cpuset);

  ensure_only_one_cpu();
}

int main() {
  set_core_to_one();

  struct timeval *tvs =
      (struct timeval *)malloc(samples * sizeof(struct timeval));

  for (int i = 0; i != samples; ++i) {
    assert(gettimeofday(&tvs[i], NULL) == 0);
  }
  for (int i = 1; i != samples; ++i) {
    printf("%ld, elapse %ld\n", tvs[i].tv_usec,
           tvs[i].tv_usec - tvs[i - 1].tv_usec);
  }

  free(tvs);
  return 0;
}