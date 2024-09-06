#!/bin/bash
set -eux

function echo_red() {
  RED='\033[0;31m'
  NC='\033[0m'
  echo -e "${RED}${1}${NC}"
}

ANSWER=${ANSWER:-}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROGRAME="${SCRIPT_DIR}/paging-multilevel-translate.py"

echo_red Q1:
# only one

echo_red Q2:
"${PROGRAME}" --seed=0 "$ANSWER"
"${PROGRAME}" --seed=1 "$ANSWER"
"${PROGRAME}" --seed=2 "$ANSWER"

echo_red Q3:
# need TLB
