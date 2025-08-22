#!/usr/bin/env bash
set -euo pipefail

GITHUB_USER="ajmasia"
REPO="$GITHUB_USER/nerdfonts-manager"
PREFIX="/usr/local"
COMPL_DIR="/etc/bash_completion.d"
COMPL_FILE="nfm"

echo "📦 Installing Nerd Font Manager..."

# Detect if we are inside a cloned repo (dev mode)
if [[ -f "./nfm" && -f "./lib/utils.sh" && "$0" != "bash" ]]; then
  echo "🛠️  Installing from local repository..."
  SRC_DIR="$(pwd)"
  DEV_MODE=1
else
  echo "🌐 Downloading from GitHub..."
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT
  curl -fsSL "https://github.com/$REPO/archive/refs/heads/main.tar.gz" |
    tar -xz -C "$tmpdir"
  SRC_DIR="$tmpdir/nerdfonts-manager-main"
  DEV_MODE=0
fi

# Install binary and library
sudo mkdir -p "$PREFIX/bin" "$PREFIX/share/nfm/lib"
sudo install -m 755 "$SRC_DIR/nfm" "$PREFIX/bin/nfm"
sudo install -m 644 "$SRC_DIR/lib/utils.sh" "$PREFIX/share/nfm/lib/utils.sh"

echo "✅ Installed to $PREFIX/bin/nfm"

# Install bash-completion (always)
if [ -d "$COMPL_DIR" ]; then
  if [ "$DEV_MODE" -eq 1 ]; then
    if [ -f "$SRC_DIR/nfm-completion.bash" ]; then
      echo "⚙️  Installing completion from local repo..."
      sudo install -m 644 "$SRC_DIR/nfm-completion.bash" "$COMPL_DIR/$COMPL_FILE"
    else
      echo "⚠️  No local completion file found in repo root"
    fi
  else
    echo "⬇️  Downloading completion script..."
    curl -fsSL "https://raw.githubusercontent.com/ajmasia/nerdfonts-manager/main/contrib/nfm-completion.bash" |
      sudo tee "$COMPL_DIR/$COMPL_FILE" >/dev/null
  fi

  echo "✅ Completion installed at $COMPL_DIR/$COMPL_FILE"
  echo "👉 Restart your shell or run: source $COMPL_DIR/$COMPL_FILE"
  echo "ℹ️  To uninstall completion: sudo rm $COMPL_DIR/$COMPL_FILE"
else
  echo "⚠️  bash-completion not found (missing $COMPL_DIR)"
fi

echo "👉 Run: nfm -h to start using Nerd Font Manager"
