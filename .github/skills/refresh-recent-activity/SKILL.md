---
kind: skill
name: refresh-recent-activity
description: Regenerate the repo README's Recently added list (Model · Release date · Capabilities) from the top 3 announcement row.
inputs: []
produces:
  - README.md
validates_against: []
depends_on: []
---

# refresh-recent-activity

Rewrites the marker-bracketed **Recently added** list in the repo
README:

```
<!-- BEGIN:RECENTLY-ADDED --> … <!-- END:RECENTLY-ADDED -->
```

One bullet per announcement row (the top 3, newest first — these may
include announcements that have no capsule yet), in this shape:

```
- **<Model>** · [<Release date>](<announcement URL>) · <Capabilities>
```

| Part | Source | Link target |
|---|---|---|
| Model | announcement row's Model cell, minus any link markup | plain bold text — no link |
| Release date | announcement row's Date cell | the announcement (carried over from that cell) |
| Capabilities | announcement row's Capabilities cell, verbatim | plain text — no link |

Order mirrors `CAPSULES.md`: what it is first, when it landed
second. Every part is copied from the announcement row rather than
written by hand, so the list can be regenerated at any time without
losing prose.

Neither pricing nor expiry is shown in the README. Neither is in the
ANNOUNCEMENTS.md either — price lives on the model card a capsule links to,
and expiry lives in the publisher README members table, which is the
single place a retirement date is tracked. The section copy around the
README list points readers to ANNOUNCEMENTS.md for the full history.

Idempotent — safe to run any time. Called automatically at the end of
[`add-capsule`](../add-capsule/), and recommended on a monthly cadence
via a scheduled GitHub Action.
