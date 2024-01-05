#define _GNU_SOURCE

#include <assert.h>
#include <fcntl.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/sem.h>
#include <unistd.h>

/* man 2 pipe */
void pipe_ipc() {
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
    exit(EXIT_SUCCESS);
  }
}

/* man 2 semop */
void sem_ipc() {
  const int semid = semget(IPC_PRIVATE, 1, 0600);
  // set sem.val to 1
  assert(semctl(semid, 0, SETVAL, 1) == 0);

  const int rc = fork();
  assert(rc >= 0);
  if (rc == 0) {
    // child
    printf("hello\n");

    // decrease sem.val (1 -> 0)
    struct sembuf sop = {.sem_num = 0, .sem_op = -1, .sem_flg = 0};
    assert(semop(semid, &sop, 1) == 0);

    _exit(EXIT_SUCCESS);
  } else {
    // parent
    // wait for sem.val become 0
    struct sembuf sop = {.sem_num = 0, .sem_op = 0, .sem_flg = 0};
    assert(semop(semid, &sop, 1) == 0);
    printf("goodbye\n");

    semctl(semid, 0, IPC_RMID);
    exit(EXIT_SUCCESS);
  }
}

void sem_mmap() {
  sem_t *sem = mmap(NULL, sizeof(sem_t), PROT_READ | PROT_WRITE,
                    MAP_ANONYMOUS | MAP_SHARED, -1, 0);
  assert(sem != MAP_FAILED);
  assert(sem_init(sem, 1, 0) == 0);
  int rc = fork();
  assert(rc >= 0);
  if (rc == 0) {
    // child
    printf("hello\n");
    assert(sem_post(sem) == 0);
    _exit(EXIT_SUCCESS);
  } else {
    // parent
    assert(sem_wait(sem) == 0);
    printf("goodbye\n");
    exit(EXIT_SUCCESS);
  }
}

int main() {
  sem_ipc();
  return 0;
}