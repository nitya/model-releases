#!/usr/bin/env bash
# _common.sh
# Shared helpers for the numbered setup scripts. Source it; don't run it.
#
#   source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"
#
# Works on bash 3.2 (macOS) and later.

if [[ -n "${_FOUNDRY_COMMON_LOADED:-}" ]]; then
  return 0
fi
_FOUNDRY_COMMON_LOADED=1

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPTS_DIR}/.." && pwd)"
ENV_FILE="${REPO_ROOT}/.env"
ENV_SAMPLE="${SCRIPTS_DIR}/sample.env"

DRY_RUN="${DRY_RUN:-false}"
ASSUME_YES="${ASSUME_YES:-false}"

# ---------- output ----------

info() { printf '→ %s\n' "$*"; }
ok()   { printf '✅ %s\n' "$*"; }
warn() { printf '⚠️  %s\n' "$*" >&2; }
die()  { printf '✗ %s\n' "$*" >&2; exit 1; }

# done_msg <text> — a success line that stays quiet during --dry-run.
done_msg() {
  [[ "$DRY_RUN" == "true" ]] || ok "$*"
}

# ---------- prerequisites ----------

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "$1 not found. ${2:-}"
}

need_az() {
  need_cmd az "Install the Azure CLI: https://learn.microsoft.com/cli/azure/install-azure-cli"
}

az_logged_in() {
  az account show >/dev/null 2>&1
}

# ---------- interaction ----------

is_interactive() {
  [[ "$ASSUME_YES" != "true" && -t 0 ]]
}

# prompt VAR "Question" "default"
# Keeps a value that is already set, so a flag skips its question.
prompt() {
  local var="$1" question="$2" default="${3:-}" reply
  if [[ -n "${!var:-}" ]]; then
    return 0
  fi
  if ! is_interactive; then
    [[ -n "$default" ]] || die "Missing value for ${var}. Pass it as a flag or run interactively."
    printf -v "$var" '%s' "$default"
    return 0
  fi
  if [[ -n "$default" ]]; then
    read -r -p "${question} [${default}]: " reply || true
    reply="${reply:-$default}"
  else
    read -r -p "${question}: " reply || true
  fi
  [[ -n "$reply" ]] || die "A value is required for: ${question}"
  printf -v "$var" '%s' "$reply"
}

# confirm "Question" [Y|N]  → returns 0 for yes
confirm() {
  local question="$1" default="${2:-Y}" reply hint="[Y/n]"
  [[ "$default" == "N" ]] && hint="[y/N]"
  if ! is_interactive; then
    [[ "$default" == "Y" ]]
    return
  fi
  read -r -p "${question} ${hint} " reply || true
  reply="${reply:-$default}"
  [[ "$reply" =~ ^[Yy] ]]
}

# ---------- execution ----------

# run <command...>  — prints instead of running when DRY_RUN=true.
run() {
  if [[ "$DRY_RUN" == "true" ]]; then
    printf '   [dry-run] %s\n' "$*"
    return 0
  fi
  "$@"
}

# ---------- names ----------

slugify() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//'
}

# A short, stable suffix: the same subscription and group always give the same value.
stable_suffix() {
  printf '%s' "$1" | cksum | awk '{print $1}' | cut -c1-5
}

# ---------- .env ----------

# update_env KEY VALUE — set or replace KEY in .env (macOS and Linux sed).
update_env() {
  local key="$1" value="$2" escaped
  [[ -n "$value" ]] || return 0
  [[ -f "$ENV_FILE" ]] || cp "$ENV_SAMPLE" "$ENV_FILE"
  escaped="${value//\\/\\\\}"
  escaped="${escaped//&/\\&}"
  escaped="${escaped//|/\\|}"
  if grep -q "^${key}=" "$ENV_FILE"; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
      sed -i '' "s|^${key}=.*|${key}=\"${escaped}\"|" "$ENV_FILE"
    else
      sed -i "s|^${key}=.*|${key}=\"${escaped}\"|" "$ENV_FILE"
    fi
  else
    printf '%s="%s"\n' "$key" "$value" >> "$ENV_FILE"
  fi
}

# env_value KEY — read KEY from .env without sourcing it.
env_value() {
  [[ -f "$ENV_FILE" ]] || return 0
  grep -E "^${1}=" "$ENV_FILE" | tail -n 1 | sed -E 's/^[^=]+=//; s/^"//; s/"$//'
}
