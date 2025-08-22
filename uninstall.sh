#!/usr/bin/env bash
set -euo pipefail

PREFIX="/usr/local"
BIN_PATH="$PREFIX/bin/nfm"
LIB_DIR="$PREFIX/share/nfm/lib"
LIB_FILE="$LIB_DIR/utils.sh"
SHARE_DIR="$PREFIX/share/nfm"
COMPL_DIR="/etc/bash_completion.d"
COMPL_FILE="$COMPL_DIR/nfm"

echo "🗑️  Uninstalling Nerd Font Manager..."

# Remove binary
if [ -f "$BIN_PATH" ]; then
  echo "Removing $BIN_PATH"
  sudo rm -f "$BIN_PATH"
else
  echo "Binary not found at $BIN_PATH"
fi

# Remove utils library
if [ -f "$LIB_FILE" ]; then
  echo "Removing $LIB_FILE"
  sudo rm -f "$LIB_FILE"
fi

# Remove lib dir if empty
if [ -d "$LIB_DIR" ] && [ -z "$(ls -A "$LIB_DIR")" ]; then
  echo "Removing empty directory $LIB_DIR"
  sudo rmdir "$LIB_DIR"
fi

# Remove share/nfm if empty
if [ -d "$SHARE_DIR" ] && [ -z "$(ls -A "$SHARE_DIR")" ]; then
  echo "Removing empty directory $SHARE_DIR"
  sudo rmdir "$SHARE_DIR"
fi

# Remove bash-completion
if [ -f "$COMPL_FILE" ]; then
  echo "Removing bash-completion $COMPL_FILE"
  sudo rm -f "$COMPL_FILE"
else
  echo "No bash-completion found at $COMPL_FILE"
fi

echo "✅ Uninstallation complete"
