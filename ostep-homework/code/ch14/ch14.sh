#!/bin/bash

make build/null &>/dev/null

echo Q2:
gdb build/null <<<'run'

echo Q3:
valgrind --leak-check=yes build/null
