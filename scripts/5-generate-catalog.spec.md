---
kind: script
script: scripts/5-generate-catalog.py
purpose: Generate catalog.json, llms.txt, and every marker-bracketed index table from artifact frontmatter, so the indexes of the repo can never drift from the content.
prereqs:
  - "pyyaml (`pip install -r requirements-dev.txt`)"
usage:
  - "python scripts/5-generate-catalog.py           # write all generated files"
  - "python scripts/5-generate-catalog.py --check   # fail if any is stale"
learn_ref: https://llmstxt.org/
idempotent: true
---

# 5-generate-catalog.py

Builds every index of this repo from one source: artifact frontmatter.
All of these are **generated** — edit the frontmatter, never the output.

| File | Audience | What it holds |
|---|---|---|
| `catalog.json` | Agents, scripts | Every capsule, scenario, publisher, primer, and capability tag with models, capabilities, pricing, and notebook paths |
| `llms.txt` | LLM consumers | A short, link-dense markdown map of the repo, per the [/llms.txt convention](https://llmstxt.org/) |
| `CAPSULES.md` | Humans | A badge row that jumps to each provider section, then capsule lists grouped by provider (date, name, capabilities, numbered notebook links, newest first), plus the multi-model scenario list |
| `README.md` | Humans | The notebook badges: one per publisher with its notebook count, sorted by count then name, zeros included, each linking to the publisher's collection README |
| `docs/README.md` | Humans | The capability taxonomy table |

The three markdown files are only rewritten **between markers**
(`<!-- BEGIN:CAPSULE-LIST -->` and friends). Prose outside the
markers is hand-written and preserved, so the generator never
flattens someone's intro paragraph.

## Why these exist

Retrieval systems chunk per file. An agent that fetches one capsule
README gets that capsule's frontmatter and nothing else — it has no way
to know what else the repo covers without crawling the tree. These two
files answer "what is in this repo?" in a single request.

That is also why capsule metadata stays **in** the capsule README
rather than moving to a central registry: co-locating it keeps each
page self-describing when fetched alone, and this script derives the
central index from those same fields.

## Fields it reads

`summary` is the load-bearing one. It is the meta description for a
capsule, used in `catalog.json`, `llms.txt`, and `CAPSULES.md`. Write it to
stand alone out of context: say what the model does and when to reach for it.
The schema defines the exact constraints.

`last_updated` drives ordering and the **Last updated** column, and
falls back to `release_date` when absent. It lives in frontmatter
rather than being read from git so that a shallow CI checkout produces
byte-identical output.

The display name comes from the README **H1**, not frontmatter, so
search results show `MAI-Image-2.5-Pro` rather than the
`mai-image-2.5-pro` slug.

Capability **labels** come from the `label` field of the matching
primer in `docs/primers/`. A primer may also declare `aliases` so one
primer serves several tags — `multimodal-models.md` covers both
`multimodal` and `vision`. This is the single source of truth for the
taxonomy table, so a tag is usable exactly when a primer declares it.

## When the README changes

The repo README has two marker-bounded blocks, refreshed by different tools:

| Block | Refreshed by | Run it when |
|---|---|---|
| `RECENT-CAPSULES` (notebook badges) | this script | a notebook is added, renamed, or removed (update the capsule's `notebooks:` frontmatter first), or a new publisher or badge color is added |
| `RECENTLY-ADDED` (top 3 announcement row) | the `refresh-recent-activity` skill, or `scripts/6-scan-foundry-blog.py` | a announcement row is added or edited |

The README's "Try a notebook" link is hand-written. After a notebook rename or
removal, search the README for the old path.

## Checking for drift

`--check` is one of the three checks in
[`scripts/4-validate-spec.py`](./4-validate-spec.py), which runs from the pre-commit
hook and from the
[`validate.yml`](../.github/workflows/validate.yml) workflow. If you
change frontmatter and forget to regenerate, it fails with the list of
stale files; `python scripts/4-validate-spec.py --fix` regenerates them.
