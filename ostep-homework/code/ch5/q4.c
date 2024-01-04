#define _GNU_SOURCE
#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

extern char **environ;

int main() {
  int rc;
  rc = fork();
  assert(rc >= 0);
  if (rc == 0) {
    execl("/bin/ls", "-a", "-F", ".", NULL);
    assert(false);
  }

  rc = fork();
  assert(rc >= 0);
  if (rc == 0) {
    execle("/bin/ls", "-a", "-F", ".", NULL, environ);
    assert(false);
  }

  rc = fork();
  assert(rc >= 0);
  if (rc == 0) {
    execlp("ls", "-a", "-F", ".", NULL);
    assert(false);
  }

  rc = fork();
  assert(rc >= 0);
  if (rc == 0) {
    char *const argv[] = {"-a", "-F", ".", NULL};
    execv("/bin/ls", argv);
    assert(false);
  }

  rc = fork();
  assert(rc >= 0);
  if (rc == 0) {
    char *const argv[] = {"-a", "-F", ".", NULL};
    execvp("ls", argv);
    assert(false);
  }

  rc = fork();
  assert(rc >= 0);
  if (rc == 0) {
    char *const argv[] = {"-a", "-F", ".", NULL};
    execvpe("ls", argv, environ);
    assert(false);
  }

  int cnt = 0;
  while (wait(NULL) != -1) {
    ++cnt;
  }
  printf("wait %d\n", cnt);
  return 0;
}