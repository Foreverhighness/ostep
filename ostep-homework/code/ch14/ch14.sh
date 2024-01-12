#!/bin/bash

make build/null &>/dev/null

echo Q2:
gdb build/null <<<'run'
