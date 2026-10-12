---
kind: publisher
name: Microsoft
slug: microsoft
one_line: Microsoft-built models beyond the MAI family, starting with decision models
provider: Microsoft
related_primers: [decision-models]
---

# Microsoft Models on Microsoft Foundry

> **Microsoft-built models that sit outside the MAI family.** The first member is
> Microsoft-Decision-1, a model that answers closed questions with a choice, a score,
> or a probability instead of generated text.

## Why it matters

Not every step in an AI application needs a model that writes. Some steps route a
request, grade an answer, or check whether an action is allowed. Microsoft publishes
models for those focused jobs next to its generative ones, so we can match the model
to the step. The MAI image, voice, transcription, reasoning, and coding models live
in [Microsoft AI](../microsoft-ai/README.md).

## Members

> **Expires** = model deprecation date when known; `—` means no announced retirement date.

| Model | Capabilities | Model card | Released | Expires | Capsule |
|---|---|---|---|---|---|
| Microsoft-Decision-1 | Decision Models | [Foundry catalog](https://ai.azure.com/catalog/models/Microsoft-Decision-1) | 2026-10-09 | — | [capsule](microsoft-decision-1/) |

## Learn more

### Usage guides

- [Deploy and use Microsoft-Decision-1 in Microsoft Foundry](https://learn.microsoft.com/azure/foundry/foundry-models/how-to/use-foundry-models-microsoft-decision)

### Announcements

- [Introducing Microsoft-Decision-1 in Microsoft Foundry](https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/introducing-microsoft-decision-1-in-microsoft-foundry-for-decision-and-classific/4562742) (2026-10-09)

### Background

- [Decision models primer](../../docs/primers/decision-models.md)
- [Glossary](../../docs/GLOSSARY.md)
