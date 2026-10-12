---
kind: skill
name: add-publisher
description: Register a new model publisher — creates models/<slug>/ with a spec-driven README stub.
inputs:
  - name: slug
    type: string
    description: Kebab-case folder slug (e.g. anthropic).
    required: true
  - name: name
    type: string
    description: Human-readable publisher name (e.g. Anthropic).
    required: true
  - name: one_line
    type: string
    description: Short pitch for the publisher, carried into catalog.json.
    required: true
  - name: provider
    type: string
    description: Underlying provider or vendor.
    required: false
  - name: related_primers
    type: array
    description: Capability primer slugs most relevant to this publisher.
    required: false
produces:
  - models/<slug>/README.md
  - docs/README.md
  - README.md
validates_against:
  - .github/specs/schemas/publisher.schema.json
depends_on: []
---

# add-publisher

Creates a new publisher folder with a README whose frontmatter conforms to
[`publisher.schema.json`](../../specs/schemas/publisher.schema.json). Then:

1. Add the publisher's row to the **Publishers** table in
   [`docs/README.md`](../../../docs/README.md). That table is hand-maintained,
   and its catalog `?publisher=` value is the catalog's name, not our slug.
2. Run `python scripts/generate-catalog.py`. The publisher appears in the repo
   README as a `0` badge. Optionally add a color for its slug to
   `COLLECTION_BADGE_COLORS` in `scripts/generate-catalog.py` (default: gray).

Fails (non-destructively) if `models/<slug>/` already exists.
