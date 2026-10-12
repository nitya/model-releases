---
kind: skill
name: maintain-capsule
description: "Audit, update, or repair an existing capsule and its notebooks while preserving paths, contracts, and generated indexes. Use when content is stale, unclear, broken, or missing the constructionist learning loop."
inputs:
  - name: capsule
    type: string
    description: Path to the existing capsule folder or its README.md.
    required: true
  - name: mode
    type: enum
    description: Audit without edits, update content, or repair a reported failure.
    required: true
    enum: [audit, update, repair]
  - name: goals
    type: array
    description: Optional outcomes, reported problems, or sections to prioritize.
    required: false
  - name: execute_notebooks
    type: boolean
    description: Whether to run notebooks against configured live services after static checks; requires explicit approval because execution can use credentials and incur cost.
    required: false
produces:
  - models/<publisher>/<capsule>/README.md
  - models/<publisher>/<capsule>/*.ipynb
  - catalog.json
  - llms.txt
  - CAPSULES.md
  - README.md
validates_against:
  - .github/specs/schemas/capsule.schema.json
---

# maintain-capsule

Maintains an existing capsule without recreating it. Preserve the capsule path,
notebook paths, frontmatter field names, and generated-file boundaries unless the
creator explicitly approves a coordinated migration.

## 1. Establish the baseline

1. Resolve `capsule` to one capsule README and read its frontmatter, body, and
   declared notebooks. Do not inspect `.do-not-commit/`.
2. Check the working tree before editing. Preserve unrelated changes and report
   overlapping user edits before modifying the same region.
3. Run `python scripts/validate.py --no-color`. Record pre-existing failures and
   do not attribute them to this maintenance pass.

## 2. Audit the capsule

Review the capsule README and every declared notebook for:

- **Contract integrity:** frontmatter matches the capsule schema; folder,
  publisher, model, notebook paths, and generated indexes agree.
- **Discovery:** the H1, opening developer question, summary, section headings,
  capabilities, and links use concrete language that works for human search and
  agent retrieval. Keep machine facts in frontmatter and readable meaning in the
  Markdown body.
- **Content rules:** the main path is clear to a beginner who knows Python,
  with short subsections for professional depth. Voice, constructionist loop,
  visuals, and closing sections follow [`plan.md` §15](../../plan.md). Diagrams
  and plots must explain or reveal behavior, never decorate.
- **Operational correctness:** dependencies, environment variables, setup steps,
  output paths, references, and error guidance match the notebook code.
- **Notebook integrity:** preserve valid JSON and all existing cell metadata,
  including `metadata.id` and `metadata.language`. New cells require
  `metadata.language`; do not mention internal cell IDs in reader-facing text.

In `audit` mode, stop after reporting findings ordered by severity. Include exact
file references, a proposed smallest fix, validation gaps, and any breaking change
that the fix would require.

## 3. Update or repair

In `update` mode, make only the changes needed for the stated goals and audit
findings. In `repair` mode:

1. Reproduce or identify the failure using the cheapest static or local check.
2. State one falsifiable root-cause hypothesis and the evidence that would reject
   it.
3. Make the smallest correction and rerun the same check.
4. Teach the diagnosis in the notebook when it represents a reusable learner
   skill, using before/after evidence rather than a prose-only warning.

Do not add frontmatter fields for prose that belongs in the body. Do not hand-edit
`catalog.json`, `llms.txt`, `CAPSULES.md`, or marker-bounded README tables.

When a notebook is added, renamed, or removed:

1. Update the capsule's `notebooks:` frontmatter to match the files on disk.
2. Run `python scripts/generate-catalog.py`. It refreshes the README badges
   (counts and order), `CAPSULES.md`, `catalog.json`, and `llms.txt`.
3. Search the README for the old notebook path. The "Try a notebook" step
   links one notebook by hand, so a rename or removal can leave it broken.

## 4. Validate and report compatibility

After each substantive edit, run:

```bash
python scripts/generate-catalog.py && python scripts/validate.py --no-color
```

Perform static notebook checks before any live execution. Run notebooks only when
`execute_notebooks` is true and the creator has confirmed the required credentials,
deployment, expected cost, and output policy.

Finish with:

- files and learner behavior changed;
- checks run and their results;
- live checks not run;
- **Breaking changes:** `None`, or an explicit list of changed paths, schema
  requirements, environment variables, dependencies, or notebook behavior.