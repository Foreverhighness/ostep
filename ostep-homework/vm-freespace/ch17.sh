#!/bin/bash
set -eux

function echo_red() {
  RED='\033[0;31m'
  NC='\033[0m'
  echo -e "${RED}${1}${NC}"
}

echo_red Q1:
./malloc.py -n 10 -H 0 -p BEST -s 0 -c

echo_red Q2:
./malloc.py -n 10 -H 0 -p WORST -s 0 -c
