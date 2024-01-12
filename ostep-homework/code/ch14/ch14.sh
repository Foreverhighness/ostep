#!/bin/bash

function echo_red() {
  RED='\033[0;31m'
  NC='\033[0m'
  echo -e "${RED}${1}${NC}"
}

make build/null build/q4 build/q5 build/q6 &>/dev/null

echo_red Q2:
gdb build/null <<<'run'

echo_red Q3:
valgrind --leak-check=yes build/null

echo_red Q4:
gdb build/q4 <<<'run'
valgrind --leak-check=yes build/q4

echo_red Q5:
build/q5
valgrind --leak-check=yes build/q5

echo_red Q6:
build/q6
valgrind --leak-check=yes build/q6
