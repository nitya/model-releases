#!/usr/bin/env bash
# 1-create-rg.sh
# Purpose:    Create everything a Microsoft Foundry project needs, in one run:
#             sign-in, default subscription, resource group, Foundry resource,
#             default project, Application Insights + Log Analytics, and the
#             role assignments that make tracing and model use work.
# Prereqs:    Azure CLI. You need Owner (or Contributor plus User Access
#             Administrator) on the resource group so role assignments succeed.
# Learn ref:  https://learn.microsoft.com/azure/foundry/how-to/create-projects
#             https://learn.microsoft.com/azure/foundry/concepts/rbac-foundry
#             https://learn.microsoft.com/azure/foundry/observability/how-to/trace-agent-setup
# Usage:      ./scripts/1-create-rg.sh [options]    (run with --help for all options)

set -euo pipefail

# shellcheck source=_common.sh
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

# Built-in role IDs. Referencing the ID keeps this working across the Azure AI
# to Foundry role rename, which changed names but not IDs.
FOUNDRY_USER_ROLE="53ca6127-db72-4b80-b1b0-d745d6d5456d"        # Foundry User
LOG_ANALYTICS_READER_ROLE="73c42c96-874c-492b-b04d-ab87d138a893" # Log Analytics Reader
READER_ROLE="acdd72a7-3385-48ef-bd42-f606fba81ae7"               # Reader
USAGES_READER_ROLE="bba48692-92b0-4667-a9ad-c31c7b334ac2"        # Cognitive Services Usages Reader

DEFAULT_LOCATION="eastus2"
DEFAULT_PROJECT="foundry-project"

usage() {
  cat <<'EOF'
Create a Microsoft Foundry project, monitoring, and access in one run.

Usage: ./scripts/1-create-rg.sh [options]

You are asked for a resource group name and a location. Everything else has a
default, and every option below skips its question.

Options:
  --subscription <id|name>   Subscription to use (default: choose from a list)
  --resource-group <name>    Resource group to create or reuse
  --location <region>        Azure region, for example eastus2
  --name <name>              Foundry resource name, also its globally unique
                             domain (default: derived from the resource group)
  --project <name>           Project name (default: foundry-project)
  --skip-monitoring          Skip Application Insights, Log Analytics, diagnostics
  --no-env                   Don't offer to write .env at the end
  --device-code              Sign in with a device code (default in Codespaces)
  -y, --yes                  Accept defaults and don't ask for confirmation
  --dry-run                  Show what would run without changing anything
  -h, --help                 Show this help

Safe to re-run: existing resources and role assignments are kept.
EOF
}

# ---------- arguments ----------

SUBSCRIPTION="" RG="" LOCATION="" ACCOUNT="" PROJECT=""
SKIP_MONITORING=false SKIP_ENV=false DEVICE_CODE=false
# ASSUME_YES and DRY_RUN are read by _common.sh.
# shellcheck disable=SC2034
ASSUME_YES="${ASSUME_YES:-false}"

need_value() { [[ $# -ge 2 && -n "$2" ]] || die "$1 needs a value."; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --subscription)    need_value "$@"; SUBSCRIPTION="$2"; shift 2 ;;
    --resource-group)  need_value "$@"; RG="$2"; shift 2 ;;
    --location)        need_value "$@"; LOCATION="$2"; shift 2 ;;
    --name)            need_value "$@"; ACCOUNT="$2"; shift 2 ;;
    --project)         need_value "$@"; PROJECT="$2"; shift 2 ;;
    --skip-monitoring) SKIP_MONITORING=true; shift ;;
    --no-env)          SKIP_ENV=true; shift ;;
    --device-code)     DEVICE_CODE=true; shift ;;
    -y|--yes)          ASSUME_YES=true; shift ;;
    --dry-run)         DRY_RUN=true; shift ;;
    -h|--help)         usage; exit 0 ;;
    *)                 die "Unknown option: $1 (see --help)" ;;
  esac
done

MANUAL_STEPS=()
add_manual() { MANUAL_STEPS+=("$1"); }

# ---------- step 1: sign in ----------

ensure_login() {
  need_az
  if az_logged_in; then
    ok "Signed in as $(az account show --query user.name -o tsv)"
    return 0
  fi
  [[ "$DRY_RUN" != "true" ]] || die "--dry-run reads your subscriptions, so sign in first: az login"
  info "Signing in to Azure..."
  local args=()
  if [[ "$DEVICE_CODE" == "true" || -n "${CODESPACES:-}" ]]; then
    args+=(--use-device-code)
  fi
  # Turn off the CLI's own subscription picker; the next step handles it.
  AZURE_CORE_LOGIN_EXPERIENCE_V2=off az login "${args[@]+"${args[@]}"}" --output none
  az_logged_in || die "Sign-in did not complete."
  ok "Signed in as $(az account show --query user.name -o tsv)"
}

# ---------- step 2: default subscription ----------

choose_subscription() {
  local chosen="$SUBSCRIPTION"
  if [[ -z "$chosen" ]]; then
    local lines count=0 default_idx=1 n=0 name id is_default reply
    local ids=()
    lines="$(az account list --query "[?state=='Enabled'].[name,id,isDefault]" -o tsv)"
    [[ -n "$lines" ]] || die "No enabled subscriptions found for this account."
    while IFS=$'\t' read -r name id is_default; do
      n=$((n + 1))
      ids+=("$id")
      if [[ "$is_default" == "True" ]]; then
        default_idx=$n
      fi
      count=$n
    done <<< "$lines"

    if [[ "$count" -eq 1 ]] || ! is_interactive; then
      chosen="${ids[$((default_idx - 1))]}"
    else
      echo "Choose a subscription:"
      n=0
      while IFS=$'\t' read -r name id is_default; do
        n=$((n + 1))
        printf '  %d) %s (%s)%s\n' "$n" "$name" "$id" "$([[ "$is_default" == "True" ]] && echo '  [current default]')"
      done <<< "$lines"
      read -r -p "Subscription number [${default_idx}]: " reply || true
      reply="${reply:-$default_idx}"
      [[ "$reply" =~ ^[0-9]+$ && "$reply" -ge 1 && "$reply" -le "$count" ]] || die "Pick a number from 1 to ${count}."
      chosen="${ids[$((reply - 1))]}"
    fi
  fi

  SUB_ID="$(az account show --subscription "$chosen" --query id -o tsv)"
  SUB_NAME="$(az account show --subscription "$chosen" --query name -o tsv)"
  run az account set --subscription "$SUB_ID"
  ok "Default subscription: ${SUB_NAME} (${SUB_ID})"
}

# ---------- step 3: names and plan ----------

gather_inputs() {
  prompt RG "Resource group name" "rg-foundry"
  prompt LOCATION "Location (Azure region)" "$DEFAULT_LOCATION"

  LOCATION="$(printf '%s' "$LOCATION" | tr '[:upper:]' '[:lower:]' | tr -d ' ')"
  local rg_re='^[A-Za-z0-9._()-]{1,90}$'
  [[ "$RG" =~ $rg_re && "$RG" != *. ]] \
    || die "Resource group names use letters, numbers, . _ - ( ) and can't end with a period."
  [[ -n "$(az account list-locations --query "[?name=='${LOCATION}'].name" -o tsv)" ]] \
    || die "Unknown location '${LOCATION}'. See the list: az account list-locations -o table"

  if [[ -z "$ACCOUNT" ]]; then
    local slug suffix
    slug="$(slugify "$RG")"
    suffix="$(stable_suffix "${SUB_ID}-${RG}")"
    ACCOUNT="foundry-${slug:0:40}-${suffix}"
    ACCOUNT="${ACCOUNT//--/-}"
  fi
  PROJECT="${PROJECT:-$DEFAULT_PROJECT}"

  local account_re='^[a-z0-9]([a-z0-9-]{0,62}[a-z0-9])?$' project_re='^[A-Za-z0-9][A-Za-z0-9_-]{1,63}$'
  [[ "$ACCOUNT" =~ $account_re && ${#ACCOUNT} -ge 2 ]] \
    || die "The Foundry resource name must be 2-64 lowercase letters, numbers, or hyphens (got '${ACCOUNT}')."
  [[ "$PROJECT" =~ $project_re ]] \
    || die "The project name must be 2-64 letters, numbers, hyphens, or underscores (got '${PROJECT}')."

  WS_NAME="log-${ACCOUNT:0:56}"
  AI_NAME="appi-${ACCOUNT:0:55}"
}

show_plan() {
  echo
  echo "This will set up:"
  printf '  %-22s %s\n' "Subscription" "${SUB_NAME}"
  printf '  %-22s %s (%s)\n' "Resource group" "$RG" "$LOCATION"
  printf '  %-22s %s\n' "Foundry resource" "$ACCOUNT"
  printf '  %-22s %s\n' "Foundry project" "$PROJECT"
  if [[ "$SKIP_MONITORING" != "true" ]]; then
    printf '  %-22s %s, %s\n' "Monitoring" "$AI_NAME" "$WS_NAME"
  fi
  printf '  %-22s %s\n' "Access" "Foundry User for you and the project identity$([[ "$SKIP_MONITORING" == "true" ]] || echo ', Reader roles for tracing')"
  echo
  echo "Foundry resources have no standing charge; Application Insights and Log Analytics bill by data ingested."
  echo
  [[ "$DRY_RUN" != "true" ]] || return 0
  confirm "Create these now?" Y || die "Cancelled. Nothing was created."
}

# ---------- helpers ----------

register_providers() {
  local ns state
  for ns in Microsoft.CognitiveServices Microsoft.Insights Microsoft.OperationalInsights; do
    state="$(az provider show --namespace "$ns" --query registrationState -o tsv 2>/dev/null || echo NotRegistered)"
    if [[ "$state" == "Registered" ]]; then
      ok "${ns} is registered"
    else
      info "Registering ${ns}..."
      run az provider register --namespace "$ns" --wait
    fi
  done
}

# wait_for_succeeded "<label>" <az show command...> — poll provisioningState.
wait_for_succeeded() {
  local label="$1" state
  shift
  [[ "$DRY_RUN" != "true" ]] || return 0
  for _ in $(seq 1 60); do
    state="$("$@" --query properties.provisioningState -o tsv 2>/dev/null || true)"
    case "$state" in
      Succeeded) ok "${label} is ready"; return 0 ;;
      Failed|Canceled) die "${label} ended in state ${state}. Check the Azure portal for details." ;;
    esac
    sleep 10
  done
  die "Timed out waiting for ${label}."
}

# assign_role <role-id> <label> <principal-id> <principal-type> <scope> <where>
assign_role() {
  local role="$1" label="$2" principal="$3" ptype="$4" scope="$5" where="$6" existing err
  if [[ -z "$principal" ]]; then
    add_manual "az role assignment create --role ${role} --assignee <object-id> --scope ${scope}   # ${label} on ${where}"
    return 0
  fi
  if [[ "$DRY_RUN" == "true" ]]; then
    printf '   [dry-run] assign %s on %s\n' "$label" "$where"
    return 0
  fi
  existing="$(az role assignment list --assignee "$principal" --role "$role" --scope "$scope" --query '[0].id' -o tsv 2>/dev/null || true)"
  if [[ -n "$existing" ]]; then
    ok "${label} already assigned on ${where}"
    return 0
  fi
  err="$(mktemp)"
  if az role assignment create --role "$role" --assignee-object-id "$principal" \
       --assignee-principal-type "$ptype" --scope "$scope" --output none 2>"$err"; then
    ok "Assigned ${label} on ${where}"
  else
    warn "Couldn't assign ${label} on ${where}: $(head -n 1 "$err")"
    add_manual "az role assignment create --role ${role} --assignee-object-id ${principal} --assignee-principal-type ${ptype} --scope ${scope}   # ${label} on ${where}"
  fi
  rm -f "$err"
}

# ---------- step 4: resources ----------

create_resource_group() {
  if [[ "$(az group exists --name "$RG")" == "true" ]]; then
    ok "Resource group '${RG}' already exists"
  else
    info "Creating resource group '${RG}' in ${LOCATION}..."
    run az group create --name "$RG" --location "$LOCATION" --output none
    done_msg "Resource group created"
  fi
}

create_foundry_resource() {
  if az cognitiveservices account show --name "$ACCOUNT" --resource-group "$RG" >/dev/null 2>&1; then
    ok "Foundry resource '${ACCOUNT}' already exists"
    local pm
    pm="$(az cognitiveservices account show --name "$ACCOUNT" --resource-group "$RG" --query properties.allowProjectManagement -o tsv 2>/dev/null || true)"
    [[ "$pm" == "true" ]] || die "'${ACCOUNT}' was created without project management, which can't be changed. Re-run with --name <new-name>."
    return 0
  fi
  info "Creating Foundry resource '${ACCOUNT}' (a few minutes)..."
  local out
  # --custom-domain, --assign-identity, and --allow-project-management are all
  # required before a project can be created on the resource.
  if ! out="$(run az cognitiveservices account create \
        --name "$ACCOUNT" --resource-group "$RG" --location "$LOCATION" \
        --kind AIServices --sku S0 \
        --custom-domain "$ACCOUNT" --assign-identity --allow-project-management true \
        --yes --output none 2>&1)"; then
    case "$out" in
      *CustomDomainInUse*) die "The name '${ACCOUNT}' is taken. Re-run with --name <something-unique>." ;;
      *FlagMustBeSetForRestore*|*soft-deleted*) die "A deleted resource with this name still exists. Purge it (az cognitiveservices account purge) or use --name <new-name>." ;;
      *) printf '%s\n' "$out" >&2; die "Creating the Foundry resource failed." ;;
    esac
  fi
  [[ -z "$out" ]] || printf '%s\n' "$out"
  wait_for_succeeded "Foundry resource" az cognitiveservices account show --name "$ACCOUNT" --resource-group "$RG"
}

create_project() {
  if az cognitiveservices account project show --name "$ACCOUNT" --resource-group "$RG" --project-name "$PROJECT" >/dev/null 2>&1; then
    ok "Project '${PROJECT}' already exists"
    return 0
  fi
  info "Creating project '${PROJECT}'..."
  run az cognitiveservices account project create \
    --name "$ACCOUNT" --resource-group "$RG" --project-name "$PROJECT" \
    --location "$LOCATION" --assign-identity --output none
  wait_for_succeeded "Project" az cognitiveservices account project show \
    --name "$ACCOUNT" --resource-group "$RG" --project-name "$PROJECT"
}

# ---------- step 5: monitoring ----------

setup_monitoring() {
  # Installing the extension up front avoids the CLI's interactive install prompt.
  if [[ "$(az extension list --query "[?name=='application-insights'] | length(@)" -o tsv 2>/dev/null || echo 0)" == "0" ]]; then
    info "Installing the Azure CLI application-insights extension..."
    run az extension add --name application-insights --yes --only-show-errors
  fi

  if az monitor log-analytics workspace show --resource-group "$RG" --workspace-name "$WS_NAME" >/dev/null 2>&1; then
    ok "Log Analytics workspace '${WS_NAME}' already exists"
  else
    info "Creating Log Analytics workspace '${WS_NAME}'..."
    run az monitor log-analytics workspace create --resource-group "$RG" --workspace-name "$WS_NAME" --location "$LOCATION" --output none
  fi
  WS_ID="$(az monitor log-analytics workspace show --resource-group "$RG" --workspace-name "$WS_NAME" --query id -o tsv 2>/dev/null || echo "<workspace-id>")"

  if az monitor app-insights component show --app "$AI_NAME" --resource-group "$RG" >/dev/null 2>&1; then
    ok "Application Insights '${AI_NAME}' already exists"
  else
    info "Creating Application Insights '${AI_NAME}'..."
    run az monitor app-insights component create --app "$AI_NAME" --resource-group "$RG" \
      --location "$LOCATION" --kind web --application-type web --workspace "$WS_ID" --output none
  fi
  AI_ID="$(az monitor app-insights component show --app "$AI_NAME" --resource-group "$RG" --query id -o tsv 2>/dev/null || echo "<app-insights-id>")"

  # Send the Foundry resource's own logs and metrics to the workspace.
  if az monitor diagnostic-settings show --name foundry-to-log-analytics --resource "$ACCOUNT_ID" >/dev/null 2>&1; then
    ok "Diagnostic settings already send Foundry logs to Log Analytics"
  else
    info "Sending Foundry logs and metrics to Log Analytics..."
    if ! run az monitor diagnostic-settings create --name foundry-to-log-analytics \
         --resource "$ACCOUNT_ID" --workspace "$WS_ID" \
         --logs '[{"categoryGroup":"allLogs","enabled":true}]' \
         --metrics '[{"category":"AllMetrics","enabled":true}]' --output none 2>/dev/null; then
      warn "Couldn't enable diagnostic settings."
      add_manual "Azure portal → ${ACCOUNT} → Diagnostic settings → send all logs to ${WS_NAME}"
    fi
  fi
  connect_app_insights
}

# The CLI reads a flat file (type, target, credentials, metadata), not the raw
# ARM body. If it still fails, fall back to the portal steps and show why.
connect_app_insights() {
  local tmp conn err reason
  if [[ "$DRY_RUN" == "true" ]]; then
    printf '   [dry-run] connect %s to project %s\n' "$AI_NAME" "$PROJECT"
    return 0
  fi
  if az cognitiveservices account project connection show --name "$ACCOUNT" --resource-group "$RG" \
       --project-name "$PROJECT" --connection-name appinsights >/dev/null 2>&1; then
    ok "Application Insights is already connected to the project"
    return 0
  fi
  conn="$(az monitor app-insights component show --app "$AI_NAME" --resource-group "$RG" --query connectionString -o tsv 2>/dev/null || true)"
  tmp="$(mktemp)"
  err="$(mktemp)"
  chmod 600 "$tmp"
  cat > "$tmp" <<JSON
{
  "type": "AppInsights",
  "target": "${AI_ID}",
  "credentials": { "type": "ApiKey", "key": "${conn}" },
  "metadata": { "ApiType": "Azure", "ResourceId": "${AI_ID}" }
}
JSON
  if [[ -n "$conn" ]] && az cognitiveservices account project connection create \
       --name "$ACCOUNT" --resource-group "$RG" --project-name "$PROJECT" \
       --connection-name appinsights --file "$tmp" --output none 2>"$err"; then
    ok "Connected Application Insights to the project for tracing"
  else
    # Hide the instrumentation key if the CLI echoes the connection string back.
    reason="$(sed -E 's/(InstrumentationKey=)[0-9a-fA-F-]+/\1<hidden>/g' "$err" | head -n 2 | tr '\n' ' ')"
    warn "Couldn't connect Application Insights from the CLI${reason:+: ${reason}}"
    add_manual "Foundry portal → ${PROJECT} → Agents → Traces → Connect → choose ${AI_NAME}"
  fi
  rm -f "$tmp" "$err"
}

# ---------- step 6: access ----------

find_principal() {
  local type user
  type="$(az account show --query user.type -o tsv)"
  user="$(az account show --query user.name -o tsv)"
  PRINCIPAL_ID="" PRINCIPAL_TYPE="User"
  if [[ "$type" == "user" ]]; then
    PRINCIPAL_ID="$(az ad signed-in-user show --query id -o tsv 2>/dev/null || true)"
  else
    PRINCIPAL_TYPE="ServicePrincipal"
    PRINCIPAL_ID="$(az ad sp show --id "$user" --query id -o tsv 2>/dev/null || true)"
  fi
  if [[ -z "$PRINCIPAL_ID" ]]; then
    warn "Couldn't look up your object ID, so role assignments are listed at the end to run yourself."
  fi
}

assign_access() {
  find_principal
  local project_principal=""
  project_principal="$(az cognitiveservices account project show --name "$ACCOUNT" --resource-group "$RG" \
    --project-name "$PROJECT" --query identity.principalId -o tsv 2>/dev/null || true)"

  assign_role "$FOUNDRY_USER_ROLE" "Foundry User (you)" "$PRINCIPAL_ID" "$PRINCIPAL_TYPE" "$ACCOUNT_ID" "the Foundry resource"
  if [[ -n "$project_principal" || "$DRY_RUN" == "true" ]]; then
    assign_role "$FOUNDRY_USER_ROLE" "Foundry User (project identity)" "${project_principal:-<project-identity>}" ServicePrincipal "$ACCOUNT_ID" "the Foundry resource"
  else
    warn "The project has no managed identity to assign Foundry User to."
    add_manual "az role assignment create --role ${FOUNDRY_USER_ROLE} --assignee-object-id <project-identity> --assignee-principal-type ServicePrincipal --scope ${ACCOUNT_ID}   # Foundry User (project identity)"
  fi

  if [[ "$SKIP_MONITORING" != "true" ]]; then
    assign_role "$LOG_ANALYTICS_READER_ROLE" "Log Analytics Reader (you)" "$PRINCIPAL_ID" "$PRINCIPAL_TYPE" "$AI_ID" "Application Insights"
    assign_role "$READER_ROLE" "Reader (you)" "$PRINCIPAL_ID" "$PRINCIPAL_TYPE" "$AI_ID" "Application Insights"
  fi
  # Lets you see quota and run deployment checks. Needs subscription-level rights.
  assign_role "$USAGES_READER_ROLE" "Cognitive Services Usages Reader (you)" "$PRINCIPAL_ID" "$PRINCIPAL_TYPE" "/subscriptions/${SUB_ID}" "the subscription"
}

# ---------- main ----------

echo "Foundry setup  (--help for options)"
[[ "$DRY_RUN" != "true" ]] || echo "Dry run: nothing will be created."
echo
echo "[1/6] Sign in"
ensure_login
echo
echo "[2/6] Default subscription"
choose_subscription
echo
echo "[3/6] Resource group and location"
gather_inputs
show_plan

echo
echo "[4/6] Resources"
register_providers
create_resource_group
create_foundry_resource
create_project
ACCOUNT_ID="$(az cognitiveservices account show --name "$ACCOUNT" --resource-group "$RG" --query id -o tsv 2>/dev/null || echo "/subscriptions/${SUB_ID}/resourceGroups/${RG}/providers/Microsoft.CognitiveServices/accounts/${ACCOUNT}")"

AI_ID="<app-insights-id>"
echo
if [[ "$SKIP_MONITORING" == "true" ]]; then
  echo "[5/6] Monitoring (skipped)"
else
  echo "[5/6] Monitoring"
  setup_monitoring
fi

echo
echo "[6/6] Access"
assign_access

echo
if [[ "$DRY_RUN" == "true" ]]; then
  ok "Dry run complete. Nothing was created."
else
  ok "Foundry project '${PROJECT}' is ready in '${RG}'."
fi
if [[ ${#MANUAL_STEPS[@]} -gt 0 ]]; then
  echo
  warn "A few steps need someone with more access (an Owner or User Access Administrator):"
  for step in "${MANUAL_STEPS[@]}"; do
    printf '   • %s\n' "$step" >&2
  done
fi

if [[ "$DRY_RUN" == "true" || "$SKIP_ENV" == "true" ]]; then
  echo
  echo "Next: ./scripts/2-setup-env.sh --use ${RG} ${PROJECT}"
  exit 0
fi

echo
FORCE_ARG=()
if [[ -f "$ENV_FILE" ]] && confirm ".env already exists. Replace it with this project's settings?" N; then
  FORCE_ARG=(--force)
fi
if confirm "Write your .env now?" Y; then
  "${SCRIPTS_DIR}/2-setup-env.sh" --use "$RG" "$PROJECT" "${FORCE_ARG[@]+"${FORCE_ARG[@]}"}"
else
  echo "Next: ./scripts/2-setup-env.sh --use ${RG} ${PROJECT}"
fi
echo "Then deploy a model: ./scripts/3-deploy-model.sh --help"
