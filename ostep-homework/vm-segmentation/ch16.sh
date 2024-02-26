#!/bin/bash
set -eux

function echo_red() {
  RED='\033[0;31m'
  NC='\033[0m'
  echo -e "${RED}${1}${NC}"
}

echo_red Q1:
./segmentation.py -a 128 -p 512 -b 0 -l 20 -B 512 -L 20 -s 0 -c
./segmentation.py -a 128 -p 512 -b 0 -l 20 -B 512 -L 20 -s 1 -c
./segmentation.py -a 128 -p 512 -b 0 -l 20 -B 512 -L 20 -s 2 -c

echo_red Q2:
./segmentation.py -a 128 -p 512 -b 0 -l 20 -B 512 -L 20 -A "0,19,127,108,20,107" -c

echo_red Q3:
./segmentation.py -a 16 -p 128 -A $(seq -s , 0 15) -b 0 -l 2 -B 16 -L 2 -c

echo_red Q4:
len=$((128 * 90 / 100 / 2))
./segmentation.py -a 128 -p 512 -A $(seq -s , 0 127) -b 0 -l $len -B 512 -L $len -c

echo_red Q5:
./segmentation.py -a 16 -p 128 -A $(seq -s , 0 15) -b 0 -l 0 -B 16 -L 0 -c
