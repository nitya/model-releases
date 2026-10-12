---
kind: script
script: scripts/3-deploy-model.sh
purpose: Deploy a model to the project's Foundry resource and optionally save the deployment name to .env.
prereqs:
  - "./scripts/1-create-rg.sh has run (or pass --resource-group), with the Azure CLI signed in"
  - "Permission to create deployments: Foundry Account Owner, Cognitive Services Contributor, or Owner on the resource group"
usage:
  - "./scripts/3-deploy-model.sh --list mai                    # find a model"
  - "./scripts/3-deploy-model.sh <deployment-name> <model-name>   # deploy it"
  - "./scripts/3-deploy-model.sh image-flash MAI-Image-2.5-Flash --env-var AZURE_MAI_IMAGE_25_FLASH_DEPLOYMENT"
  - "./scripts/3-deploy-model.sh <deployment-name> <model-name> --dry-run   # show the command only"
learn_ref: https://learn.microsoft.com/azure/foundry/foundry-models/how-to/create-model-deployments
idempotent: true
---

# 3-deploy-model.sh

Deploys one model at a time. Each capsule's **Before You Begin** section lists
the deployments it expects and the `.env` variable for each.

## How it works

1. Finds your Foundry resource from `.env` (set by [`2-setup-env.sh`](./2-setup-env.sh))
   or from `--resource-group` and `--account`.
2. Looks the model up in the catalog and fills in its format, version, deployment
   type, and default capacity. Override any of them with `--format`, `--version`,
   `--sku`, or `--capacity`.
3. Creates the deployment, waits until it is ready, and, with `--env-var`, saves
   the deployment name to `.env`.

Name the deployment for the job it does (`router-nano`, `policy-mini`), not for
the model, so notebooks keep working when we swap models later.

## Notes

- **Finding models.** `--list` shows what the resource can deploy. Add a search
  term to narrow it: `--list gpt`.
- **Safe to re-run.** If the deployment already exists, nothing changes.
- **Permissions.** Foundry User can read but not create deployments. A permissions
  error names the roles to ask for.
- **Quota.** If a deployment fails for quota, lower `--capacity`, try another
  `--sku`, or request quota in the portal.

Grounded in
[Deploy models using Azure CLI and Bicep](https://learn.microsoft.com/azure/foundry/foundry-models/how-to/create-model-deployments).

See [`scripts/3-deploy-model.sh`](./3-deploy-model.sh) for the implementation.
