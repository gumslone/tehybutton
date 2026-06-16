#!/usr/bin/env bash
set -euo pipefail
#
# Flash the TeHyButton firmware over serial (CLI). Thin wrapper around
# tools/bugzapper/flash.sh: when no -f is given it defaults to the shipped
# esp8285 binary at the repo root. All flash.sh options pass through.
#
#   ./flash.sh                 # flash the shipped tehybutton.ino.esp8285.bin
#   ./flash.sh -e              # erase all flash, then write
#   ./flash.sh -p /dev/cu.usbserial-110 -b 460800
#   ./flash.sh -f build/esp8285/release/tehybutton.ino.bin
#   ./flash.sh -l              # list serial ports
#   ./flash.sh -h              # full help

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

args=("$@")

# Default firmware = the shipped esp8285 bin at the repo root, unless the
# caller passed their own -f (or just wants -l/-h).
has_override=0
for a in "$@"; do
  case "$a" in -f|-l|-h) has_override=1 ;; esac
done
if [ "$has_override" -eq 0 ]; then
  fw="$(ls "$DIR"/tehybutton*.bin 2>/dev/null | sort | head -n1 || true)"
  [ -n "$fw" ] && args=(-f "$fw" "$@")
fi

exec "$DIR/tools/bugzapper/flash.sh" "${args[@]}"
