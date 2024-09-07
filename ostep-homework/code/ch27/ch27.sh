#!/bin/bash
set -eux

function echo_red() {
    RED='\033[0;31m'
    NC='\033[0m'
    echo -e "${RED}${1}${NC}"
}

ANSWER=${ANSWER:-}
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

echo_red Q1:
make -C "$SCRIPT_DIR" build/main-race

valgrind --tool=helgrind build/main-race

echo_red Q2:
make -C "$SCRIPT_DIR" build/main-race-delete1 build/main-race-lock1 build/main-race-lock2

valgrind --tool=helgrind build/main-race-delete1
valgrind --tool=helgrind build/main-race-lock1
valgrind --tool=helgrind build/main-race-lock2

echo_red Q3:
make -C "$SCRIPT_DIR" build/main-deadlock

echo_red Q4:
valgrind --tool=helgrind build/main-deadlock

echo_red Q5:
make -C "$SCRIPT_DIR" build/main-deadlock-global

valgrind --tool=helgrind build/main-deadlock-global

echo_red Q6:
make -C "$SCRIPT_DIR" build/main-signal

echo_red Q7:
valgrind --tool=helgrind build/main-signal

echo_red Q8:
make -C "$SCRIPT_DIR" build/main-signal-cv

echo_red Q9:
valgrind --tool=helgrind build/main-signal-cv
