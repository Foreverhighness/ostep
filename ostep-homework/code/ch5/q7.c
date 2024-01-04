#include <assert.h>
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
    printf("child (%d): Before close\n", pid);
    close(STDOUT_FILENO);
    printf("child (%d):  After close\n", pid);
    _exit(EXIT_SUCCESS);
  } else {
    // parent
    pid_t pid = getpid();
    printf("parent(%d): Before wait\n", pid);
    assert(wait(NULL) == rc);
    printf("parent(%d):  After wait\n", pid);
  }
  return 0;
}