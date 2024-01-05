#define _GNU_SOURCE

#include <assert.h>
#include <fcntl.h>
#include <inttypes.h>
#include <pthread.h>
#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/sysinfo.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static const int iteration = 1 * 1000 * 1000;

static uint64_t now_us() {
  struct timeval tv;
  assert(gettimeofday(&tv, NULL) == 0);
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

static void set_core_to_one() {
  cpu_set_t cpuset;
  CPU_ZERO(&cpuset);
  CPU_SET(0, &cpuset);
  assert(sched_setaffinity(0, sizeof(cpuset), &cpuset) >= 0);

  ensure_only_one_cpu();
  ensure_only_one_cpu_using_fork();
}

// https://github.com/intel/lmbench/blob/master/src/lat_ctx.c
static void measure_context_switch() {
  int pipe_fds[2][2];
  assert(pipe(pipe_fds[0]) == 0);
  assert(pipe(pipe_fds[1]) == 0);
  const int parent_read_fd = pipe_fds[0][0];
  const int parent_write_fd = pipe_fds[1][1];
  const int child_read_fd = pipe_fds[1][0];
  const int child_write_fd = pipe_fds[0][1];

  int msg;
  const size_t size = sizeof(msg);

  const int rc = fork();
  assert(rc >= 0);
  if (rc == 0) {
    // child for write
    close(parent_read_fd);
    close(parent_write_fd);
    const uint64_t start_us = now_us();

    for (int i = 0; i != iteration; ++i) {
      assert(write(child_write_fd, &msg, size) == size);
      assert(read(child_read_fd, &msg, size) == size);
    }

    const uint64_t elapse_us = now_us() - start_us;
    printf("context switch (write) time: %" PRIu64 "us, avg: %" PRIu64 "ns\n",
           elapse_us, elapse_us * 1000 / iteration / 2);

    close(child_read_fd);
    close(child_write_fd);
    _exit(EXIT_SUCCESS);
  } else {
    // parent for read
    close(child_read_fd);
    close(child_write_fd);
    const uint64_t start_us = now_us();

    for (int i = 0; i != iteration; ++i) {
      assert(write(parent_write_fd, &msg, size) == size);
      assert(read(parent_read_fd, &msg, size) == size);
    }

    const uint64_t elapse_us = now_us() - start_us;
    printf("context switch (read)  time: %" PRIu64 "us, avg: %" PRIu64 "ns\n",
           elapse_us, elapse_us * 1000 / iteration / 2);

    close(parent_read_fd);
    close(parent_write_fd);
    assert(wait(NULL) == rc);
  }
}

static void measure_getpid_syscall() {
  const uint64_t start_us = now_us();

  for (int i = 0; i != iteration; ++i) {
    getpid();
  }

  const uint64_t elapse_us = now_us() - start_us;
  printf("getpid time: %" PRIu64 "us, avg: %" PRIu64 "ns\n", elapse_us,
         elapse_us * 1000 / iteration);
}

static void measure_read_syscall() {
  const char *file = "/dev/zero";
  const uint64_t start_us = now_us();
  const int fd = open(file, O_RDONLY);

  char buf;
  for (int i = 0; i != iteration; ++i) {
    assert(read(fd, &buf, 1) == 1);
    assert(buf == '\0');
  }

  const uint64_t elapse_us = now_us() - start_us;
  printf("read  from %s (1 byte) time: %" PRIu64 "us, avg: %" PRIu64 "ns\n",
         file, elapse_us, elapse_us * 1000 / iteration);
}

static void measure_write_syscall() {
  const char *file = "/dev/null";
  const uint64_t start_us = now_us();
  const int fd = open(file, O_WRONLY);

  char buf = 'y';
  for (int i = 0; i != iteration; ++i) {
    assert(write(fd, &buf, 1) == 1);
  }

  const uint64_t elapse_us = now_us() - start_us;
  printf("write into %s (1 byte) time: %" PRIu64 "us, avg: %" PRIu64 "ns\n",
         file, elapse_us, elapse_us * 1000 / iteration);
}

int main() {
  set_core_to_one();

  printf("iteration: %d\n", iteration);
  measure_getpid_syscall();
  measure_write_syscall();
  measure_read_syscall();
  measure_context_switch();
  return 0;
}