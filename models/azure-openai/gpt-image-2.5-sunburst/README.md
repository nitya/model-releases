---
kind: capsule
publisher: azure-openai
model: gpt-image-2.5-sunburst
summary: "Apply a precise campaign-background edit while asking the model to preserve the source backpack"
release_date: "2026-09-09"
last_updated: "2026-09-21"
capabilities: [image-generation]
model_card: https://ai.azure.com/catalog/models/gpt-image-2.5-sunburst
announcement: https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/create-multimodal-applications-with-openai-models-in-microsoft-foundry/4543593
pricing:
  url: https://azure.microsoft.com/pricing/details/azure-openai/
  notes: "Image rates vary by quality, dimensions, and deployment"
dependencies: [requests, python-dotenv]
domains: [retail, outdoor-recreation]
notebooks:
  - path: 01-preserve-a-product-in-a-campaign-edit.ipynb
    title: "Preserve a backpack in a campaign edit"
    concepts:
      - high-fidelity product-preserving editing
---

# GPT-Image-2.5-Sunburst — Release Capsule

**Released:** 2026-09-09 · **Publisher:** [Azure OpenAI](../README.md) ·
**Core notebook capability:** High-fidelity product-preserving editing

A campaign edit is useful only if the approved product remains recognizable.
This capsule asks GPT-Image-2.5-Sunburst to change the setting around the
Adventurer Pro Backpack while preserving its design, color, and visible marks.

## Before You Begin

| Detail | Value |
|---|---|
| Model card | [GPT-Image-2.5-Sunburst — Foundry catalog](https://ai.azure.com/catalog/models/gpt-image-2.5-sunburst) |
| Announcement | [Create multimodal applications with OpenAI models in Microsoft Foundry](https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/create-multimodal-applications-with-openai-models-in-microsoft-foundry/4543593) |
| Pricing | [Current Azure OpenAI pricing](https://azure.microsoft.com/pricing/details/azure-openai/) |
| Release date | 2026-09-09 |
| Deployment | A Microsoft Foundry deployment named in `AZURE_OPENAI_GPT_IMAGE_25_SUNBURST_DEPLOYMENT` |

Complete the [model quickstart](../../quickstart/README.md), then set the Azure
OpenAI endpoint, API key, and deployment variables documented in
[`scripts/sample.env`](../../../scripts/sample.env). Outputs are saved only
under the ignored `output/` directory.

## What we'll learn

We will make one constrained image edit from the committed backpack WebP, save
the returned PNG, and use an explicit human review checklist for product
preservation. The notebook does not claim pixel-perfect preservation.

## Use cases

- Place an approved product into a new campaign setting.
- State preservation constraints explicitly before creative editing.
- Review generated campaign assets against the source image.

## Notebook

| Notebook | Developer question |
|---|---|
| [`01-preserve-a-product-in-a-campaign-edit.ipynb`](01-preserve-a-product-in-a-campaign-edit.ipynb) | Can we change a campaign background while preserving the product, branding, and geometry? |

## References

- [GPT-Image-2.5-Sunburst model card](https://ai.azure.com/catalog/models/gpt-image-2.5-sunburst) — Foundry catalog entry.
- [Use image generation models from OpenAI](https://learn.microsoft.com/en-us/azure/foundry/openai/how-to/dall-e) — image edits endpoint, supported parameters, and response format.
- [Use the Azure OpenAI Responses API](https://learn.microsoft.com/en-us/azure/foundry/openai/how-to/responses) — supported model version listing.
- [Create multimodal applications with OpenAI models in Microsoft Foundry](https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/create-multimodal-applications-with-openai-models-in-microsoft-foundry/4543593) — release announcement.
