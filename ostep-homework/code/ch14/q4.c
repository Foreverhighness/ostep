#include <stdlib.h>

int main() {
  int *leak = (int *)malloc(sizeof(int));
  *leak = 0;
  return *leak;
}
