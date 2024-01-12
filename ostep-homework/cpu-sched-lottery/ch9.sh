#!/bin/bash
set -eux

echo Q1:
for s in $(seq 1 3); do
  ./lottery.py -j 3 -s "$s" -c
done

echo Q2:
./lottery.py -l "10:1,10:100" -c | grep "DONE"
python3 <<EOF
from functools import lru_cache
from fractions import Fraction

def calc(m, n, p):
  @lru_cache(None)
  def dp(x, y):
    if x == -1 or y == -1: return Fraction(0)
    if (x, y) == (0, 0): return Fraction(1)
    left = dp(x - 1, y)
    if y != n: left *= p
    down = dp(x, y - 1)
    if x != m: down *= 1 - p
    return left + down
  print(float(dp(m, n - 1)))

calc(10, 10, Fraction('1/101'))
EOF

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
