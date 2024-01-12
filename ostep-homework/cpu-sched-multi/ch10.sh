#!/bin/bash
set -eux

echo Q1:
./multi.py -n 1 -L a:30:200 -c -t

echo Q2:
./multi.py -n 1 -L a:30:200 -M 300 -c -t
./multi.py -n 1 -L a:30:200 -M 300 -r 4 -c -t

echo Q3:
./multi.py -n 1 -L a:30:200 -M 300 -c -T
./multi.py -n 1 -L a:30:200 -M 300 -r 4 -c -T

echo Q4:
./multi.py -n 1 -L a:30:200 -M 300 -c -T -C
./multi.py -n 1 -L a:30:200 -M 300 -w 4 -c -T -C

echo Q5:
./multi.py -n 2 -L a:100:100,b:100:50,c:100:50 -c -T -C

echo Q6:
./multi.py -n 2 -L a:100:100,b:100:50,c:100:50 -A a:0,b:1,c:1 -c -T -C

echo Q7:
./multi.py -n 1 -L a:100:100,b:100:100,c:100:100 -A a:0,b:0,c:0 -M 50 -c -T -C
./multi.py -n 3 -L a:100:100,b:100:100,c:100:100 -A a:0,b:1,c:2 -M 50 -c -T -C
./multi.py -n 3 -L a:100:100,b:100:100,c:100:100 -A a:0,b:1,c:2 -M 100 -c -T -C

echo Q8:
./multi.py -n 2 -L a:100:100,b:100:50,c:100:50 -p -c -T -C -S
./multi.py -n 2 -L a:100:100,b:100:50,c:100:50 -p -P 5 -c -T -C -S
