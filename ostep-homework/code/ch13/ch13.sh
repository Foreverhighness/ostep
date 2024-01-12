#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
function echo_red() {
  echo -e "${RED}${1}${NC}"
}
function echo_green() {
  echo -e "${GREEN}${1}${NC}"
}

make all &>/dev/null

echo_red Q1:
man 1 free

echo_red Q2:
free -m
free -h

echo_red Q4:

echo_greed "Before:"
free -m
build/memory-user 1000 5 &
pid=$!

sleep 2s
echo_greed "After:"
free -m

kill -9 $pid
wait $pid

echo_greed "Killed:"
free -m

wait # clear
echo_red Q5:
man 1 pmap

echo_red Q6:
build/memory-user 1000 3 &
pid=$!
sleep 2s

echo_greed "Without -x flag:"
pmap $pid

echo_greed "With -x flag:"
pmap -x $pid

wait # clear
echo_red Q7:
build/memory-user 1000 3 &
pid=$!
sleep 2s
pmap -X $pid

wait # clear
echo_red Q8:
for memory in {1,10,100,256}; do
  build/memory-user "$memory" 2 &
  pid=$!
  sleep 1s
  pmap $pid
  wait $pid
done
wait # clear
