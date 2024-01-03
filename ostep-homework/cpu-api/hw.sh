#!/bin/bash
set -eux

echo Q1:
./fork.py -s 10 -c

echo Q2:
for f in $(seq 1 9); do
  ./fork.py -a 100 -f "0.${f}" -c -F
done

echo Q3:
./fork.py -s 27 -t -c

echo Q4:
./fork.py -A "a+b,b+c,c+d,c+e,c-" -c
./fork.py -A "a+b,b+c,c+d,c+e,c-" -R -c

echo Q5:
./fork.py -s 30 -F -c

echo Q6:
./fork.py -s 40 -t -F -c
