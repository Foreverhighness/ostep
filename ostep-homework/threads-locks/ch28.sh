#!/bin/bash
set -eux

function echo_red() {
  RED='\033[0;31m'
  NC='\033[0m'
  echo -e "${RED}${1}${NC}"
}

ANSWER=${ANSWER:-}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROGRAM="$SCRIPT_DIR/x86.py"

ASM="flag.s"

echo_red Q1:
echo_red Q2:
"$PROGRAM" "$ANSWER" --program="$ASM" --memtrace="flag,count" --regtrace="bx"

echo_red Q3:
"$PROGRAM" "$ANSWER" --program="$ASM" --memtrace="flag,count" --regtrace="bx" --argv="bx=2,bx=2"

echo_red Q4:
"$PROGRAM" "$ANSWER" --program="$ASM" --memtrace="flag,count" --regtrace="bx" --argv="bx=10,bx=10" --interrupt=4
"$PROGRAM" "$ANSWER" --program="$ASM" --memtrace="flag,count" --regtrace="bx" --argv="bx=10,bx=10" --interrupt=11

ASM="test-and-set.s"

echo_red Q5:
echo_red Q6:
"$PROGRAM" "$ANSWER" --program="$ASM" --memtrace="mutex,count" --argv="bx=10,bx=10" --interrupt=4
"$PROGRAM" "$ANSWER" --program="$ASM" --memtrace="mutex,count" --argv="bx=10,bx=10" --interrupt=100

echo_red Q7:
"$PROGRAM" "$ANSWER" --program="$ASM" --memtrace="mutex,count" --argv="bx=10,bx=1" --procsched="0011111111000000000"

ASM="peterson.s"

echo_red Q8:
echo_red Q9:
"$PROGRAM" "$ANSWER" --program="$ASM" --memtrace="flag,turn,count" --argv="bx=0,bx=1" --interrupt=4

echo_red Q10:
"$PROGRAM" "$ANSWER" --program="$ASM" --memtrace="flag,turn,count" --argv="bx=0,bx=1" --procsched="001"

ASM="ticket.s"

echo_red Q11:
"$PROGRAM" "$ANSWER" --program="$ASM" --memtrace="ticket,turn,count" --argv="bx=1000,bx=1000" --interrupt=4

echo_red Q12:
"$PROGRAM" "$ANSWER" --program="$ASM" --memtrace="ticket,turn,count" --argv="bx=1000,bx=1000,bx=1000" --interrupt=4 --threads=3

ASM="yield.s"

echo_red Q13:
"$PROGRAM" "$ANSWER" --program="$ASM" --memtrace="mutex,count" --argv="bx=10,bx=1" --procsched="0011111111000000000"

ASM="test-and-test-and-set.s"

echo_red Q14:
"$PROGRAM" "$ANSWER" --program="$ASM" --memtrace="mutex,count" --argv="bx=10,bx=10" --interrupt=4
