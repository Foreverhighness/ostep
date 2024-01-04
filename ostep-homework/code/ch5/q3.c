#define _GNU_SOURCE

#include <assert.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

/* man 2 pipe */

int main() {
  int pipe_fd[2];
  assert(pipe(pipe_fd) == 0);
  int read_fd = pipe_fd[0];
  int write_fd = pipe_fd[1];

  int rc = fork();
  assert(rc >= 0);
  if (rc == 0) {
    // child
    close(read_fd);

    printf("hello\n");

    assert(write(write_fd, "y", 1) == 1);

    close(write_fd);
    _exit(EXIT_SUCCESS);
  } else {
    // parent
    close(write_fd);

    int cnt = 0;
    char buf;
    while (read(read_fd, &buf, 1) != 1) {
      ++cnt;
    }
    assert(buf == 'y');
    assert(cnt == 0);

    printf("goodbye\n");
    close(read_fd);
  }
  return 0;
}