#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

make build/memory-user &>/dev/null

echo Q1:
man 1 free

echo Q2:
free -m
free -h

echo Q4:

echo -e "${GREEN}Before:${NC}"
free -m
build/memory-user 1000 5 &
pid=$!

sleep 2s
echo -e "${GREEN}After:${NC}"
free -m

kill -9 $pid
wait $pid

echo -e "${GREEN}Killed:${NC}"
free -m

wait # clear
echo Q5:
man 1 pmap

echo Q6:
build/memory-user 1000 3 &
pid=$!
sleep 2s

echo -e "${GREEN}Without -x flag:${NC}"
pmap $pid

echo -e "${GREEN}With -x flag:${NC}"
pmap -x $pid

wait # clear
echo Q7:
build/memory-user 1000 3 &
pid=$!
sleep 2s
pmap -X $pid

wait # clear
echo Q8:
for memory in {1,10,100,256}; do
  build/memory-user "$memory" 2 &
  pid=$!
  sleep 1s
  pmap $pid
  wait $pid
done
wait # clear
