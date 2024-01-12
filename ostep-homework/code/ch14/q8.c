#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef int T;
typedef struct {
  T *data;
  size_t len, cap;
} Vec;

Vec Vec_new() {
  Vec vec;
  memset(&vec, 0, sizeof(Vec));
  return vec;
}

void Vec_drop(Vec *self) {
  free(self->data);
  memset(self, 0, sizeof(Vec));
}

bool Vec_is_empty(const Vec *self) { return self->len == 0; }

#define check_bound() assert(0 <= index && index < self->len)

T Vec_at(const Vec *self, const size_t index) {
  check_bound();
  return self->data[index];
}

const T *Vec_get(const Vec *self, const size_t index) {
  if (0 <= index && index < self->len) {
    return &self->data[index];
  }
  return NULL;
}

T *Vec_get_mut(Vec *self, const size_t index) {
  if (0 <= index && index < self->len) {
    return &self->data[index];
  }
  return NULL;
}

void Vec_push(Vec *self, const T value) {
  if (self->len + 1 > self->cap) {
    const size_t new_cap = self->cap == 0 ? 1 : 2 * self->cap;
    self->data = (T *)realloc(self->data, new_cap * sizeof(T));
    assert(self->data);
    self->cap = new_cap;
  }

  const size_t index = self->len;
  self->len += 1;
  *Vec_get_mut(self, index) = value;
}

T Vec_remove(Vec *self, const size_t index) {
  check_bound();
  T ret = Vec_at(self, index);
  for (size_t i = index; i + 1 != self->len; ++i) {
    *Vec_get_mut(self, i) = Vec_at(self, i + 1);
  }
  self->len -= 1;
  return ret;
}

void Vec_display(const Vec *self) {
  printf("len: %2zu, cap: %2zu, value: [", self->len, self->cap);
  bool first = true;
  for (int i = 0; i != self->len; ++i) {
    if (first) {
      first = false;
    } else {
      printf(", ");
    }
    printf("%2d", Vec_at(self, i));
  }
  printf("]\n");
}

int main() {
  const int n = 10;
  const int max_value = 100;

  Vec vec = Vec_new();
  assert(Vec_is_empty(&vec));

  for (int i = 0; i != n; ++i) {
    Vec_push(&vec, rand() % max_value);
    Vec_display(&vec);
  }

  for (int i = 0; i != n; ++i) {
    const size_t index = rand() % vec.len;
    const T value = Vec_remove(&vec, index);
    printf("remove (%d) at index(%zu)\n", value, index);
    Vec_display(&vec);
  }

  assert(Vec_is_empty(&vec));

  Vec_drop(&vec);
  return 0;
}
