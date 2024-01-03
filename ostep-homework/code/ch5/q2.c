#include <assert.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

static const char *filename = "build/test.txt";
static const int len = 8;
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))

/* write(man 2 write) is atomic */

void print_file() {
  FILE *fp = fopen(filename, "r");
  assert(fp);

  char buf[len + 1];
  memset(buf, 0, ARRAY_SIZE(buf));

  while (!feof(fp)) {
    char *ret = fgets(buf, ARRAY_SIZE(buf), fp);
    if (ret) {
      printf("%s\n", ret);
    }
  }

  fclose(fp);
}

int main() {
  char a[len];
  char b[len];
  char c[len];
  const int n = ARRAY_SIZE(a);
  memset(a, 'a', n);
  memset(b, 'b', n);
  memset(c, 'c', n);

  int fd = open(filename, O_CREAT | O_RDWR | O_TRUNC, 0644);
  assert(fd > 0);

  assert(write(fd, a, n) == n);

  int rc = fork();
  assert(rc >= 0);
  const int cnt = 3;

  if (rc == 0) {
    // child
    for (int i = 0; i != cnt; ++i) {
      assert(write(fd, b, n) == n);
    }
    close(fd);
    // https://stackoverflow.com/questions/5422831/what-is-the-difference-between-using-exit-exit-in-a-conventional-linux-fo
    // prefer _exit to abort child process
    _exit(EXIT_SUCCESS);
  } else {
    // parent
    for (int i = 0; i != cnt; ++i) {
      assert(write(fd, c, n) == n);
    }

    close(fd);
    wait(NULL);
    print_file();
  }
  return 0;
}