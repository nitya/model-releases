#!/usr/bin/env bash
# 3-deploy-model.sh
# Purpose:    Deploy a model to your Foundry resource and, optionally, save the
#             deployment name in .env for the capsule that needs it.
# Prereqs:    1-create-rg.sh has run (or pass --resource-group), Azure CLI signed
#             in, and permission to create deployments (Foundry Account Owner,
#             Cognitive Services Contributor, or Owner on the resource group).
# Learn ref:  https://learn.microsoft.com/azure/foundry/foundry-models/how-to/create-model-deployments
# Usage:      ./scripts/3-deploy-model.sh --list [search]
#             ./scripts/3-deploy-model.sh <deployment-name> <model-name> [options]

set -euo pipefail

# shellcheck source=_common.sh
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

usage() {
  cat <<'EOF'
Deploy a model to your Foundry resource.

Usage:
  ./scripts/3-deploy-model.sh --list [search]
  ./scripts/3-deploy-model.sh <deployment-name> <model-name> [options]

Name the deployment for the job it does (router-nano, policy-mini), not for the
model, so notebooks keep working when you swap models later.

Options:
  --list [search]          List models you can deploy, optionally filtered by name
  --resource-group <name>  Resource group (default: AZURE_RESOURCE_GROUP in .env)
  --account <name>         Foundry resource (default: the one in the resource group)
  --format <format>        Model format, for example OpenAI or Microsoft
  --version <version>      Model version (default: the catalog's)
  --sku <sku>              Deployment type, for example GlobalStandard
  --capacity <number>      Capacity in thousands of tokens per minute
  --env-var <NAME>         Save the deployment name to .env as NAME
  --dry-run                Show what would run without changing anything
  -h, --help               Show this help

Examples:
  ./scripts/3-deploy-model.sh --list mai
  ./scripts/3-deploy-model.sh image-flash MAI-Image-2.5-Flash --env-var AZURE_MAI_IMAGE_25_FLASH_DEPLOYMENT
EOF
}

# ---------- arguments ----------

RG="" ACCOUNT="" FORMAT="" VERSION="" SKU="" CAPACITY="" ENV_VAR=""
LIST=false SEARCH="" DEPLOYMENT="" MODEL=""

need_value() { [[ $# -ge 2 && -n "$2" ]] || die "$1 needs a value."; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --list)
      LIST=true; shift
      if [[ $# -gt 0 && "$1" != -* ]]; then SEARCH="$1"; shift; fi ;;
    --resource-group) need_value "$@"; RG="$2"; shift 2 ;;
    --account)        need_value "$@"; ACCOUNT="$2"; shift 2 ;;
    --format)         need_value "$@"; FORMAT="$2"; shift 2 ;;
    --version)        need_value "$@"; VERSION="$2"; shift 2 ;;
    --sku)            need_value "$@"; SKU="$2"; shift 2 ;;
    --capacity)       need_value "$@"; CAPACITY="$2"; shift 2 ;;
    --env-var)        need_value "$@"; ENV_VAR="$2"; shift 2 ;;
    --dry-run)        DRY_RUN=true; shift ;;
    -h|--help)        usage; exit 0 ;;
    -*)               die "Unknown option: $1 (see --help)" ;;
    *)
      if [[ -z "$DEPLOYMENT" ]]; then DEPLOYMENT="$1"
      elif [[ -z "$MODEL" ]]; then MODEL="$1"
      else die "Unexpected argument: $1 (see --help)"
      fi
      shift ;;
  esac
done

if [[ "$LIST" != "true" ]]; then
  [[ -n "$DEPLOYMENT" && -n "$MODEL" ]] || { usage >&2; exit 1; }
fi

# ---------- context ----------

need_az
az_logged_in || die "Not signed in. Run ./scripts/1-create-rg.sh (or: az login)."

SUB_ARGS=()
SUB_FROM_ENV="$(env_value AZURE_SUBSCRIPTION_ID)"
if [[ -n "$SUB_FROM_ENV" ]]; then
  SUB_ARGS=(--subscription "$SUB_FROM_ENV")
fi

RG="${RG:-$(env_value AZURE_RESOURCE_GROUP)}"
[[ -n "$RG" ]] || die "No resource group. Run ./scripts/1-create-rg.sh first, or pass --resource-group."

if [[ -z "$ACCOUNT" ]]; then
  accounts="$(az cognitiveservices account list --resource-group "$RG" "${SUB_ARGS[@]+"${SUB_ARGS[@]}"}" \
    --query "[?kind=='AIServices'].name" -o tsv 2>/dev/null || true)"
  count="$(printf '%s\n' "$accounts" | grep -c . || true)"
  case "$count" in
    0) die "No Foundry resource found in '${RG}'. Run ./scripts/1-create-rg.sh first." ;;
    1) ACCOUNT="$accounts" ;;
    *) die "More than one Foundry resource in '${RG}'. Pick one with --account:"$'\n'"${accounts}" ;;
  esac
fi

az_models() {
  az cognitiveservices account list-models --name "$ACCOUNT" --resource-group "$RG" \
    "${SUB_ARGS[@]+"${SUB_ARGS[@]}"}" \
    --query "[].[name, format, version, skus[0].name, skus[0].capacity.default]" -o tsv
}

# ---------- list ----------

if [[ "$LIST" == "true" ]]; then
  note=""
  [[ -z "$SEARCH" ]] || note=" matching '${SEARCH}'"
  info "Models available on ${ACCOUNT}${note}..."
  rows="$(az_models | sort -u | { if [[ -n "$SEARCH" ]]; then grep -i -- "$SEARCH" || true; else cat; fi; })"
  [[ -n "$rows" ]] || die "No models found${note}."
  total="$(printf '%s\n' "$rows" | wc -l | tr -d ' ')"
  printf '%-40s %-14s %-12s %-20s %s\n' MODEL FORMAT VERSION DEPLOYMENT-TYPE CAPACITY
  printf '%s\n' "$rows" | head -n 60 | awk -F'\t' '{printf "%-40s %-14s %-12s %-20s %s\n", $1, $2, $3, $4, $5}'
  [[ "$total" -le 60 ]] || echo "... ${total} matches; narrow it with: --list <search>"
  exit 0
fi

# ---------- deploy ----------

if az cognitiveservices account deployment show --name "$ACCOUNT" --resource-group "$RG" \
     --deployment-name "$DEPLOYMENT" "${SUB_ARGS[@]+"${SUB_ARGS[@]}"}" >/dev/null 2>&1; then
  ok "Deployment '${DEPLOYMENT}' already exists on ${ACCOUNT}"
else
  # Look up the model so format, version, and deployment type come from the catalog.
  match="$(az_models | sort -u | awk -F'\t' -v m="$MODEL" -v f="$FORMAT" -v v="$VERSION" -v s="$SKU" '
    tolower($1) == tolower(m) && (f == "" || tolower($2) == tolower(f)) \
      && (v == "" || $3 == v) && (s == "" || tolower($4) == tolower(s))' | sort -t$'\t' -k3,3 | tail -n 1)"
  [[ -n "$match" ]] || die "No deployable model named '${MODEL}' matches. Try: ./scripts/3-deploy-model.sh --list ${MODEL}"

  IFS=$'\t' read -r found_name found_format found_version found_sku found_capacity <<< "$match"
  CAPACITY="${CAPACITY:-${found_capacity:-1}}"
  [[ "$CAPACITY" =~ ^[0-9]+$ ]] || CAPACITY=1

  info "Deploying ${found_name} ${found_version} (${found_format}, ${found_sku}, capacity ${CAPACITY}) as '${DEPLOYMENT}'..."
  err="$(mktemp)"
  if run az cognitiveservices account deployment create \
       --name "$ACCOUNT" --resource-group "$RG" "${SUB_ARGS[@]+"${SUB_ARGS[@]}"}" \
       --deployment-name "$DEPLOYMENT" \
       --model-name "$found_name" --model-version "$found_version" --model-format "$found_format" \
       --sku-name "$found_sku" --sku-capacity "$CAPACITY" --output none 2>"$err"; then
    :
  else
    msg="$(cat "$err")"
    rm -f "$err"
    case "$msg" in
      *AuthorizationFailed*|*Forbidden*|*"does not have authorization"*)
        die "You can't create deployments here. Foundry User can't deploy; ask an owner for Foundry Account Owner or Cognitive Services Contributor on ${ACCOUNT}." ;;
      *InsufficientQuota*|*quota*)
        die "Not enough quota for ${found_sku}. Lower it with --capacity <n>, pick another --sku, or request quota in the portal." ;;
      *) printf '%s\n' "$msg" >&2; die "The deployment failed." ;;
    esac
  fi
  rm -f "$err"

  if [[ "$DRY_RUN" != "true" ]]; then
    for _ in $(seq 1 60); do
      state="$(az cognitiveservices account deployment show --name "$ACCOUNT" --resource-group "$RG" \
        --deployment-name "$DEPLOYMENT" "${SUB_ARGS[@]+"${SUB_ARGS[@]}"}" \
        --query properties.provisioningState -o tsv 2>/dev/null || true)"
      case "$state" in
        Succeeded) ok "Deployment '${DEPLOYMENT}' is ready"; break ;;
        Failed|Canceled) die "Deployment '${DEPLOYMENT}' ended in state ${state}." ;;
      esac
      sleep 10
    done
  fi
fi

# ---------- .env ----------

if [[ -n "$ENV_VAR" ]]; then
  if [[ "$DRY_RUN" == "true" ]]; then
    printf '   [dry-run] set %s="%s" in .env\n' "$ENV_VAR" "$DEPLOYMENT"
  else
    update_env "$ENV_VAR" "$DEPLOYMENT"
    ok "Saved ${ENV_VAR}=\"${DEPLOYMENT}\" to .env"
  fi
else
  echo "Add it to .env for the capsule that uses it:  <NAME>=\"${DEPLOYMENT}\""
  echo "(or re-run with --env-var <NAME>; capsule READMEs list the variable names)"
fi
