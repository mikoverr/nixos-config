#!/usr/bin/env bash
set -uo pipefail

echo "==> Hot reloading services for $USER..."

if pgrep -x "waybar" >/dev/null; then
  killall -SIGUSR2 waybar
  echo "    [reload] Waybar restarted"
fi

if pgrep -x "dunst" >/dev/null; then
  killall dunst
  echo "    [reload] Dunst restarted"
fi
