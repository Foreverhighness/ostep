#!/bin/bash
set -eux

function echo_red() {
  RED='\033[0;31m'
  NC='\033[0m'
  echo -e "${RED}${1}${NC}"
}

echo_red Q1:
./relocation.py -s 1 -c
./relocation.py -s 2 -c
./relocation.py -s 3 -c

echo_red Q2:
./relocation.py -s 0 -n 10 -l 930 -c

echo_red Q3:
./relocation.py -s 1 -n 10 -l 100 -b $(($(numfmt --from=iec 16K) - 100)) -c

echo_red Q4:
./relocation.py -s 1 -n 10 -l 100 -b $(($(numfmt --from=iec 1G) - 100)) -a 32M -p 1G -c

echo_red Q5:
