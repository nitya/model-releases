# Model Releases — Plan v1

> This is the living plan for the `model-releases` repo. On approval it will be
> committed to `.github/plan.md` and updated as the repo evolves.

Base branch for this iteration: **`model-releases/2026-08-03`**.

---

## 1. Purpose

Turn every new Foundry-catalog model release into a **content capsule** —
a small, self-contained learning unit that gets developers/learners from
"a model dropped" to "I've run it and I know when to use it" quickly.

Design goals:

- **Discoverability** — hierarchical layout, clear naming, cross-links.
- **Consistency** — every capsule looks the same; one shared quickstart.
- **Authoring velocity** — a Copilot custom agent + skills produce the
  boilerplate so advocates focus on the *interesting* content.
- **Pedagogy** — capability taxonomy, glossary, per-category primers,
  visuals (mermaid), conversational tone.

---

## 2. Repository layout

```
model-releases/
├── README.md                       # front door: what, why, get started, learn more
├── catalog.json, llms.txt          # generated: machine-readable indexes
├── requirements-dev.txt            # base + Capsule dependencies section
├── .devcontainer/                  # existing; post-create installs requirements-dev.txt
├── .github/
│   ├── plan.md                     # this document (living)
│   ├── agents/
│   │   └── CapsuleCreatorAgent.md  # Copilot custom agent
│   └── skills/
│       ├── add-publisher/
│       ├── add-model/
│       ├── add-capsule/
│       ├── add-to-glossary/
│       ├── add-capability-doc/
│       ├── maintain-capsule/
│       └── refresh-recent-activity/
├── docs/
│   ├── ANNOUNCEMENTS.md            # one row per release announcement
│   ├── CAPSULES.md                 # generated: capsules grouped by provider
│   ├── GLOSSARY.md                 # anchor-per-term short explainers
│   └── primers/                    # one primer per capability tag (see the folder)
└── models/
    ├── quickstart/                 # shared setup — referenced by every capsule
    │   ├── README.md               # Foundry project · deployments · .env · verify
    │   └── .env.example
    └── <publisher>/                # one folder per publisher (see models/)
        └── README.md               # publisher overview + members table
```

Capsule path convention (added on demand, not up-front):

```
models/<publisher-slug>/<model-slug>/   # folder name == the `model:` slug
    ├── README.md                # blog-style promo + Before You Begin
    ├── <model-slug>.ipynb       # or 01-<topic>.ipynb, 02-<topic>.ipynb, ...
    └── assets/                  # optional
```

The release date lives in frontmatter (`release_date`), not in the path.

**Model router family (dated releases).** `model-router` has no versions — it
updates in place. Its releases are dated capsule folders
`models/model-router/<mmm-yyyy>/` (for example `aug-2026/`), where the capsule
`model:` slug equals the folder name. In ANNOUNCEMENTS.md and the README
**Recently added** list the row reads "Model router" with a short description,
not the slug; the capsule is matched to its row by date + `model_card` URL. The publisher README lists **releases, not
members**, and frames the model two ways: as a model to build agents, and as an
optimization tool whose routing config is a lever. Each release folder holds one
notebook per feature/lever from that month's update, each opening with a
falsifiable "does changing X improve Y?" question.

**`demos/` — reusable optimization scenarios.** `demos/<name>/` holds a scenario
(data + instructions + benchmark) for practicing hill climbing against live
Foundry deployments. Demos are **not** capsules and are invisible to the catalog.
Rules: demo data must be **future-proof** (dates in late 2026–2028, never past
dates); datasets are JSON (playground-friendly); a stable Travel-State-style
schema plus modality-neutral artifacts keep a scenario reusable across
capabilities (text now; vision/voice/image later by swapping only the agent and
its "Inputs & modalities" block).

**Env vars.** Capsules use `MICROSOFT_FOUNDRY_ENDPOINT` (the project endpoint).
Entra ID capsules (e.g. the model router series) authenticate with `az login`
(`azure-identity`) — no API key — plus a `<JOB>_DEPLOYMENT` var such as
`AZURE_MODEL_ROUTER_DEPLOYMENT`. Additional vars are documented in
`scripts/sample.env` and the capsule's Before You Begin, which links back to
`models/quickstart/`.

---

## 3. Repo README structure

The README is the front door, and each section answers one question:

1. **What are model releases?** What a release is and what a capsule is.
2. **Why do they matter?** The vehicle analogy and why model choice is about fit.
3. **How can I get started?** Notebook-count badges per publisher, then Setup,
   Pick a family, and Try a notebook. The badge block between
   `<!-- BEGIN:RECENT-CAPSULES --> … <!-- END:RECENT-CAPSULES -->` is generated
   from capsule frontmatter by `scripts/generate-catalog.py`.
4. **How can I learn more?** The top 3 announcement row as a **Recently added**
   list between `<!-- BEGIN:RECENTLY-ADDED --> … <!-- END:RECENTLY-ADDED -->`,
   each as `**Model** · [Release date](announcement) · Capabilities`. The
   `refresh-recent-activity` skill copies every part from the announcement row, so
   the block can be regenerated at any time. Neither pricing nor expiry appears
   here.
5. **Where can I find the details?** Links to the reference guide, contributing,
   and the agent-facing indexes.

The publisher table and the capability taxonomy live in
[`docs/README.md`](../docs/README.md), not in the repo README.

---

## 4. ANNOUNCEMENTS.md

One row per release, newest first, grouped into a table per month.
**Rows may be added before a capsule exists** — the announcement and
any known model-card link are enough. Capsules are tracked
separately in `CAPSULES.md`.

Rows are grouped into one table per month, newest month first, and every row
is exactly four cells: `Date | Publisher | Model | Capabilities`. The cell
formats are defined once, in [maintainer guide §3.8](./maintainer-guide.md#38-adding-an-announcement-row),
with a copyable template at the bottom of
[`ANNOUNCEMENTS.md`](../docs/ANNOUNCEMENTS.md). `validate-crosslinks.py` rejects a row that
is not four cells wide, because a fifth cell renders under a four-column
header and is silently wrong.

**Pricing is deliberately not a column.** Rates change and vary by
region, tier, and deployment type, so a figure frozen into an announcements list
row goes stale silently and no validator can catch it. The model card
is the source of truth for price; a capsule links to it from its
**Before You Begin** section.

`add-capsule` skill prepends a row automatically, or updates an
existing announcement-only row in place when the Date + Model match.

---

## 5. Capability taxonomy (canonical names)

Defined **once**, as the `capability` and `aliases` fields of the primers in
`docs/primers/`. The taxonomy table in `docs/README.md` is generated from them,
and every other surface references a tag by name.

- **Chat Completion** — general instruction-following, dialogue.
- **Reasoning** — extended thinking / chain-of-thought optimized models.
- **Multimodal** — accepts image (and/or audio) input alongside text.
- **Vision** — image understanding as primary capability.
- **Image Generation** — text → image output.
- **Embeddings** — vector representations for retrieval / similarity.
- **Audio / Speech** — STT, TTS, or realtime voice.
- **Function Calling / Tools** — structured tool invocation.
- **Model Router** — routes requests across models.
- **Fine-tuning Ready** — supports customization.
- **Long Context** — 200k+ context window.

Every capsule is tagged with 1–N of these. Tags surface in the publisher
README tables, capsule READMEs, ANNOUNCEMENTS.md Capabilities column, and
`CAPSULES.md`.

---

## 6. Shared quickstart — `models/quickstart/`

Purpose: get the learner from zero to "notebooks will run" **once**,
so every capsule can point here instead of repeating setup.

Contents:

- Create/select a Foundry project.
- Deploy the model(s) referenced by the capsule you're about to run.
- Configure `.env` (endpoint, key, deployment names, region).
- `.env.example` template.
- **Verify step** — a tiny snippet learners run to confirm env is good.
- Troubleshooting: quota, region, RBAC, common auth errors.

Every capsule notebook opens with an **env precheck cell** that checks
required vars and, if any are missing, prints:

> ⚠️ Missing env vars: …
> Please complete `models/quickstart/` before running this notebook.

---

## 7. Publisher README template — `models/<publisher>/README.md`

Sections:

1. **What this publisher does** — 2–3 sentences.
2. **Why it matters** — when to reach for it vs. alternatives.
3. **Members** — table:

   | Model | Capabilities | Model card | Released | Expires | Capsule |
   |---|---|---|---|---|---|

4. **Learn more** — links to relevant `docs/*.md` primers.

---

## 8. Content capsule anatomy

Every capsule at `models/<publisher>/<model>/` contains:

1. **`README.md`** — blog-style promo:
   - Hook / TL;DR.
   - **Before You Begin** — pricing, release date, expiry date,
     model card link, model docs link, required capabilities,
     link to `models/quickstart/`.
   - What you'll learn (bullets).
   - The interesting use cases (see below).
   - Links to notebooks.
2. **One or more notebooks** at the capsule root:
   - Cell 1: **Before You Begin** (markdown, same info as README).
   - Cell 2: **Env precheck** (code).
   - Then: model-specific content.
3. **Interesting use cases** — deliberately *beyond* the default
   model-card samples; tied to a real domain (e.g., travel policy,
   supply chain, dev tooling) so the learner sees judgment, not just API calls.
4. **Capability tags** — using §5 canonical names, in the capsule frontmatter.
5. **Dependencies** — any capsule-specific packages appended to the
   `# Capsule dependencies` section of `requirements-dev.txt`.

---

## 9. `docs/` — shared learner materials

- **`GLOSSARY.md`** — one heading per term, kebab-case anchor, 2–4 sentence
  explainer. Terms referenced from any README/notebook by
  `docs/GLOSSARY.md#context-window`. Managed by `add-to-glossary` skill.
- **One primer per capability** (§5) under `docs/primers/`. Each primer has:
  - What this class of model is (conversational tone).
  - When to use / when not to use.
  - A mermaid diagram illustrating the shape of the workflow.
  - **Max 3** curated learning resources.
- Pedagogy defaults: mermaid over prose walls, callouts, short paragraphs,
  worked example > abstract explanation.

---

## 10. Devcontainer + dependencies

- `requirements-dev.txt` has two clearly labeled sections:
  ```
  # General Dependencies
  numpy
  pandas
  ipykernel

  # Capsule dependencies
  # <appended by add-capsule skill; keep sorted, pinned where sensible>
  ```
- `.devcontainer/post-create.sh` runs `pip install -r requirements-dev.txt`
  so a rebuild always installs the full current set.
- `add-capsule` skill deduplicates and appends new deps; if it touches
  requirements, it reminds the author to rebuild the devcontainer.

---

## 11. Copilot custom agent + skills

Location: `.github/agents/` and `.github/skills/` (GitHub Copilot conventions).

### `CapsuleCreatorAgent`
Purpose: guide an advocate from "a model released" to "capsule merged."
Behavior:
1. Ask for publisher, model, release date, announcement URL, model card URL,
   pricing, expiry, capability tags, target domain(s) for use cases.
2. Confirm publisher/model folder exists; if not, invoke `add-publisher` /
   `add-model` first.
3. Invoke `add-capsule` to scaffold the folder, README, notebook skeleton
   with Before You Begin + env precheck.
4. Suggest 2–3 *interesting* use-case ideas beyond the default samples,
   grounded in the chosen domain; let the author pick.
5. Append capsule deps to `requirements-dev.txt`.
6. Prepend row to `ANNOUNCEMENTS.md`.
7. Run `python scripts/generate-catalog.py` (README badges, `CAPSULES.md`,
   indexes) and invoke `refresh-recent-activity` to update the repo README.
8. Offer to invoke `add-to-glossary` / `add-capability-doc` if new terms
   or a new category appear.

### Skills (each = `.github/skills/<name>/SKILL.md` + optional helpers)

- **`add-publisher`** — create `models/<publisher>/README.md` from template
  (overview + empty members table). Fails if publisher already exists.
- **`add-model`** — add a row to a publisher's members table; create
  `models/<publisher>/<model>/` if needed. No capsule yet.
- **`add-capsule`** — scaffold `models/<publisher>/<model>/`
  with README, notebook (Before You Begin + env precheck), update
  publisher table, prepend announcement row, append deps, regenerate indexes.
- **`add-to-glossary`** — insert/update a term in `docs/GLOSSARY.md`
  (kebab-case anchor, alphabetized, consistent format).
- **`add-capability-doc`** — scaffold `docs/primers/<capability>.md` primer
  (structure from §9) and extend the capsule schema enum; the taxonomy table
  in `docs/README.md` regenerates from the primer.
- **`maintain-capsule`** — audit, update, or repair an existing capsule and
  its notebooks while preserving paths and reporting compatibility changes.
- **`refresh-recent-activity`** — regenerate the **Recently added**
  list between the `<!-- BEGIN:RECENTLY-ADDED --> … <!-- END:RECENTLY-ADDED -->`
  markers in the repo README. Each bullet is Model · Release date
  (→ announcement URL) · Capabilities — mirroring the order of
  `CAPSULES.md`. Every part is copied from the top announcement row.
  Runs after `add-capsule` and on a monthly cadence.

---

## 12. Todos (v1 build order)

**Status: v1 scaffolding complete (2026-08-03).** All 11 build tasks
below are `done` in the session `todos` table; `python
scripts/validate.py` reports every artifact valid.

> Historical v1 build log. Counts and file names below reflect v1; the repo
> itself is the source of truth for current state.

Tracked in the session `todos` table with dependencies. High-level order:

1. ✅ Commit this plan to `.github/plan.md`.
2. ✅ Draft repo `README.md` (structure + capability taxonomy) with
   the Recently added marker block at the top.
3. ✅ Create `ANNOUNCEMENTS.md` skeleton.
4. ✅ Create `docs/GLOSSARY.md` seed (A–Z sectioned; "Context Window"
   as the seed entry with Learn reference).
5. ✅ Create `docs/primers/<capability>.md` primer stubs for all 11
   taxonomy entries, each with YAML frontmatter and Learn-grounded
   resources.
6. ✅ Create `models/quickstart/` (README pointing to
   `scripts/sample.env` + `scripts/setenv.sh`).
7. ✅ Create the 11 publisher folders each with a `README.md` stub.
8. ✅ Confirm `requirements-dev.txt` "Capsule dependencies" placeholder +
   `.devcontainer/post-create.sh` installs it.
9. ✅ Author `.github/agents/CapsuleCreatorAgent.md` with pedagogy +
   references guardrails.
10. ✅ Author `.github/skills/*` — six skills (`add-publisher`, `add-model`,
    `add-capsule`, `add-to-glossary`, `add-capability-doc`,
    `refresh-recent-activity`).
11. ✅ Wire up the **Recently added** marker block
    at the top of the repo README.
12. ✅ Create `scripts/` (README, `sample.env`, `setenv.sh` +
    `setenv.spec.md` sidecar, `validate-specs.py`).
13. ✅ Author 7 JSON Schemas under `.github/specs/schemas/` (capsule,
    publisher, primer, quickstart, skill, agent, script) + README.
14. ✅ Author [`.github/maintainer-guide.md`](./maintainer-guide.md) —
    quickstart + routine tasks + 5-layer testing strategy.

Not in v1: authoring actual release capsules, adding subfolders under
publishers. Those happen on demand via the agent/skills.

### Recommended next steps (v1.1)

- Wire up `.github/workflows/validate.yml` (sample YAML lives in the
  maintainer guide §4 Layer 5) so PRs run the validator + banned-phrase
  + brand-rule checks automatically.
- Drive the first real capsule through `CapsuleCreatorAgent` to
  exercise the end-to-end flow (this is the user's stated next action).
- Once the first capsule lands, revisit §14 to decide whether the
  frontmatter+schema approach is holding up or whether it's time to
  upgrade to GitHub Spec Kit.

---

## 13. Documentation grounding

**Every explainer and "Learn more" link in this repo must be grounded in
[Microsoft Learn](https://learn.microsoft.com/) content** whenever a canonical
Learn page exists for the topic. Prefer, in order:

1. Foundry conceptual docs under `learn.microsoft.com/azure/foundry/...`
2. Foundry how-to / tutorials
3. Foundry model-catalog / model-publisher reference pages
4. Architecture reference (`learn.microsoft.com/azure/architecture/...`)

Only fall back to provider blogs / model cards when Microsoft Learn does not
yet cover the topic. The `CapsuleCreatorAgent` verifies each Learn link
before it lands in a capsule, and capability primers cap the resource list
at **3 Learn links** to keep learners focused.

**Never localize Learn URLs.** Write `learn.microsoft.com/azure/...`, with no
locale segment such as `en-us`, so Learn sends each reader to their own
language. `validate.py` fails any Learn link that carries one.

### Brand rule — always "Microsoft Foundry"

The product is **Microsoft Foundry** (or short form "Foundry"). Never
write "Azure AI Foundry" or "Azure Foundry" in prose, headings, or copy
we author — even though Learn URLs and older service names (e.g.
"Azure OpenAI", "Azure AI Speech") legitimately contain "Azure". Distinct
Azure services keep their real names; only the Foundry product itself is
normalized. All skills and the `CapsuleCreatorAgent` enforce this on
generated content.

## 14. Authoring approach — spec-driven (lightweight)

**Decision:** author every artifact with **Markdown + YAML frontmatter**.
The frontmatter is the machine-readable spec; the body is the human
narrative. Frontmatter is validated against JSON Schemas in
[`.github/specs/schemas/`](./specs/schemas/).

**Rationale:** frontmatter is the de-facto standard for content specs
(Jekyll, Hugo, MDX, Docusaurus, Copilot skill/prompt files). One file per
artifact, no separate spec/plan/tasks trio to keep in sync, but strict
typing where it matters via JSON Schema. Any markdown-aware tool can
already read it.

**Upgrade path:** if we outgrow this for large multi-step features, we
can adopt full [GitHub Spec Kit](https://github.com/github/spec-kit)
conventions (`spec.md` + `plan.md` + `tasks.md` per feature) *selectively*
without rewriting existing artifacts.

**Artifact types with frontmatter (`kind:` values):**

| `kind` | Location | Purpose |
|---|---|---|
| `capsule` | `models/<publisher>/<release>/README.md` | A single release capsule |
| `scenario` | `models/<publisher>/multi-model-scenarios/<slug>/README.md` | A walkthrough spanning 2+ releases |
| `publisher` | `models/<publisher>/README.md` | Model-publisher overview |
| `primer` | `docs/primers/<slug>.md` | Capability primer |
| `quickstart` | `models/quickstart/README.md` | Shared Foundry setup |
| `skill` | `.github/skills/<name>/SKILL.md` | Copilot custom skill |
| `agent` | `.github/agents/<name>.md` | Copilot custom agent |
| `script` | `scripts/<name>.spec.md` sidecar | Script contract + docs |

**Workflow:**

1. Author edits (or the agent scaffolds) the artifact's frontmatter.
2. Skill / agent validates it against `.github/specs/schemas/<kind>.schema.json`.
3. Skill renders / updates the human-facing artifact and any
   cross-references (publisher tables, ANNOUNCEMENTS, Recent Activity).
4. `scripts/validate.py` re-runs every check across the whole repo to
   catch drift (on-demand, pre-commit, and in CI).

## 15. Content authoring & pedagogy rules

Audience assumption: **technically capable developers who may be new to
Foundry.** Comfortable with Python, APIs, and LLMs; not with Foundry
project/deployment mechanics. Author for judgement and orientation, not
for excitement.

### Voice

Applies to **all** authored content — capsules, notebooks, primers, the
glossary, and READMEs — not just capsules.

- **Persona.** Write as a Technical Content Writer for Microsoft Foundry,
  for a mixed audience of beginners, learners, and experts. Clear,
  concise, actionable, warm, and encouraging.
- **Knowledgeable teammate.** Write as though we are working alongside the
  learner. Welcome curiosity, make the next useful action easy to see, and
  treat experimentation, imperfect results, and debugging as normal parts of
  building rather than mistakes to avoid.
- **Grounded encouragement.** Invite a concrete action ("try a different
  input", "inspect the trace", "compare the results") instead of using praise,
  cheerleading, or vague enthusiasm. Warmth comes from useful company and a
  clear next step, not marketing language.
- **Action-focused.** Every section answers "what am I doing and why?"
- **Answer a developer question.** Lead each unit of content with the
  concrete question a developer is actually asking. Glossary entries
  state that question in italics under the heading, then answer it.
- **Reinforce the term.** Open a glossary definition by restating the
  term ("Agent Optimization is about …", "A context window is …").
- **Shared voice.** Use "we", not "you", to reflect a common, shared
  understanding and focus. Direct action labels such as "Open the notebook"
  are fine when they make instructions shorter and clearer.
- **Terminology.** Write "model router" in lowercase (not "Model Router"),
  and say "model router in Microsoft Foundry" on first reference in a
  document. Generated catalog names and tables are a separate concern.
- **No hype, no marketing.** Ban phrases like *revolutionary*,
  *game-changing*, *unlocks*, *supercharge*, *seamless*, *cutting-edge*,
  *best-in-class*, *state-of-the-art*, *powerful*, *effortlessly*.
  Describe what the model does and where it fits; let the reader judge.
- **Concrete over abstract.** Prefer a worked example to a general claim.
- **Storytelling, connected.** Favor narrative flow; cross-link related
  terms and concepts so content reads as a connected story, not isolated
  facts.
- **Visual storytelling.** Prefer a **mermaid diagram over prose** whenever a
  flow, relationship, or sequence can be drawn. Use diagrams and tables where
  they add clarity, without overwhelming. Short paragraphs, working examples,
  mermaid over prose walls.
- **Emoji.** Essentially none — reserve for an occasional celebratory
  "Success".

### Capsule README structure

Blog-style but plain: hook (1–2 sentences of *what changed*), Before
You Begin, What you'll learn, Use cases (with domain framing), Notebooks
list, Links. No superlatives, no "why this is amazing."

### Notebook granularity

- **Each notebook covers 1–3 concepts, no more.** If a release
  introduces more, split into additional notebooks under the same
  capsule folder (`01-<topic>.ipynb`, `02-<topic>.ipynb`, …) rather
  than growing one long notebook.
- Notebook filenames are zero-padded, ordered, and named after the
  concept they teach (verb-first is fine): e.g.
  `01-send-a-chat-request.ipynb`, `02-attach-an-image.ipynb`,
  `03-call-a-tool.ipynb`.
- The capsule README lists every notebook with a one-line "what you'll
  learn" per file so learners can pick the exercise they need.
- Each notebook is **independently runnable**: it repeats the Before
  You Begin + env-precheck cells rather than depending on a prior
  notebook's kernel state.

### Notebook learning loop (mandatory)

Notebooks use **constructionism**: learners build a working artifact,
inspect evidence from it, encounter a controlled problem, and repair it.
Every notebook makes these stages evident, but authors may use
domain-specific section names and combine adjacent stages when that makes
the narrative clearer:

1. **Prepare.** `Before You Begin` gives prerequisites, pricing, dates,
  model-card and quickstart links. `Verify your environment` runs the env
  precheck before any paid request.
2. **Frame a question.** State the developer question the notebook answers,
  what we will build, and one observable result we can use to judge it.
3. **Build a minimal working path.** Assemble the smallest complete request
  or workflow and run it before adding options or abstractions.
4. **Observe and explain.** Inspect the response, trace, image, waveform,
  timing, token use, routing decision, or evaluation result. Use a table,
  chart, annotated output, or mermaid diagram when it reveals behavior more
  clearly than prose.
5. **Introduce a controlled failure or weak result.** Change one variable to
  expose a realistic failure mode such as invalid configuration, weak
  grounding, malformed structured output, poor routing, or noisy input.
  Prefer deterministic, low-cost failures and never expose credentials.
6. **Diagnose from evidence.** Form a hypothesis, inspect the relevant
  signal, and distinguish the root cause from symptoms.
7. **Fix and verify.** Make the smallest correction, rerun the same check,
  and compare before/after evidence so the learner can see why the fix
  worked.
8. `## N. Your Turn to Explore` — **required, third-to-last.**
   Markdown cell followed by an empty code cell inviting the learner to
   try their own prompt/input. Suggest 2–3 concrete directions
   (change the system prompt, swap the input modality, add a tool)
   without giving the answer.
9. `## N+1. Summary` — **required, second-to-last.** Markdown: what the
   notebook covered, when to reach for this model vs. alternatives,
   links to the relevant primer(s) and glossary terms.
10. `## N+2. References` — **required, final.** Markdown: bulleted list
    of the author-supplied references (model card, docs, samples, blogs,
    papers), written as markdown links in the body. The `add-capsule`
    skill prompts the creator for these up front — the section must not
    ship empty.

Section headings use `##` (level 2) so they populate the Outline;
sub-steps within a section can use `###`. Number sub-steps to match their
parent section (`### 2.1`, `### 2.2`), and always leave a blank line before a
subheading so it reads cleanly.

Use progressive disclosure for the mixed audience. Keep the main path
runnable by a beginner who knows Python, then add short `Why this works`,
`Debugging`, or `Production considerations` subsections for readers who need
the mechanism, operational tradeoffs, or deeper diagnosis. Do not repeat the
same explanation in beginner and advanced forms.

### Enforcement

- Voice + structure rules are stated in
  [`.github/agents/CapsuleCreatorAgent.md`](./agents/CapsuleCreatorAgent.md)
  and in the [`add-capsule`](./skills/add-capsule/SKILL.md) skill.
- The notebook scaffold produced by `add-capsule` already contains the
  `Your Turn to Explore`, `Summary`, and `References` cells — do not
  remove them when authoring.
- The `## References` section is **required** and must have at least
  one entry; the agent asks the creator for best-practice references
  (model card, official docs, sample repos, blog posts, papers) up
  front and writes them into that section as markdown links. They live
  in the body rather than frontmatter so that crawlers and agents
  follow them as real links.
- Reviewers should reject PRs that reintroduce banned marketing phrases
  or drop any of the three required trailing sections.

## 16. Open questions to resolve as we build

- Preferred slug casing for publishers (`azure-openai` vs `azure_openai`)?
  Assumed **kebab-case** throughout — confirm on first build.
- Do we want a badge system (shields.io) for capability tags in READMEs,
  or plain markdown pills? Assume plain markdown for v1.
- Notebook runtime language: assume Python only for v1
  (matches `requirements-dev.txt`).
