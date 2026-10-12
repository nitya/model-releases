---
kind: script
script: scripts/1-create-rg.sh
purpose: Create a Microsoft Foundry resource group, resource, default project, monitoring, and role assignments in one guided run.
prereqs:
  - Azure CLI installed
  - "Owner (or Contributor plus User Access Administrator) on the resource group, so role assignments succeed"
usage:
  - "./scripts/1-create-rg.sh                                  # guided: sign in, pick a subscription, answer two questions"
  - "./scripts/1-create-rg.sh --resource-group rg-foundry --location eastus2 --yes   # no prompts"
  - "./scripts/1-create-rg.sh --dry-run                        # show what would run, change nothing"
  - "./scripts/1-create-rg.sh --skip-monitoring                # skip Application Insights and Log Analytics"
learn_ref: https://learn.microsoft.com/azure/foundry/how-to/create-projects
idempotent: true
---

# 1-create-rg.sh

Run this once to get a working Foundry project. It asks for a **resource group
name** and a **location**, then does the rest.

## What it does

| Step | What happens |
|---|---|
| 1. Sign in | Runs `az login` if needed (device code in Codespaces). |
| 2. Subscription | Lists your enabled subscriptions, lets you choose, and sets it as the default. |
| 3. Inputs | Asks for the resource group name and location, shows a plan, and waits for a yes. |
| 4. Resources | Registers resource providers, then creates the resource group, the Foundry resource, and a default project. |
| 5. Monitoring | Creates a Log Analytics workspace and Application Insights, sends the Foundry resource's logs and metrics to the workspace, and connects Application Insights to the project. |
| 6. Access | Assigns the roles below. |

It finishes by offering to run [`2-setup-env.sh`](./2-setup-env.sh), so one
script takes us from nothing to a populated `.env`.

## Roles it assigns

| Role | Assigned to | Scope | Why |
|---|---|---|---|
| Foundry User | You | Foundry resource | Build and run agents and use models in the project |
| Foundry User | The project's managed identity | Foundry resource | Lets the project reach Foundry features |
| Log Analytics Reader | You | Application Insights | Query traces and telemetry |
| Reader | You | Application Insights | Use the Tracing and Monitoring views |
| Cognitive Services Usages Reader | You | Subscription | See quota and run deployment checks |

Roles are referenced by ID, so the script keeps working across the Azure AI to
Foundry role rename. Foundry User can't create model deployments; if you'll run
[`3-deploy-model.sh`](./3-deploy-model.sh) as someone without Owner or
Contributor, an owner needs to grant Foundry Account Owner.

If you lack permission to assign a role, the script keeps going and prints the
exact `az role assignment create` commands for an owner to run.

## Notes

- **Safe to re-run.** Existing resources, connections, and role assignments are
  kept. Resource names come from the subscription and resource group, so the same
  inputs always produce the same names.
- **`--dry-run`** reads your subscriptions and checks for existing resources, but
  creates and changes nothing.
- **Foundry resource name.** It doubles as the resource's globally unique domain.
  If it's taken, re-run with `--name <something-unique>`.
- **Application Insights connection.** The script connects it from the CLI. If
  that ever fails, it shows the reason and prints the portal steps instead of
  stopping.
- **Cost.** Foundry resources have no standing charge. Application Insights and
  Log Analytics bill by the data they ingest.

Grounded in
[Create a project](https://learn.microsoft.com/azure/foundry/how-to/create-projects),
[role-based access control for Foundry](https://learn.microsoft.com/azure/foundry/concepts/rbac-foundry), and
[set up tracing](https://learn.microsoft.com/azure/foundry/observability/how-to/trace-agent-setup).

See [`scripts/1-create-rg.sh`](./1-create-rg.sh) for the implementation.
