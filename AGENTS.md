# AGENTS.md

Guidance for AI coding agents working in **model-releases**.

## What this repo is

This model-releases repo builds practical **model knowledge** and a **model
optimization playbook** for building efficient AI agents on Microsoft Foundry.
The goal is education and discovery — help developers find, understand, and try
the right model for an agentic task. It is not a product or marketing surface.

## Golden rules

- **Validate after every change:** `python scripts/generate-catalog.py && python scripts/validate.py` must pass.
- **Generated files stay generated.** Never hand-edit `catalog.json`, `llms.txt`,
  `CAPSULES.md`, or the marker-bounded README tables — regenerate them.
- **Notebook changes refresh the README.** Notebooks are declared in a capsule's
  `notebooks:` frontmatter. After adding, renaming, or removing one, run
  `python scripts/generate-catalog.py` so the README badges (counts and order)
  and the indexes update.
- **Frontmatter is a contract.** It must match the schemas in `.github/specs/schemas/`.
- **Never localize Learn URLs.** Write `learn.microsoft.com/azure/...` with no
  locale segment such as `en-us`; `validate.py` fails any that has one.
- **`.do-not-commit/` is scratch** — never read it or use it as context.

## Writing voice

Full rules in [`.github/plan.md`](.github/plan.md) §15. Essentials:

- Persona: Technical Content Writer for Microsoft Foundry; audience spans
  beginners to experts. Clear, concise, actionable, warm, and encouraging.
- Write like a knowledgeable teammate working alongside the learner. Welcome
  curiosity, make the next step easy to see, and treat iteration and debugging
  as normal parts of building.
- Lead with the developer question the content answers.
- Reinforce the term at the start of a definition ("Agent Optimization is about …").
- Use **"we"**, not "you", for shared understanding.
- Encourage through specific invitations such as "try changing the input" or
  "compare the two results," not praise, cheerleading, or vague enthusiasm.
- No hype or marketing language. Prefer storytelling and cross-links over
  isolated facts.
- Visual storytelling with mermaid/tables where it helps; essentially no emoji
  (only an occasional celebratory "Success").

## Where to look

- Design plan: [`.github/plan.md`](.github/plan.md)
- Maintainer guide: [`.github/maintainer-guide.md`](.github/maintainer-guide.md)
- Skills: [`.github/skills/`](.github/skills/)
- Glossary: [`docs/GLOSSARY.md`](docs/GLOSSARY.md)
