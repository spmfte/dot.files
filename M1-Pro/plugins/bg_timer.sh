#!/usr/bin/env bash
# ~/.config/sketchybar/plugins/bg_timer.sh

# Temporary file to record the start timestamp of the process.
TIMER_FILE="/tmp/sketchybar_bg_timer"

# Function to format elapsed seconds as HH:MM:SS
format_time() {
  local total_seconds=$1
  local hours=$(( total_seconds / 3600 ))
  local minutes=$(( (total_seconds % 3600) / 60 ))
  local seconds=$(( total_seconds % 60 ))
  printf "%02d:%02d:%02d" "$hours" "$minutes" "$seconds"
}

update_timer() {
  if [[ -f "$TIMER_FILE" ]]; then
    local start_time
    start_time=$(cat "$TIMER_FILE")
    local now elapsed formatted
    now=$(date +%s)
    elapsed=$(( now - start_time ))
    formatted=$(format_time "$elapsed")
    # Update the item to show elapsed time and a “running” color.
    sketchybar --set "$NAME" label="Task Running: ${formatted}" \
                         background.color=0xffa6da95 label.drawing=yes
  else
    # No task is running; hide or reset the label.
    sketchybar --set "$NAME" label="" \
                         background.color=0xff000000 label.drawing=off
  fi
}

case "$SENDER" in
  "bg_task_started")
    # On start, create the timer file with the current timestamp.
    if [[ ! -f "$TIMER_FILE" ]]; then
      date +%s > "$TIMER_FILE"
    fi
    update_timer
    ;;
  "bg_task_finished")
    # On finish, remove the timer file and indicate completion.
    if [[ -f "$TIMER_FILE" ]]; then
      rm "$TIMER_FILE"
    fi
    sketchybar --set "$NAME" label="Task Finished" \
                         background.color=0xffc995da label.drawing=yes
    ;;
  *)
    # For routine updates (invoked by update_freq), just update the timer display.
    update_timer
    ;;
esac
