#!/usr/bin/env bash
set -euo pipefail
#
# Launch BugZapper (the GUI flasher + serial monitor) branded for TeHyButton.
# It lists the shipped firmware at the repo root and flashes/monitors the
# ESP8285 in one window. See tools/bugzapper/ for the underlying tool.
#
# Usage: ./bugzapper.sh [firmware-dir]   (default: this repo's root)

DIR="$(cd "$(dirname "$0")" && pwd)"

export BUGZAPPER_TITLE="TeHyButton Flasher"
export BUGZAPPER_ICON="$DIR/tools/bugzapper/icon.png"
# The release esp8285 binary lives at the repo root (refreshed by build.sh).
export BUGZAPPER_FW_DIR="${1:-$DIR}"

exec "$DIR/tools/bugzapper/bugzapper.sh" "$@"
