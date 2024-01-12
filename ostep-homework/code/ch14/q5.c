#include <stdlib.h>

int main() {
  const int SIZE = 100;
  int *data = (int *)malloc(SIZE * sizeof(int));
  for (int i = 0; i != SIZE; ++i) {
    data[i] = 0;
  }
  return data[0];
}
