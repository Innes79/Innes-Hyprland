#!/usr/bin/env bash

STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}"
PREV_FILE="$STATE_DIR/show-desktop-prev"
SCRATCH_FILE="$STATE_DIR/show-desktop-scratch"

current=$(hyprctl activeworkspace -j | jq -r '.id')
# Name of the special workspace open on the focused monitor ("" if none)
special=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .specialWorkspace.name')
special="${special#special:}"

if [ -n "$special" ]; then
    # Scratchpad is open: remember it, close it, go to 9
    echo "$current" > "$PREV_FILE"
    echo "$special" > "$SCRATCH_FILE"
    hyprctl dispatch "hl.dsp.workspace.toggle_special('$special')"
    [ "$current" != "9" ] && hyprctl dispatch "hl.dsp.focus({ workspace = 9 })"

elif [ "$current" != "9" ]; then
    # Normal workspace: remember it, go to 9
    echo "$current" > "$PREV_FILE"
    : > "$SCRATCH_FILE"
    hyprctl dispatch "hl.dsp.focus({ workspace = 9 })"

else
    # On 9: go back, and reopen the scratchpad if it was open before
    prev=$(cat "$PREV_FILE" 2>/dev/null)
    scratch=$(cat "$SCRATCH_FILE" 2>/dev/null)
    hyprctl dispatch "hl.dsp.focus({ workspace = ${prev:-1} })"
    if [ -n "$scratch" ]; then
        hyprctl dispatch "hl.dsp.workspace.toggle_special('$scratch')"
        : > "$SCRATCH_FILE"
    fi
fi
