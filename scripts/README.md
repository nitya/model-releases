# Scripts

Reusable shell / Python helpers for capsule authors and learners.
Anything that automates setup, provisioning, deployment, `.env`
hygiene, or **spec validation** lives here — one script per file, one
purpose per script.

## Numbered in the order we use them

Steps 1 to 3 set up our Azure environment, and steps 4 to 6 are for contributors.
Unnumbered files are helpers, not scripts we run directly.

## Conventions

- **Runnable from repo root**, e.g. `./scripts/1-create-rg.sh` or `python scripts/4-validate-spec.py`.
- **Idempotent** — safe to re-run (check-before-create, `--force` flag
  for destructive ops). Scripts that change Azure also take `--dry-run`.
- **Grounded in [Microsoft Learn](https://learn.microsoft.com/) docs**
  and the [Azure CLI](https://learn.microsoft.com/cli/azure/)
  where possible; link the underlying doc from the script's header.
- **Spec-driven** — a script that authors or learners invoke as part
  of the workflow ships a sidecar `<name>.spec.md`, whose YAML
  frontmatter is validated against
  [`.github/specs/schemas/script.schema.json`](../.github/specs/schemas/script.schema.json).
  The validators and generators are self-describing and don't carry
  one — their contract is the `--help` output and this table.
- **Called out from wherever they're needed** (typically
  [the quickstart](../models/quickstart/README.md) or a capsule README).

## Available scripts

| Script | Spec | Purpose |
|---|---|---|
| [`1-create-rg.sh`](./1-create-rg.sh) | [`1-create-rg.spec.md`](./1-create-rg.spec.md) | **Start here.** Once: create a Foundry resource group, resource, project, monitoring, and role assignments |
| [`2-setup-env.sh`](./2-setup-env.sh) | [`2-setup-env.spec.md`](./2-setup-env.spec.md) | Once: copy `sample.env` → `.env` and fill in the Foundry connection (script 1 offers to run it) |
| [`3-deploy-model.sh`](./3-deploy-model.sh) | [`3-deploy-model.spec.md`](./3-deploy-model.spec.md) | Each time a capsule needs a model: list and deploy it, and save the name to `.env` |
| [`4-validate-spec.py`](./4-validate-spec.py) | [`4-validate-spec.spec.md`](./4-validate-spec.spec.md) | Before every commit: run every check; `--watch` re-runs on each save |
| [`5-generate-catalog.py`](./5-generate-catalog.py) | [`5-generate-catalog.spec.md`](./5-generate-catalog.spec.md) | After changing frontmatter or notebooks: regenerate `catalog.json`, `llms.txt`, `CAPSULES.md`, and the README blocks |
| [`6-scan-foundry-blog.py`](./6-scan-foundry-blog.py) | _(self-describing)_ | To draft announcement rows (CI runs it too) |
| [`validate-specs.py`](./validate-specs.py) | _(helper)_ | Validate every artifact's YAML frontmatter against its JSON Schema (run by step 4) |
| [`validate-crosslinks.py`](./validate-crosslinks.py) | _(helper)_ | Check ANNOUNCEMENTS ↔ README ↔ capsule ↔ primer wiring (run by step 4) |
| [`_common.sh`](./_common.sh) | _(helper)_ | Shared shell functions for steps 1 to 3 |
| [`sample.env`](./sample.env) | _(template)_ | Reference env vars for every capsule |

## Validating your changes

CI validates once per pull request, not on every push, so this is the
check that catches things first — and the pre-commit hook runs it for
you.

```bash
pip install -r requirements-dev.txt
python scripts/4-validate-spec.py
```

It runs the schema validator, the crosslink validator, and the
generated-file check, and exits non-zero if any of them fails.

While drafting, leave it running in a second terminal so every save
re-checks:

```bash
python scripts/4-validate-spec.py --watch
```

If the generated files are stale, rebuild them rather than editing by
hand:

```bash
python scripts/4-validate-spec.py --fix
```

