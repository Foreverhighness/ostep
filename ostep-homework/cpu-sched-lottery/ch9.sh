#!/bin/bash
set -eux

echo Q1:
for s in $(seq 1 3); do
  ./lottery.py -j 3 -s "$s" -c
done

echo Q2:
./lottery.py -l "10:1,10:100" -c | grep "DONE"

echo Q3:
for s in $(seq 0 3); do
  ./lottery.py -s "$s" -l "100:100,100:100" -c | grep "DONE" | xargs | awk '{print $14 - $7}'
done

echo Q4:
for q in {2,4,8,20,50,100}; do
  echo "quantum=$q:"
  for s in $(seq 0 3); do
    ./lottery.py -q "$q" -s "$s" -l "100:100,100:100" -c | grep "DONE" | xargs | awk '{print $14 - $7}'
  done
done
