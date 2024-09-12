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

PROGRAM="$SCRIPT_DIR/main-two-cvs-while"
echo_red Q1:
echo_red Q2:
"$PROGRAM" "$ANSWER" -l   1 -m  1 -p 1 -c 1
"$PROGRAM" "$ANSWER" -l   1 -m  5 -p 1 -c 1
"$PROGRAM" "$ANSWER" -l   1 -m 10 -p 1 -c 1
"$PROGRAM" "$ANSWER" -l 100 -m 10 -p 1 -c 1
"$PROGRAM" "$ANSWER" -l   1 -m  1 -p 1 -c 1 -C "0,0,0,0,0,0,1"
"$PROGRAM" "$ANSWER" -l  10 -m  1 -p 1 -c 1 -C "0,0,0,0,0,0,1"
"$PROGRAM" "$ANSWER" -l  15 -m 10 -p 1 -c 1 -C "0,0,0,0,0,0,1"

echo_red Q3:
echo_red Q4:
C="0,0,0,1,0,0,0"
"$PROGRAM" "$ANSWER" -l  10 -m  1 -p 1 -c 3 -C "$C:$C:$C" -t

echo_red Q5:
"$PROGRAM" "$ANSWER" -l  10 -m  3 -p 1 -c 3 -C "$C:$C:$C" -t

echo_red Q6:
C="0,0,0,0,0,0,1"
"$PROGRAM" "$ANSWER" -l  10 -m  1 -p 1 -c 3 -C "$C:$C:$C" -t

echo_red Q7:
"$PROGRAM" "$ANSWER" -l  10 -m  3 -p 1 -c 3 -C "$C:$C:$C" -t

PROGRAM="$SCRIPT_DIR/main-one-cv-while"
echo_red Q8:
"$PROGRAM" "$ANSWER" -l   1 -m  1 -p 1 -c 1 -P "0,0,0,0,0,0,1" -t

echo_red Q9:
set +e
timeout 5s "$PROGRAM" "$ANSWER" -l   1 -m  1 -p 1 -c 2 -P "0,0,0,0,0,0,1" -t
set -e

PROGRAM="$SCRIPT_DIR/main-two-cvs-if"
echo_red Q10:
C1="2,0,0,0,0,0,0"
C2="0,0,0,0,0,0,0"
"$PROGRAM" "$ANSWER" -l   1 -m  1 -p 1 -c 2 -P "1,2,0,0,0,0,0" -C "$C1:$C2" -t

PROGRAM="$SCRIPT_DIR/main-two-cvs-while-extra-unlock"
echo_red Q11:
valgrind --tool=helgrind -- "$PROGRAM" "$ANSWER"
