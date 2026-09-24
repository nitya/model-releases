---
kind: capsule
publisher: azure-openai
model: gpt-6-sol
summary: "Resolve conflicting product claims and safety constraints before recommending a camping bundle"
release_date: "2026-09-22"
last_updated: "2026-09-23"
capabilities: [reasoning, chat-completion, multimodal, vision, function-calling, long-context]
model_card: https://ai.azure.com/catalog/models/gpt-6-sol
announcement: https://azure.microsoft.com/en-us/blog/gpt-6-astra-sol-and-luna-for-production-agents-in-microsoft-foundry/
pricing:
  url: https://azure.microsoft.com/pricing/details/azure-openai/
  notes: "Rates vary by deployment and short- or long-context usage"
dependencies: [openai, python-dotenv]
domains: [retail, outdoor-recreation]
notebooks:
  - path: 01-reason-through-gear-constraints.ipynb
    title: "Reason through gear constraints and conflicting claims"
    concepts:
      - constraint reasoning
---

# GPT-6 Sol — Release Capsule

**Released:** 2026-09-22 · **Publisher:** [Azure OpenAI](../README.md) ·
**Core notebook capability:** Reasoning

Retail data is rarely perfectly consistent. This capsule asks GPT-6 Sol to
check a camping request against the local product records and manuals, surface
conflicts, and avoid filling gaps with assumptions.

## Before You Begin

| Detail | Value |
|---|---|
| Model card | [GPT-6 Sol — Foundry catalog](https://ai.azure.com/catalog/models/gpt-6-sol) |
| Announcement | [GPT-6 Astra, Sol, and Luna in Microsoft Foundry](https://azure.microsoft.com/en-us/blog/gpt-6-astra-sol-and-luna-for-production-agents-in-microsoft-foundry/) |
| Pricing | [Current Azure OpenAI pricing](https://azure.microsoft.com/pricing/details/azure-openai/) |
| Release date | 2026-09-22 |
| Deployment | A Microsoft Foundry deployment named in `AZURE_OPENAI_GPT_6_SOL_DEPLOYMENT` |

Complete the [model quickstart](../../quickstart/README.md) and configure the
Azure OpenAI v1 endpoint variables in
[`scripts/sample.env`](../../../scripts/sample.env).

## What we'll learn

We will use one Responses API request with high reasoning effort. The model
must distinguish supported facts, contradictory source claims, and unanswered
questions before making a recommendation.

## Use cases

- Check product bundles against safety and compatibility constraints.
- Triage conflicting catalog and support documentation before escalation.
- Produce an evidence checklist for a human product specialist.

## Notebook

| Notebook | Developer question |
|---|---|
| [`01-reason-through-gear-constraints.ipynb`](01-reason-through-gear-constraints.ipynb) | Can deeper reasoning catch incompatible gear and safety constraints before we recommend a camping bundle? |

## References

- [GPT-6 Astra, Sol, and Luna in Microsoft Foundry](https://azure.microsoft.com/en-us/blog/gpt-6-astra-sol-and-luna-for-production-agents-in-microsoft-foundry/) — official family announcement.
- [GPT-6 Sol model card](https://ai.azure.com/catalog/models/gpt-6-sol) — model positioning and supported workloads.
- [Azure OpenAI reasoning models](https://learn.microsoft.com/en-us/azure/foundry/openai/how-to/reasoning) — reasoning effort and usage details.
- [Use the Azure OpenAI Responses API](https://learn.microsoft.com/en-us/azure/foundry/openai/how-to/responses) — v1 Python request pattern.
- [Foundry Models sold by Azure](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure#gpt-6) — verified family membership and release version.
