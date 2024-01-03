#include <assert.h>
#include <stdio.h>
#include <unistd.h>

int main() {
  int x = 100;
  printf("parent(%06d): Before fork: (x: %d)\n", getpid(), x);

  const int rc = fork();
  assert(rc >= 0);
  if (rc == 0) {
    // child
    const int old_x = x;
    printf("child (%06d): (x: %d)\n", getpid(), x);
    x = 200;
    printf("child (%06d): (%d -> %d)\n", getpid(), old_x, x);
  } else {
    // parent
    const int old_x = x;
    printf("parent(%06d): (x: %d)\n", getpid(), x);
    x = 300;
    printf("parent(%06d): (%d -> %d)\n", getpid(), old_x, x);
  }

  return 0;
}