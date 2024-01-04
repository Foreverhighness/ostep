#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

int main() {
  int pipe_fd[2];
  assert(pipe(pipe_fd) == 0);
  const int read_fd = pipe_fd[0];
  const int write_fd = pipe_fd[1];

  const int read_child_pid = fork();
  assert(read_child_pid >= 0);
  if (read_child_pid == 0) {
    // read child
    close(write_fd);

    const pid_t pid = getpid();
    printf("read  child (%d): Before read\n", pid);

    const int len = 16;
    char buf[len];
    assert(read(read_fd, buf, len) >= 0);

    printf("read  child (%d): After read  <- %s\n", pid, buf);
    assert(strncmp(buf, "hello", len) == 0);

    close(read_fd);
    _exit(EXIT_SUCCESS);
  }

  const int write_child_pid = fork();
  assert(write_child_pid >= 0);
  if (write_child_pid == 0) {
    // write child
    close(read_fd);

    const pid_t pid = getpid();
    printf("write child (%d): Before write\n", pid);

    const char hello[] = "hello";
    const int size = sizeof(hello);
    assert(write(write_fd, hello, size) == size);

    printf("write child (%d): After write -> %s\n", pid, hello);

    close(write_fd);
    _exit(EXIT_SUCCESS);
  }

  close(read_fd);
  close(write_fd);

  const pid_t pid = getpid();
  printf("      parent(%d): Waiting child\n", pid);

  pid_t child_pid;
  int wstatus;
  while ((child_pid = wait(&wstatus)) > 0) {
    if (child_pid == read_child_pid) {
      printf("      parent(%d): read  child(%d) exit\n", pid, child_pid);
    } else if (child_pid == write_child_pid) {
      printf("      parent(%d): write child(%d) exit\n", pid, child_pid);
    } else {
      assert(false);
    }
    assert(WIFEXITED(wstatus));
    assert(WEXITSTATUS(wstatus) == 0);
  }
  assert(child_pid == -1);
  return 0;
}