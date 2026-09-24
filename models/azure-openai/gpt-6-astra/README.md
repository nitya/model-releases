---
kind: capsule
publisher: azure-openai
model: gpt-6-astra
summary: "Reconcile product records, manuals, and product images into an evidence-backed outfitting plan"
release_date: "2026-09-03"
last_updated: "2026-09-21"
capabilities: [reasoning, chat-completion, multimodal, vision, function-calling, long-context]
model_card: https://ai.azure.com/catalog/models/gpt-6-astra
announcement: https://azure.microsoft.com/en-us/blog/gpt-6-astra-frontier-intelligence-for-work-now-generally-available-in-microsoft-foundry/
pricing:
  url: https://azure.microsoft.com/pricing/details/azure-openai/
  notes: "Rates vary by deployment and short- or long-context usage"
dependencies: [openai, python-dotenv]
domains: [retail, outdoor-recreation]
notebooks:
  - path: 01-plan-a-safe-outfitting-kit.ipynb
    title: "Plan a safe outfitting kit from mixed product evidence"
    concepts:
      - multimodal evidence synthesis
---

# GPT-6 Astra — Release Capsule

**Released:** 2026-09-03 · **Publisher:** [Azure OpenAI](../README.md) ·
**Core notebook capability:** Multimodal evidence synthesis

How do we turn product records, detailed manuals, and product photography into
one recommendation without losing track of which source supports each claim?
This capsule keeps that question concrete with a two-product Contoso Outdoors
shopping task.

## Before You Begin

| Detail | Value |
|---|---|
| Model card | [GPT-6 Astra — Foundry catalog](https://ai.azure.com/catalog/models/gpt-6-astra) |
| Announcement | [GPT-6 Astra in Microsoft Foundry](https://azure.microsoft.com/en-us/blog/gpt-6-astra-frontier-intelligence-for-work-now-generally-available-in-microsoft-foundry/) |
| Pricing | [Current Azure OpenAI pricing](https://azure.microsoft.com/pricing/details/azure-openai/) |
| Release date | 2026-09-03 |
| Deployment | A Microsoft Foundry deployment named in `AZURE_OPENAI_GPT_6_ASTRA_DEPLOYMENT` |

Complete the [model quickstart](../../quickstart/README.md), confirm quota for
GPT-6 Astra, and configure the Azure OpenAI v1 endpoint variables documented in
[`scripts/sample.env`](../../../scripts/sample.env).

## What we'll learn

We will make one Responses API call that combines local catalog text, both
manuals, and both WebP images. The result must cite product IDs and separate
observed image details from facts stated in the catalog or manuals.

## Use cases

- Review mixed product evidence before publishing a buyer's guide.
- Reconcile written specifications with product photography during catalog QA.
- Prepare a sourced handoff for a human retail or safety specialist.

## Notebook

| Notebook | Developer question |
|---|---|
| [`01-plan-a-safe-outfitting-kit.ipynb`](01-plan-a-safe-outfitting-kit.ipynb) | Can one model reconcile product records, equipment manuals, images, and campsite constraints into an evidence-backed outfitting plan? |

The exercise uses the shared
[Contoso Outdoors subset](../shared/contoso-outdoors/ASSETS.md) and writes no
generated files.

## References

- [GPT-6 Astra model card](https://ai.azure.com/catalog/models/gpt-6-astra) — capability and deployment overview.
- [Azure OpenAI reasoning models](https://learn.microsoft.com/en-us/azure/foundry/openai/how-to/reasoning) — reasoning controls and token behavior.
- [Use the Azure OpenAI Responses API](https://learn.microsoft.com/en-us/azure/foundry/openai/how-to/responses) — Microsoft Foundry Python client pattern and multimodal inputs.
- [Foundry Models sold by Azure](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure#gpt-6) — version, context, and feature support.
