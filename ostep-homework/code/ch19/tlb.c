#include <assert.h>
#include <inttypes.h>
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/sysinfo.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <unistd.h>

static int page_size;
static uint64_t now_us() {
  struct timeval tv;
  int rc = gettimeofday(&tv, NULL);
  assert(rc == 0);
  return (uint64_t)tv.tv_sec * 1000 * 1000 + tv.tv_usec;
}

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

static uint64_t measure_us(int num_pages, int num_trials) {
  const int jump = page_size / sizeof(int);
  const size_t size = num_pages * page_size;
  const int c = rand() % UINT8_MAX;

  int *arr = (int *)malloc(size);
  assert(arr != NULL);

  memset(arr, c, size);

  uint64_t start = now_us();
  for (int t = 0; t != num_trials; ++t) {
    for (int i = 0; i < num_pages * jump; i += jump) {
      arr[i] += 1;
    }
  }
  uint64_t end = now_us();

  free(arr);
  return end - start;
}

int main(int argc, char **argv) {
  ensure_only_one_cpu();
  ensure_only_one_cpu_using_fork();

  int num_pages = 1024;
  int num_trials = 1000;

  if (argc >= 2) {
    num_pages = atoi(argv[1]);
  }
  if (argc >= 3) {
    num_trials = atoi(argv[2]);
  }

  page_size = getpagesize();

  uint64_t time_us = measure_us(num_pages, num_trials);

  printf("%" PRIu64 "\n", time_us);
  return 0;
}