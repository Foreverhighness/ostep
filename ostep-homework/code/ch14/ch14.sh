#!/bin/bash

function echo_red() {
  RED='\033[0;31m'
  NC='\033[0m'
  echo -e "${RED}${1}${NC}"
}

make build/null build/q4 &>/dev/null

echo_red Q2:
gdb build/null <<<'run'

echo_red Q3:
valgrind --leak-check=yes build/null

echo_red Q4:
gdb build/q4 <<<'run'
valgrind --leak-check=yes build/q4
