#!/bin/bash
set -eux

function echo_red() {
  RED='\033[0;31m'
  NC='\033[0m'
  echo -e "${RED}${1}${NC}"
}

ANSWER=${ANSWER:-}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROGRAM="$SCRIPT_DIR/paging-policy.py"

"$PROGRAM" "$ANSWER" --policy=FIFO --addresses="1,2,3,4,1,2,5,1,2,3,4,5" --cachesize=3
"$PROGRAM" "$ANSWER" --policy=FIFO --addresses="1,2,3,4,1,2,5,1,2,3,4,5" --cachesize=4

echo_red Q1:
"$PROGRAM" "$ANSWER" --policy=FIFO --cachesize=3 --seed=0 --numaddr=10
"$PROGRAM" "$ANSWER" --policy=LRU  --cachesize=3 --seed=0 --numaddr=10
"$PROGRAM" "$ANSWER" --policy=OPT  --cachesize=3 --seed=0 --numaddr=10

"$PROGRAM" "$ANSWER" --policy=FIFO --cachesize=3 --seed=1 --numaddr=10
"$PROGRAM" "$ANSWER" --policy=LRU  --cachesize=3 --seed=1 --numaddr=10
"$PROGRAM" "$ANSWER" --policy=OPT  --cachesize=3 --seed=1 --numaddr=10

"$PROGRAM" "$ANSWER" --policy=FIFO --cachesize=3 --seed=2 --numaddr=10
"$PROGRAM" "$ANSWER" --policy=LRU  --cachesize=3 --seed=2 --numaddr=10
"$PROGRAM" "$ANSWER" --policy=OPT  --cachesize=3 --seed=2 --numaddr=10

echo_red Q2:
SEQUENCE=$(seq -s ',' 0 9)
"$PROGRAM" "$ANSWER" --policy=FIFO --cachesize=5 --addresses="$SEQUENCE,$SEQUENCE" --notrace
"$PROGRAM" "$ANSWER" --policy=LRU  --cachesize=5 --addresses="$SEQUENCE,$SEQUENCE" --notrace
SEQ1=$(seq -s ',' 0 4)
SEQ2=$(seq -s ',' 5 9)
"$PROGRAM" "$ANSWER" --policy=MRU  --cachesize=5 --addresses="$SEQ1,$SEQ2,$SEQ2,$SEQ2" --notrace
