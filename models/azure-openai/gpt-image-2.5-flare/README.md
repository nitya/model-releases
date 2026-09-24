---
kind: capsule
publisher: azure-openai
model: gpt-image-2.5-flare
summary: "Create tent and backpack merchandising variants from approved local product images"
release_date: "2026-09-09"
last_updated: "2026-09-21"
capabilities: [image-generation]
model_card: https://ai.azure.com/catalog/models/gpt-image-2.5-flare
announcement: https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/create-multimodal-applications-with-openai-models-in-microsoft-foundry/4543593
pricing:
  url: https://azure.microsoft.com/pricing/details/azure-openai/
  notes: "Image rates vary by quality, dimensions, and deployment"
dependencies: [requests, python-dotenv]
domains: [retail, outdoor-recreation]
notebooks:
  - path: 01-create-merchandising-variants.ipynb
    title: "Create tent merchandising variants"
    concepts:
      - multi-variant image editing
---

# GPT-Image-2.5-Flare — Release Capsule

**Released:** 2026-09-09 · **Publisher:** [Azure OpenAI](../README.md) ·
**Core notebook capability:** Multi-variant image editing

Merchandising teams often need several candidate scenes before choosing one.
This capsule sends the committed tent and backpack photographs to separate
image edit requests and saves two variants of each for human review.

## Before You Begin

| Detail | Value |
|---|---|
| Model card | [GPT-Image-2.5-Flare — Foundry catalog](https://ai.azure.com/catalog/models/gpt-image-2.5-flare) |
| Announcement | [Create multimodal applications with OpenAI models in Microsoft Foundry](https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/create-multimodal-applications-with-openai-models-in-microsoft-foundry/4543593) |
| Pricing | [Current Azure OpenAI pricing](https://azure.microsoft.com/pricing/details/azure-openai/) |
| Release date | 2026-09-09 |
| Deployment | A Microsoft Foundry deployment named in `AZURE_OPENAI_GPT_IMAGE_25_FLARE_DEPLOYMENT` |

Complete the [model quickstart](../../quickstart/README.md), then set the Azure
OpenAI endpoint, API key, and deployment variables documented in
[`scripts/sample.env`](../../../scripts/sample.env). Outputs are saved only
under the ignored `output/` directory.

## What we'll learn

We will submit each local WebP reference to the documented image edits endpoint,
request two merchandising variants per product, record each request's elapsed
time, and display the returned images. The timings are observations, not
general model performance claims.

## Use cases

- Explore several campaign settings from one approved product photograph.
- Produce candidate retail scenes for human selection.
- Keep source and generated assets separated in a repeatable local workflow.

## Notebook

| Notebook | Developer question |
|---|---|
| [`01-create-merchandising-variants.ipynb`](01-create-merchandising-variants.ipynb) | Can we generate marketplace-ready tent and backpack variants quickly enough for an interactive merchandising workflow? |

## References

- [GPT-Image-2.5-Flare model card](https://ai.azure.com/catalog/models/gpt-image-2.5-flare) — Foundry catalog entry.
- [Use image generation models from OpenAI](https://learn.microsoft.com/en-us/azure/foundry/openai/how-to/dall-e) — image edits endpoint, parameters, and response format.
- [Use the Azure OpenAI Responses API](https://learn.microsoft.com/en-us/azure/foundry/openai/how-to/responses) — supported model version listing.
- [Create multimodal applications with OpenAI models in Microsoft Foundry](https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/create-multimodal-applications-with-openai-models-in-microsoft-foundry/4543593) — release announcement.
