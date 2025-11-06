#!/usr/bin/env bash

set -euo pipefail

GITHUB_USER="ajmasia"
REPO="$GITHUB_USER/nerdfonts-manager"
PREFIX="/usr/local"
COMPL_DIR="/etc/bash_completion.d"
COMPL_FILE="nfm"

# logger
BOLD="\033[1m"
BLUE="\033[34m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
MAGENTA="\033[35m"
CYAN="\033[36m"
RESET="\033[0m"

success() { printf "${BOLD}${GREEN}${RESET} %s\n" "$*"; }
running() { printf "${BOLD}${MAGENTA}${RESET} %s\n" "$*"; }
info() { printf "${BOLD}${CYAN}${RESET} %s\n" "$*"; }
warn() { printf "${BOLD}${YELLOW}${RESET} %s\n" "$*"; }
err() { printf "${BOLD}${RED}󰅙${RESET} %s\n" "$*" >&2; }

# --- Argument handling ---
SILENT=0
for arg in "$@"; do
  case "$arg" in
  --silent | -s)
    SILENT=1
    shift
    ;;
  esac
done

# --- Logging helpers ---
log() {
  # Regular message (only shown if not silent)
  if [[ $SILENT -eq 0 ]]; then
    echo -e "$@"
  fi
}

always() {
  # Always show this message, even in silent mode
  echo -e "$@"
}

always "${MAGENTA}${RESET} Installing Nerd Font Manager..."

# --- Check if already installed ---
if command -v nfm >/dev/null 2>&1; then
  EXISTING_PATH="$(command -v nfm)"
  always "${BOLD}${BLUE}${RESET} Already installed at: $EXISTING_PATH"
  always "${BOLD}${BLUE}${RESET} To reinstall, remove using unistall script"
  exit 0
fi

# --- Detect if running in local (dev) mode ---
if [[ -f "./nfm" && -f "./lib/utils.sh" && "$0" != "bash" ]]; then
  log "🛠️  Installing from local repository..."
  SRC_DIR="$(pwd)"
  DEV_MODE=1
else
  log "🌐 Downloading from GitHub..."
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT
  if ! curl -fsSL "https://github.com/$REPO/archive/refs/heads/main.tar.gz" | tar -xz -C "$tmpdir"; then
    always "❌ Installation failed: unable to download repository."
    exit 1
  fi
  SRC_DIR="$tmpdir/nerdfonts-manager-main"
  DEV_MODE=0
fi

# --- Install binary and library ---
if ! sudo mkdir -p "$PREFIX/bin" "$PREFIX/share/nfm/lib"; then
  always "❌ Installation failed: unable to create target directories."
  exit 1
fi

if ! sudo install -m 755 "$SRC_DIR/nfm" "$PREFIX/bin/nfm"; then
  always "❌ Installation failed: could not install binary."
  exit 1
fi

if ! sudo install -m 644 "$SRC_DIR/lib/utils.sh" "$PREFIX/share/nfm/lib/utils.sh"; then
  always "❌ Installation failed: could not install library."
  exit 1
fi

# --- Bash completion ---
if [ -d "$COMPL_DIR" ]; then
  if [ "$DEV_MODE" -eq 1 ]; then
    if [ -f "$SRC_DIR/contrib/nfm-completion.bash" ]; then
      log "⚙️  Installing completion from local repo..."
      sudo install -m 644 "$SRC_DIR/contrib/nfm-completion.bash" "$COMPL_DIR/$COMPL_FILE"
    else
      log "⚠️  No local completion file found in repository root"
    fi
  else
    log "⬇️  Downloading completion script..."
    curl -fsSL "https://raw.githubusercontent.com/ajmasia/nerdfonts-manager/main/contrib/nfm-completion.bash" |
      sudo tee "$COMPL_DIR/$COMPL_FILE" >/dev/null
  fi
else
  log "⚠️  bash-completion directory not found ($COMPL_DIR)"
fi

always "✅ Installation completed successfully!"
log "\n👉 Run: nfm -h to start using Nerd Font Manager"
