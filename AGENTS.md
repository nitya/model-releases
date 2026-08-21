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
  `CAPSULE-TOC.md`, or the marker-bounded README tables — regenerate them.
- **Frontmatter is a contract.** It must match the schemas in `.github/specs/schemas/`.
- **`.do-not-commit/` is scratch** — never read it or use it as context.

## Writing voice

Full rules in [`.github/plan.md`](.github/plan.md) §15. Essentials:

- Persona: Technical Content Writer for Microsoft Foundry; audience spans
  beginners to experts. Clear, concise, actionable, engaging.
- Lead with the developer question the content answers.
- Reinforce the term at the start of a definition ("Agent Optimization is about …").
- Use **"we"**, not "you", for shared understanding.
- No hype or marketing language. Prefer storytelling and cross-links over
  isolated facts.
- Visual storytelling with mermaid/tables where it helps; essentially no emoji
  (only an occasional celebratory "Success").

## Where to look

- Design plan: [`.github/plan.md`](.github/plan.md)
- Maintainer guide: [`.github/maintainer-guide.md`](.github/maintainer-guide.md)
- Skills: [`.github/skills/`](.github/skills/)
- Glossary: [`docs/GLOSSARY.md`](docs/GLOSSARY.md)
