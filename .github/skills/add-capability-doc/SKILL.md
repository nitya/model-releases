---
kind: skill
name: add-capability-doc
description: Scaffold a new capability primer under docs/primers/ and add the capability tag to the capsule schema; the taxonomy table in docs/README.md regenerates from the primer.
inputs:
  - name: capability
    type: string
    description: Canonical capability name (added to the taxonomy).
    required: true
  - name: slug
    type: string
    description: Kebab-case slug used as the filename and anchor.
    required: true
  - name: one_line
    type: string
    description: Short plain-language definition used in the taxonomy table.
    required: true
  - name: learn_more
    type: array
    description: Up to 3 grounding resources (Learn URLs preferred, with no locale segment).
    required: true
produces:
  - docs/primers/<slug>.md
  - .github/specs/schemas/capsule.schema.json
  - docs/README.md
validates_against:
  - .github/specs/schemas/primer.schema.json
depends_on: []
---

# add-capability-doc

Creates a new primer file with frontmatter validated by
[`primer.schema.json`](../../specs/schemas/primer.schema.json). The capability
taxonomy table in `docs/README.md` is generated from primer frontmatter, so run
`python scripts/generate-catalog.py` afterwards instead of editing the table.

Also updates the [`capsule.schema.json`](../../specs/schemas/capsule.schema.json)
`capabilities` enum so future capsules can tag themselves with the new
capability. (Author confirms this schema change explicitly.)

Write the primer to the voice rules in [`plan.md` §15](../../plan.md).

A primer that explains an idea rather than a capability (for example, model
architecture or model cards) sets `topic: concept` and a `title` in its
frontmatter instead of `capability` and `label`. It skips the capsule schema
enum and the taxonomy table, and it is listed under "How models work" in
`docs/README.md` after the generator runs.
