<!--
  Pull request template for model-releases.

  Please pick the section(s) that match what your PR changes and tick
  the boxes as you go. Any unchecked box in a section you're touching
  is a signal for the reviewer to look closer.

  The `Validate contribution` job runs `python scripts/4-validate-spec.py` on
  this PR and gates the merge. It covers the mechanical items (schemas,
  cross-links, generated files, no `_review_` placeholders) — run the
  same command locally first so CI isn't where you find out.
  These checklists cover what it can't see (pedagogy, tone, links).
-->

## Summary

<!-- One or two sentences on what this PR changes and why. -->

## Type of change

- [ ] New capsule (`models/<publisher>/<model>/`)
- [ ] New publisher (`models/<publisher>/`)
- [ ] New capability primer (`docs/primers/<slug>.md`)
- [ ] New glossary term (`docs/GLOSSARY.md`)
- [ ] announcement-only entry (announcement without capsule yet)
- [ ] Infrastructure / scripts / workflows
- [ ] Docs / README tidy-up

## Capsule checklist (fill in for new capsules)

- [ ] Folder is `models/<publisher>/<model>/` (the folder name equals the
      `model:` slug; the release date lives in frontmatter)
- [ ] `python scripts/4-validate-spec.py` passes
- [ ] `## References` (capsule README and each notebook) lists at least one
      model card and one docs link, on `learn.microsoft.com` where a
      canonical Learn page exists
- [ ] Notebooks follow [`plan.md` §15](./plan.md#15-content-authoring--pedagogy-rules):
      1–3 concepts, the build-and-debug loop, and closing **Your Turn to
      Explore**, **Summary**, and **References** sections
- [ ] Notebook starts by verifying `.env` (points learner back to
      `models/quickstart/` if unset)
- [ ] `notebooks:` frontmatter lists every notebook, and
      `python scripts/5-generate-catalog.py` was run so the README badges
      and indexes are current
- [ ] `ANNOUNCEMENTS.md` has a row with matching Date + Model, exactly four
      cells wide, with the Date cell linked to the announcement
- [ ] Publisher README lists this model in its members table
- [ ] `README.md` **Recently added** block (Model / Release date /
      Capabilities) reflects the top 3

## Publisher / primer / glossary checklist

- [ ] Frontmatter validates
- [ ] Cross-links back to repo README and quickstart
- [ ] Grounded on `learn.microsoft.com` where a Learn page exists;
      provider docs only when necessary
- [ ] For a new capability primer: any existing capsule that already
      uses this tag now passes the crosslink check

## Pedagogy self-review

- [ ] Voice and tone follow [`plan.md` §15](./plan.md#15-content-authoring--pedagogy-rules)
      (warm shared "we" voice, no hype words)
- [ ] Every learner-facing link resolves and points to a canonical
      source
- [ ] Uses "Microsoft Foundry" (never "Azure AI Foundry"); services
      like Azure OpenAI keep their real names

## Reviewer notes

<!-- Anything the reviewer should look at first, screenshots of
     rendered notebooks, open questions, etc. -->
