#define _GNU_SOURCE

#include <assert.h>
#include <pthread.h>
#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/sysinfo.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

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

static void ensure_only_one_cpu_using_fork() {
  int *res = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE,
                  MAP_ANONYMOUS | MAP_SHARED, -1, 0);
  assert(res != MAP_FAILED);

  int rc = fork();
  assert(rc >= 0);
  for (int i = 0; i != loops; ++i) {
    *res += 1;
  }
  if (rc == 0) {
    _exit(EXIT_SUCCESS);
  } else {
    assert(wait(NULL) == rc);
  }

  assert(*res == loops * 2);
  assert(munmap(res, sizeof(int)) == 0);
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
  assert(sched_setaffinity(0, sizeof(cpuset), &cpuset) >= 0);

  ensure_only_one_cpu();
  ensure_only_one_cpu_using_fork();
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