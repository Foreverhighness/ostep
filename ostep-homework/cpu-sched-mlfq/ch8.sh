#!/bin/bash
set -eux

echo Q1:
for s in $(seq 0 3); do
  ./mlfq.py -j 2 -n 2 --maxlen=10 --maxio=0 -s "$s" -c
done

echo Q2:
echo "Figure 8.2: Long-running Job Over Time"
./mlfq.py -Q "10,10,10" -l "0,200,0" -c

echo "Figure 8.3: Along Came An Interactive Job: Two Examples"
./mlfq.py -Q "10,10,10" -l "0,180,0:80,20,0" -c
./mlfq.py -Q "10,10,10" -l "0,180,0:80,20,1" -i 5 -S -c

echo "Figure 8.4: Without (Left) and With (Right) Priority Boost"
./mlfq.py -Q "10,10,10" -l "0,110,0:100,50,1:100,50,1" -i 1 -S -c
./mlfq.py -Q "10,10,10" -l "0,110,0:100,50,1:100,50,1" -i 1 -S -B 100 -c

echo "Figure 8.5: Without (Left) and With (Right) Gaming Tolerance"
./mlfq.py -Q "10,10,10" -l "0,200,0:100,100,9" -i 1 -S -c
./mlfq.py -Q "10,10,10" -l "0,200,0:100,100,9" -i 1 -c

echo "Figure 8.6: Lower Priority, Longer Quanta"
./mlfq.py -Q "10,20,40" -A "2,2,1" -l "0,140,0:0,140,0" -c

echo Q3:
./mlfq.py -j 2 -q 1 --maxlen=10 --maxio=0 -n 1 -c

echo Q4:
./mlfq.py -Q "2,1" -l "0,3,0:0,10,1" -i 0 -S -c

echo Q5:
samples=2
longrunning=$((10 * samples + 1))
hacker=$((190 * samples + 1))
./mlfq.py -Q "10,1" -l "0,$longrunning,0:0,$hacker,5" -i 0 -S -B 200 -c

echo Q6:
./mlfq.py -Q "1" -l "0,10,0:0,10,1" -i 0 -c
./mlfq.py -Q "1" -l "0,10,0:0,10,1" -i 0 -I -c
