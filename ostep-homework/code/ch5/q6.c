#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

int main() {
  int rc = fork();
  assert(rc >= 0);
  if (rc == 0) {
    // child
    pid_t pid = getpid();
    printf("child (%d): hello\n", pid);

    int wstatus;
    pid_t ret = waitpid(-1, &wstatus, 0);
    printf("child (%d) wait -> %d\n", pid, ret);
    assert(errno == ECHILD);

    _exit(EXIT_SUCCESS);
  } else {
    // parent
    const pid_t child_pid = rc;
    pid_t pid = getpid();

    int wstatus;
    pid_t ret = waitpid(child_pid, &wstatus, 0);
    printf("parent(%d) wait -> %d\n", pid, ret);
    assert(WIFEXITED(wstatus));
    assert(WEXITSTATUS(wstatus) == 0);

    printf("parent(%d) goodbye\n", pid);
  }
  return 0;
}