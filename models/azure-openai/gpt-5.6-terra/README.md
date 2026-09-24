---
kind: capsule
publisher: azure-openai
model: gpt-5.6-terra
summary: "Ground a structured gear comparison in deterministic local inventory lookups"
release_date: "2026-07-09"
last_updated: "2026-09-21"
capabilities: [reasoning, chat-completion, multimodal, vision, function-calling, long-context]
model_card: https://ai.azure.com/catalog/models/gpt-5.6-terra
announcement: https://azure.microsoft.com/en-us/blog/gpt-5-6-now-available-in-microsoft-foundry/
pricing:
  url: https://azure.microsoft.com/pricing/details/azure-openai/
  notes: "Rates vary by deployment and short- or long-context usage"
dependencies: [openai, python-dotenv]
domains: [retail, outdoor-recreation]
notebooks:
  - path: 01-compare-gear-with-tools.ipynb
    title: "Compare gear with a local catalog tool"
    concepts:
      - function calling
---

# GPT-5.6 Terra — Release Capsule

**Released:** 2026-07-09 · **Publisher:** [Azure OpenAI](../README.md) ·
**Core notebook capability:** Function calling

A recommendation is easier to trust when current product facts come from our
application instead of the model's memory. This capsule gives GPT-5.6 Terra one
small catalog tool and keeps the tool boundary visible.

## Before You Begin

| Detail | Value |
|---|---|
| Model card | [GPT-5.6 Terra — Foundry catalog](https://ai.azure.com/catalog/models/gpt-5.6-terra) |
| Announcement | [GPT-5.6 in Microsoft Foundry](https://azure.microsoft.com/en-us/blog/gpt-5-6-now-available-in-microsoft-foundry/) |
| Pricing | [Current Azure OpenAI pricing](https://azure.microsoft.com/pricing/details/azure-openai/) |
| Release date | 2026-07-09 |
| Deployment | A Microsoft Foundry deployment named in `AZURE_OPENAI_GPT_56_TERRA_DEPLOYMENT` |

Complete the [model quickstart](../../quickstart/README.md) and configure the
Azure OpenAI v1 endpoint variables in
[`scripts/sample.env`](../../../scripts/sample.env).

## What we'll learn

We will define a `lookup_product` function, let the model request the two local
records, execute those calls in Python, and return the outputs to the same
Responses API conversation.

The Responses API is intentional: GPT-5.6 Chat Completions cannot combine
function tools with nonzero reasoning effort. Use Responses for this pattern,
or set reasoning effort to `none` when using Chat Completions.

## Use cases

- Ground shopping assistants in current catalog records.
- Keep inventory or pricing lookups behind application-controlled functions.
- Audit which product facts entered a recommendation.

## Notebook

| Notebook | Developer question |
|---|---|
| [`01-compare-gear-with-tools.ipynb`](01-compare-gear-with-tools.ipynb) | Can a balanced model turn a shopper's requirements into a reliable, structured gear comparison? |

## References

- [GPT-5.6 now available in Microsoft Foundry](https://azure.microsoft.com/en-us/blog/gpt-5-6-now-available-in-microsoft-foundry/) — official family announcement.
- [GPT-5.6 Terra model card](https://ai.azure.com/catalog/models/gpt-5.6-terra) — model positioning and supported workloads.
- [Use the Azure OpenAI Responses API](https://learn.microsoft.com/en-us/azure/foundry/openai/how-to/responses) — function tools and multi-turn responses.
- [Azure OpenAI reasoning models](https://learn.microsoft.com/en-us/azure/foundry/openai/how-to/reasoning) — API behavior for reasoning models.
- [Foundry Models sold by Azure](https://learn.microsoft.com/en-us/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure#gpt-56) — verified family membership and release version.
