#!/bin/bash
set -eux

./process-run.py -l 5:100,5:100 -c -p # 1
./process-run.py -l 4:100,1:0 -c -p # 2
./process-run.py -l 1:0,4:100 -c -p # 3
./process-run.py -l 1:0,4:100 -S SWITCH_ON_END -c -p # 4
./process-run.py -l 1:0,4:100 -S SWITCH_ON_IO -c -p # 5
./process-run.py -l 3:0,5:100,5:100,5:100 -S SWITCH_ON_IO -I IO_RUN_LATER -c -p # 6
./process-run.py -l 3:0,5:100,5:100,5:100 -S SWITCH_ON_IO -I IO_RUN_IMMEDIATE -c -p # 7

# 8
for s in $(seq 1 3); do
  for I in {"IO_RUN_LATER","IO_RUN_IMMEDIATE"}; do
    for S in {"SWITCH_ON_END","SWITCH_ON_IO"}; do
      ./process-run.py -s "$s" -l "3:50,3:50" -S "$S" -I "$I" -c -p
    done
  done
done
