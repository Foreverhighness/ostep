#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>

#define KiB *1024
#define MiB *1024 KiB

int main(int argc, char **argv) {
  int memory_size_MiB = 1000;
  int time_to_run_s = 0;
  if (argc >= 2) {
    memory_size_MiB = atoi(argv[1]);
  }
  if (argc >= 3) {
    time_to_run_s = atoi(argv[2]);
  }
  const time_t deadline = time(NULL) + time_to_run_s;
  const uint8_t val = rand() % UINT8_MAX;

  uint8_t *memory = malloc(memory_size_MiB MiB);
  assert(memory != NULL);
  for (;;) {
    for (int b = 0; b != memory_size_MiB; ++b) {
      if (time(NULL) >= deadline) {
        return 0;
      }

      uint8_t *buf = memory + b MiB;
      for (int i = 0; i != 1 MiB; ++i) {
        buf[i] = val;
      }
    }
  }
  return 0;
}
