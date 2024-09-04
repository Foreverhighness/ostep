#!/bin/bash
set -eux

function echo_red() {
  RED='\033[0;31m'
  NC='\033[0m'
  echo -e "${RED}${1}${NC}"
}

ANSWER=${ANSWER:-}

echo_red Q1:
./paging-linear-translate.py --pagesize=1k --asize=1m --physmem=512m -v -n 0
./paging-linear-translate.py --pagesize=1k --asize=2m --physmem=512m -v -n 0
./paging-linear-translate.py --pagesize=1k --asize=4m --physmem=512m -v -n 0
./paging-linear-translate.py --pagesize=1k --asize=1m --physmem=512m -v -n 0
./paging-linear-translate.py --pagesize=2k --asize=1m --physmem=512m -v -n 0
./paging-linear-translate.py --pagesize=4k --asize=1m --physmem=512m -v -n 0

echo_red Q2:
./paging-linear-translate.py --pagesize=1k --asize=16k --physmem=32k -v --used=0   --seed=0 "$ANSWER"
./paging-linear-translate.py --pagesize=1k --asize=16k --physmem=32k -v --used=25  --seed=0 "$ANSWER"
./paging-linear-translate.py --pagesize=1k --asize=16k --physmem=32k -v --used=50  --seed=0 "$ANSWER"
./paging-linear-translate.py --pagesize=1k --asize=16k --physmem=32k -v --used=75  --seed=0 "$ANSWER"
./paging-linear-translate.py --pagesize=1k --asize=16k --physmem=32k -v --used=100 --seed=0 "$ANSWER"

echo_red Q3:
./paging-linear-translate.py --pagesize=8  --asize=32   --physmem=1024 -v --seed=1 "$ANSWER"
./paging-linear-translate.py --pagesize=8k --asize=32k  --physmem=1m   -v --seed=2 "$ANSWER"
./paging-linear-translate.py --pagesize=1m --asize=256m --physmem=512m -v --seed=3 "$ANSWER"

echo_red Q4:
set +e
./paging-linear-translate.py --pagesize=4 --asize=16 --physmem=8 -v "$ANSWER"
./paging-linear-translate.py --pagesize=1g --asize=1g --physmem=2g -v "$ANSWER"
