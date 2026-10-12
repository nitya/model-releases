---
kind: script
script: scripts/2-setup-env.sh
purpose: Bootstrap the repo-root .env from scripts/sample.env and populate it from a Foundry project via Azure CLI.
prereqs:
  - "A Foundry project (run ./scripts/1-create-rg.sh first)"
  - Azure CLI installed and `az login` completed for any mode beyond copy-only
usage:
  - "./scripts/2-setup-env.sh                                 # copy template only"
  - "./scripts/2-setup-env.sh --use <rg> <project> [--force]  # populate from a project"
  - "./scripts/2-setup-env.sh <rg> <project> [--force]        # same as --use"
learn_ref: https://learn.microsoft.com/cli/azure/get-started-with-azure-cli
idempotent: true
---

# 2-setup-env.sh

Copies [`scripts/sample.env`](./sample.env) to the repo root as `.env`
(if it doesn't already exist), then, when given a project, fills in the
connection details. [`1-create-rg.sh`](./1-create-rg.sh) offers to run it for
you at the end, so most people never call it directly.

| Mode | Command | What it does |
|---|---|---|
| Copy only | `./scripts/2-setup-env.sh` | Copies the template; edit `.env` by hand. |
| Use a project | `./scripts/2-setup-env.sh --use <rg> <project>` | Reads the project's Foundry resource and writes the subscription, tenant, resource group, project, endpoint, API key, and region to `.env`. |

Creating the project moved to [`1-create-rg.sh`](./1-create-rg.sh).

Re-running with the same arguments is safe, and `.env` is never overwritten
unless `--force` is appended. After this, deploy the models a capsule needs with
[`3-deploy-model.sh`](./3-deploy-model.sh).

Grounded in the
[Foundry "Create a project" docs](https://learn.microsoft.com/azure/foundry/how-to/create-projects).

See [`scripts/2-setup-env.sh`](./2-setup-env.sh) for the implementation.
