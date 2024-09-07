#!/bin/bash
set -eu

function echo_red() {
  RED='\033[0;31m'
  NC='\033[0m'
  echo -e "${RED}${1}${NC}"
}

ANSWER=${ANSWER:-}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROGRAM="$SCRIPT_DIR/mem"

ANSWER="-c"

function wait_for_input() {
  if [[ -n "$ANSWER" ]]; then
    time=${1:-"8s"}
    sleep "${time}";
  else
    read -r -n 1 -s -p "Press any key to continue..." _;
  fi
}

SESSION="ch21"
WINDOW="main"
PANE_BASE_INDEX=$(tmux show-window-options -g -v "pane-base-index")
PANE_VMSTAT="$WINDOW.$(( PANE_BASE_INDEX ))"
PANE_MEM_1="$WINDOW.$(( PANE_BASE_INDEX + 1 ))"
PANE_MEM_2="$WINDOW.$(( PANE_BASE_INDEX + 2 ))"
PANE_MEM_3="$WINDOW.$(( PANE_BASE_INDEX + 3 ))"
PANE_MEM_4="$WINDOW.$(( PANE_BASE_INDEX + 4 ))"

tmux kill-session -t "$SESSION" >& /dev/null || true

# Perpare tmux session
tmux new-session -d -c "$HOME" -s "$SESSION" -n "$WINDOW"
wait_for_input 2

# resize window
tmux split-window -c "$HOME" -h -p 50
tmux split-window -c "$HOME" -v -p 50
tmux split-window -c "$HOME" -h -p 50
tmux split-window -c "$HOME" -h -p 50 -t "$PANE_MEM_1"
tmux resize-pane -x 109 -t "$PANE_VMSTAT"
tmux send-key -t "$PANE_VMSTAT" "vmstat 1 --wide --unit M" C-m

echo_red Q1:
wait_for_input 8
tmux send-key -t "$PANE_MEM_1" "$PROGRAM 1" C-m
wait_for_input 8
tmux send-key -t "$PANE_MEM_2" "$PROGRAM 1" C-m
wait_for_input 8
tmux send-key -t "$PANE_MEM_3" "$PROGRAM 1" C-m
wait_for_input 8
tmux send-key -t "$PANE_MEM_4" "$PROGRAM 1" C-m
wait_for_input 8
tmux send-key -t "$PANE_MEM_1" C-c
tmux send-key -t "$PANE_MEM_2" C-c
tmux send-key -t "$PANE_MEM_3" C-c
tmux send-key -t "$PANE_MEM_4" C-c
sleep 1

# only preserve one pane for mem
tmux kill-pane -t "$PANE_MEM_4"
tmux kill-pane -t "$PANE_MEM_3"
tmux kill-pane -t "$PANE_MEM_2"
tmux resize-pane -x 114 -t "$PANE_VMSTAT"

echo_red Q2:
wait_for_input 8
tmux send-key -t "$PANE_MEM_1" "$PROGRAM 1024" C-m
wait_for_input 8

tmux send-key -t "$PANE_MEM_1" C-c
sleep 1

echo_red Q3:
echo_red Q4:
wait_for_input 8
tmux send-key -t "$PANE_MEM_1" "$PROGRAM 4000" C-m
wait_for_input 8
tmux send-key -t "$PANE_MEM_1" C-c
sleep 1

tmux send-key -t "$PANE_MEM_1" "$PROGRAM 5000" C-m
wait_for_input 8
tmux send-key -t "$PANE_MEM_1" C-c
sleep 1

tmux send-key -t "$PANE_MEM_1" "$PROGRAM 6000" C-m
wait_for_input 8
tmux send-key -t "$PANE_MEM_1" C-c
sleep 1

echo_red Q5:
wait_for_input 8
tmux send-key -t "$PANE_MEM_1" "$PROGRAM 4000" C-m
wait_for_input 8
tmux send-key -t "$PANE_MEM_1" C-c
sleep 1

tmux send-key -t "$PANE_MEM_1" "$PROGRAM 12000" C-m
wait_for_input 20m
tmux send-key -t "$PANE_MEM_1" C-c
sleep 1

read -r -n 1 -s -p "Press any key to exit..." _
tmux kill-session -t "$SESSION"
printf "\nexiting...\n"

wait
