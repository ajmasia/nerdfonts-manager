#!/usr/bin/env bash
set -u

# -------------------- Color support --------------------
supports_color() {
  { [ -t 1 ] || [ -t 2 ]; } || return 1
  [ -z "${NO_COLOR:-}" ] || return 1
  if command -v tput >/dev/null 2>&1; then
    [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]
  else
    return 0
  fi
}

if supports_color; then
  if command -v tput >/dev/null 2>&1; then
    BOLD="$(tput bold)"
    DIM="$(tput dim 2>/dev/null || printf $'\e[2m')"
    RESET="$(tput sgr0)"
    CYAN="$(tput setaf 6)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    RED="$(tput setaf 1)"
  else
    BOLD=$'\e[1m'
    DIM=$'\e[2m'
    RESET=$'\e[0m'
    CYAN=$'\e[36m'
    GREEN=$'\e[32m'
    YELLOW=$'\e[33m'
    RED=$'\e[31m'
  fi
else
  BOLD='' DIM='' RESET='' CYAN='' GREEN='' YELLOW='' RED=''
fi

# -------------------- Logging helpers --------------------
info() { printf '%s\n' "$*"; }
warn() { printf '%b\n' "${YELLOW}⚠️  $*${RESET}" >&2; }
error() { printf '%b\n' "${RED}❌ $*${RESET}" >&2; }
die() {
  error "$*"
  exit 1
}

# -------------------- Utility helpers --------------------
_have() { command -v "$1" >/dev/null 2>&1; }

_join_unique() {
  declare -A seen=()
  local out=() x
  for x in "$@"; do
    [[ -n "$x" && -z "${seen[$x]:-}" ]] && {
      out+=("$x")
      seen["$x"]=1
    }
  done
  printf '%s' "${out[*]}"
}

# -------------------- Downloader (no eval) --------------------
set_downloader() {
  if command -v curl >/dev/null 2>&1; then
    downloader() { curl -fsSL "$1" -o "$2"; }
  elif command -v wget >/dev/null 2>&1; then
    downloader() { wget -qO "$2" "$1"; }
  else
    die "No downloader found (curl/wget)."
  fi
}
