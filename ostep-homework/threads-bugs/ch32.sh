#!/bin/bash
set -eux

function echo_red() {
  RED='\033[0;31m'
  NC='\033[0m'
  echo -e "${RED}${1}${NC}"
}

ANSWER=${ANSWER:-}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

make -C "$SCRIPT_DIR" all >& /dev/null

L=1000000

PROGRAM="$SCRIPT_DIR/vector-deadlock"
echo_red Q1:
"$PROGRAM" -t -n 2 -l 1 -v

echo_red Q2:
set +e
timeout 5s "$PROGRAM" -t -d -n 2 -l 1 -v
timeout 5s "$PROGRAM" "$ANSWER" -t -d -n 2 -l "$L"

echo_red Q3:
timeout 5s "$PROGRAM" "$ANSWER" -t -d -n 1 -l "$L"
set -e

PROGRAM="$SCRIPT_DIR/vector-global-order"
echo_red Q4:
echo_red Q5:
"$PROGRAM" "$ANSWER" -t -d -n 2 -l "$L"

echo_red Q6:
"$PROGRAM" "$ANSWER" -t -d -n 2 -l "$L" -p

PROGRAM="$SCRIPT_DIR/vector-try-wait"
echo_red Q7:
"$PROGRAM" "$ANSWER" -t -d -n 2 -l "$L"
"$PROGRAM" "$ANSWER" -t -d -n 2 -l "$L" -p

PROGRAM="$SCRIPT_DIR/vector-avoid-hold-and-wait"
echo_red Q8:
"$PROGRAM" "$ANSWER" -t -d -n 2 -l "$L"
"$PROGRAM" "$ANSWER" -t -d -n 2 -l "$L" -p

PROGRAM="$SCRIPT_DIR/vector-nolock"
echo_red Q9:
echo_red Q10:
"$PROGRAM" "$ANSWER" -t -d -n 2 -l "$L"
"$PROGRAM" "$ANSWER" -t -d -n 2 -l "$L" -p
