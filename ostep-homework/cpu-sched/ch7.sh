#!/bin/bash
set -eux

echo Q1:
./scheduler.py -l "200,200,200" -p SJF -c
./scheduler.py -l "200,200,200" -p FIFO -c

echo Q2:
./scheduler.py -l "300,200,100" -p SJF -c
./scheduler.py -l "300,200,100" -p FIFO -c

echo Q3:
./scheduler.py -l "300,200,100" -p RR -q 1 -c

echo Q4:
./scheduler.py -l "100,200,200" -p SJF -c
./scheduler.py -l "100,200,200" -p FIFO -c

echo Q5:
./scheduler.py -l "100,200,300,400" -p SJF -c
./scheduler.py -l "100,200,300,400" -p RR -q 300 -c

echo Q6:
for m in $(seq 100 100 1000); do
  echo "maxlen=$m"
  ./scheduler.py -s 30 -m "$m" -p SJF -c | grep "Average -- Response:"
done

echo Q7:
./scheduler.py -l "400,300,200,100" -p RR -q 400 -c
