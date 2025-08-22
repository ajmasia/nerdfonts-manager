#!/usr/bin/env bash
set -euo pipefail

GITHUB_USER="ajmasia"
REPO="$GITHUB_USER/nerdfonts-manager"
PREFIX="/usr/local"

echo "📦 Installing Nerd Font Manager..."

# Detect if we are inside a cloned repo (dev mode)
if [ -f "./nfm" ] && [ -f "./lib/utils.sh" ]; then
  echo "🛠️  Installing from local repository..."
  SRC_DIR="$(pwd)"
else
  echo "🌐 Downloading from GitHub..."
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT
  curl -fsSL "https://github.com/$REPO/archive/refs/heads/main.tar.gz" |
    tar -xz -C "$tmpdir"
  SRC_DIR="$tmpdir/nerdfonts-manager-main"
fi

# Install binary and library
sudo mkdir -p "$PREFIX/bin" "$PREFIX/share/nfm/lib"
sudo install -m 755 "$SRC_DIR/nfm" "$PREFIX/bin/nfm"
sudo install -m 644 "$SRC_DIR/lib/utils.sh" "$PREFIX/share/nfm/lib/utils.sh"

echo "✅ Installed to $PREFIX/bin/nfm"
echo "👉 Run: nfm -h"
