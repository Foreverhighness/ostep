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

ASM="loop.s"

echo_red Q1:
"$PROGRAM" "$ANSWER" --program="$ASM" --threads=1 --interrupt=100 --regtrace=dx

echo_red Q2:
"$PROGRAM" "$ANSWER" --program="$ASM" --threads=2 --interrupt=100 --regtrace=dx --argv="dx=3,dx=3"

echo_red Q3:
"$PROGRAM" "$ANSWER" --program="$ASM" --threads=2 --interrupt=3 --randints --regtrace=dx --argv="dx=3,dx=3"

ASM="looping-race-nolock.s"

echo_red Q4:
"$PROGRAM" "$ANSWER" --program="$ASM" --threads=1 --memtrace=2000

echo_red Q5:
"$PROGRAM" "$ANSWER" --program="$ASM" --threads=2 --memtrace=2000 --argv="bx=3"

echo_red Q6:
"$PROGRAM" "$ANSWER" --program="$ASM" --threads=2 --interrupt=4 --randints --memtrace=2000 --seed=0
"$PROGRAM" "$ANSWER" --program="$ASM" --threads=2 --interrupt=4 --randints --memtrace=2000 --seed=1
"$PROGRAM" "$ANSWER" --program="$ASM" --threads=2 --interrupt=4 --randints --memtrace=2000 --seed=2

echo_red Q7:
"$PROGRAM" "$ANSWER" --program="$ASM" --threads=2 --memtrace=2000 --argv="bx=1" --interrupt=1
"$PROGRAM" "$ANSWER" --program="$ASM" --threads=2 --memtrace=2000 --argv="bx=1" --interrupt=2
"$PROGRAM" "$ANSWER" --program="$ASM" --threads=2 --memtrace=2000 --argv="bx=1" --interrupt=3

echo_red Q8:
"$PROGRAM" "$ANSWER" --program="$ASM" --threads=2 --memtrace=2000 --argv="bx=100" --interrupt=3
"$PROGRAM" "$ANSWER" --program="$ASM" --threads=2 --memtrace=2000 --argv="bx=100" --interrupt=6
"$PROGRAM" "$ANSWER" --program="$ASM" --threads=2 --memtrace=2000 --argv="bx=100" --interrupt=9

ASM="wait-for-me.s"

echo_red Q9:
"$PROGRAM" "$ANSWER" --program="$ASM" --threads=2 --interrupt=3 --randints --memtrace=2000 --regtrace=ax --argv="ax=1,ax=0"

echo_red Q10:
"$PROGRAM" "$ANSWER" --program="$ASM" --threads=2 --interrupt=3 --randints --memtrace=2000 --regtrace=ax --argv="ax=0,ax=1"
"$PROGRAM" "$ANSWER" --program="$ASM" --threads=2 --interrupt=3 --randints --memtrace=2000 --regtrace=ax --argv="ax=0,ax=1" --interrupt=1000
"$PROGRAM" "$ANSWER" --program="$ASM" --threads=2 --interrupt=3 --randints --memtrace=2000 --regtrace=ax --argv="ax=0,ax=1" --interrupt=3 --randints
