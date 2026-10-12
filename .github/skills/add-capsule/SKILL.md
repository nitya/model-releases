---
kind: skill
name: add-capsule
description: Scaffold a full release capsule — folder, spec-driven README, notebook skeleton, deps, announcement row.
inputs:
  - name: publisher
    type: string
    description: Publisher slug (kebab-case) matching a folder under models/.
    required: true
  - name: model
    type: string
    description: Model slug (kebab-case).
    required: true
  - name: release_date
    type: date
    description: Public release date (YYYY-MM-DD); also the capsule folder name.
    required: true
  - name: capabilities
    type: array
    description: Capability tags from the taxonomy in the repo README.
    required: true
  - name: model_card
    type: url
    description: Official model card URL — prefer learn.microsoft.com (no locale segment) when available.
    required: true
  - name: announcement
    type: url
    description: Official release-announcement URL.
    required: false
  - name: pricing
    type: string
    description: Free-form pricing summary or structured object.
    required: false
  - name: dependencies
    type: array
    description: Extra Python packages appended to requirements-dev.txt (Capsule dependencies section).
    required: false
  - name: domains
    type: array
    description: Domains for the interesting use cases (e.g. travel, healthcare).
    required: false
  - name: summary
    type: string
    description: A 15-160 character phrase describing what the release lets us do. Do not repeat the model name or "Microsoft Foundry"; generated views display the model beside it. No trailing period.
    required: true
  - name: references
    type: array
    description: Author-supplied best-practice references (model card, docs, sample repos, blog posts). The agent MUST prompt the creator for these before scaffolding. Written as markdown bullets in the `## References` section of the capsule README and the notebook's final References cell - NOT as frontmatter, so crawlers and agents follow them as real links.
    required: true
  - name: concepts
    type: array
    description: Ordered list of teaching concepts for this release. Each concept becomes its own notebook (1–3 concepts per notebook max). Provide {slug, title, concepts_covered[]} so the skill can name and scaffold each notebook file.
    required: true
produces:
  - models/<publisher>/<model>/README.md
  - models/<publisher>/<model>/*.ipynb
  - ANNOUNCEMENTS.md
  - CAPSULES.md
  - README.md
  - catalog.json
  - llms.txt
  - models/<publisher>/README.md
  - requirements-dev.txt
validates_against:
  - .github/specs/schemas/capsule.schema.json
depends_on:
  - add-publisher
  - add-model
  - refresh-recent-activity
---

# add-capsule

Produces a complete release capsule:

1. Creates `models/<publisher>/<model>/` with a README whose
   frontmatter matches [`capsule.schema.json`](../../specs/schemas/capsule.schema.json)
   — including a **Before You Begin** section with pricing, release /
   expiry dates, model-card link, and a link to
   [`models/quickstart/`](../../../models/quickstart/).
2. Scaffolds one or more notebooks at the capsule root (`<model>.ipynb` for
   one, `01-<slug>.ipynb`, `02-<slug>.ipynb`, … for several), following the
   notebook rules in [`plan.md` §15](../../plan.md):
   - Each notebook covers 1–3 concepts and is independently runnable, so it
     repeats Before You Begin + env precheck at the top. The author declares
     the split up front via the `concepts` prompt.
   - `## 1. Before You Begin` (markdown) — pricing, dates, model card,
     link to `models/quickstart/`.
   - `## 2. Verify your environment` (code) — env precheck against the
     vars listed in `models/quickstart/README.md` frontmatter
     (`required_env`).
   - The body follows the build-and-debug loop in §15, with numbered
     verb-phrase headings.
   - It ends with `Your Turn to Explore`, `Summary`, and `References`.
     References are the author-supplied links as markdown bullets
     (`- [title](url) — note`), never frontmatter. If none were supplied,
     print a TODO reminder rather than omitting the section.
3. Appends any capsule-specific `dependencies` under the
   `# Capsule dependencies` section of `requirements-dev.txt`.
4. Prepends (or updates in place) a row in `ANNOUNCEMENTS.md`, in the
   table under the `## <Month> <Year>` heading for its release date —
   creating that heading and a table header when the month is new.
   Column shape: `Date | Publisher | Model | Capabilities` — exactly
   four cells. The Date cell is a markdown link to the announcement URL
   (there is no separate Announcement column). The Model cell is a
   markdown link to the model card when known — no separate Model card
   column either. The Publisher cell links to that publisher's
   filtered view in the Foundry catalog. Pricing is not a column:
   rates go stale silently, so price lives on the model card the
   capsule links to.
   If an announcement-only row already exists for the same Date +
   Model, the skill updates it in place — adding any newly known
   fields — instead of duplicating.
   For a dated-release family such as model router, the capsule slug
   (`aug-2026`) is not a readable name. Write the family name in the
   Model cell ("Model router", linked to the model card) and a short
   plain-language description in the Capabilities cell. The row is
   still matched to its capsule by Date + the capsule's `model_card` URL,
   and the README **Recently added** list copies both cells as written.
5. Adds a members-table row to `models/<publisher>/README.md`.
6. Regenerates `CAPSULES.md`, `catalog.json`, `llms.txt`, and the
   repo README's notebook badges (a count per publisher, highest first)
   by running `python scripts/generate-catalog.py`. The counts come from
   each capsule's `notebooks:` frontmatter. These are generated -
   never hand-edit them. The capsule's row appears under
   its publisher's `## <Provider>` heading automatically; the generator
   creates that heading when the publisher has no capsules yet.
7. Invokes [`refresh-recent-activity`](../refresh-recent-activity/) so the
   repo README's **Recently added** list (Model · Release date ·
   Capabilities) stays current.
