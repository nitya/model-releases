---
kind: capsule
publisher: azure-openai
model: gpt-6-luna
summary: "Classify short retail questions into deterministic support routes and inspect request latency"
release_date: "2026-09-22"
last_updated: "2026-09-23"
capabilities: [reasoning, chat-completion, multimodal, vision, function-calling, long-context]
model_card: https://ai.azure.com/catalog/models/gpt-6-luna
announcement: https://azure.microsoft.com/en-us/blog/gpt-6-astra-sol-and-luna-for-production-agents-in-microsoft-foundry/
pricing:
  url: https://azure.microsoft.com/pricing/details/azure-openai/
  notes: "Rates vary by deployment and short- or long-context usage"
dependencies: [openai, python-dotenv]
domains: [retail, outdoor-recreation]
notebooks:
  - path: 01-route-shopper-questions.ipynb
    title: "Route short shopper questions"
    concepts:
      - low-latency request classification
---

# GPT-6 Luna — Release Capsule

**Released:** 2026-09-22 · **Publisher:** [Azure OpenAI](../README.md) ·
**Core notebook capability:** Low-latency request classification

Not every retail question needs a long analysis. This capsule sends a fixed
set of short Contoso Outdoors questions to GPT-6 Luna and checks whether the
responses remain concise, machine-readable, and grounded in the provided route
definitions.

## Before You Begin

| Detail | Value |
|---|---|
| Model card | [GPT-6 Luna — Foundry catalog](https://ai.azure.com/catalog/models/gpt-6-luna) |
| Announcement | [GPT-6 Astra, Sol, and Luna in Microsoft Foundry](https://azure.microsoft.com/en-us/blog/gpt-6-astra-sol-and-luna-for-production-agents-in-microsoft-foundry/) |
| Pricing | [Current Azure OpenAI pricing](https://azure.microsoft.com/pricing/details/azure-openai/) |
| Release date | 2026-09-22 |
| Deployment | A Microsoft Foundry deployment named in `AZURE_OPENAI_GPT_6_LUNA_DEPLOYMENT` |

Complete the [model quickstart](../../quickstart/README.md) and configure the
Azure OpenAI v1 endpoint variables in
[`scripts/sample.env`](../../../scripts/sample.env).

## What we'll learn

We will classify four short questions with reasoning disabled, parse each JSON
answer, and inspect elapsed time. The measurements describe this run only; they
are not a general model benchmark.

## Use cases

- Route high-volume support messages before a specialist model is selected.
- Separate safety questions from routine sales and care requests.
- Emit compact machine-readable labels for an application workflow.

## Notebook

| Notebook | Developer question |
|---|---|
| [`01-route-shopper-questions.ipynb`](01-route-shopper-questions.ipynb) | Can we classify and route many short camping-store questions without paying frontier-model latency for every request? |

## References

- [GPT-6 Astra, Sol, and Luna in Microsoft Foundry](https://azure.microsoft.com/en-us/blog/gpt-6-astra-sol-and-luna-for-production-agents-in-microsoft-foundry/) — official family announcement.
- [GPT-6 Luna model card](https://ai.azure.com/catalog/models/gpt-6-luna) — model positioning and supported workloads.
- [Use the Azure OpenAI Responses API](https://learn.microsoft.com/en-us/azure/foundry/openai/how-to/responses) — v1 Python request and usage fields.
- [Azure OpenAI reasoning models](https://learn.microsoft.com/en-us/azure/foundry/openai/how-to/reasoning) — reasoning effort controls.
- [Foundry Models sold by Azure](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure#gpt-6) — verified family membership and release version.
