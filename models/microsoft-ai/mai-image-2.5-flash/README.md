---
kind: capsule
publisher: microsoft-ai
model: mai-image-2.5-flash
summary: "Generate images faster and at lower cost"
release_date: "2026-06-02"
last_updated: "2026-08-04"
capabilities: [image-generation]
model_card: https://ai.azure.com/catalog/models/MAI-Image-2.5-Flash
announcement: https://microsoft.ai/news/microsoft-build-2026-mai-keynote-transcript/
pricing:
  url: https://microsoft.ai/models/mai-image-2-5/
  notes: "lower than MAI-Image-2.5 base — see model page for current rate"
dependencies: [requests]
domains: [e-commerce, product-photography, high-volume-content]
notebooks:
  - path: mai-image-2.5-flash.ipynb
    title: "Production-scale image generation with MAI-Image-2.5-Flash"
    concepts:
      - compare Flash with MAI-Image-2.5 on the same prompts for quality, latency, and cost
      - batch generation, throughput measurement, and cost estimation
      - concurrent requests for high-volume workflows
---

# MAI-Image-2.5-Flash — Release Capsule

**Released:** 2026-06-02 · **Publisher:** [Microsoft AI](../README.md) · **Capability:** Image Generation

> **Legacy model version.** MAI-Image-2.5-Flash version 2026-06-02 retires on 2026-11-14 at 7:00 PM local time. After that, inferencing returns error responses and all deployments of this version stop being supported. Edit the deployment to move to a supported version if a new one is available.

## Before You Begin

| Detail | Value |
|---|---|
| Model card | [MAI-Image-2.5-Flash — Foundry catalog](https://ai.azure.com/catalog/models/MAI-Image-2.5-Flash) |
| Announcement | [Build 2026 MAI keynote](https://microsoft.ai/news/microsoft-build-2026-mai-keynote-transcript/) |
| Pricing | Lower than base MAI-Image-2.5 — see [model page](https://microsoft.ai/models/mai-image-2-5/) |
| Release date | 2026-06-02 |
| Retirement date | 2026-11-14, 7:00 PM local time (version 2026-06-02) |
| Deployment regions | West Central US · East US · West US · West Europe · Sweden Central · South India · UAE North |

See [models/quickstart/](../../quickstart/README.md) for first-time Foundry project setup.

**Required env variables:**

```
MICROSOFT_FOUNDRY_ENDPOINT            # e.g. https://<resource>.services.ai.azure.com/api/projects/<project>
MICROSOFT_FOUNDRY_API_KEY             # AIServices API key
AZURE_MAI_IMAGE_25_FLASH_DEPLOYMENT   # your MAI-Image-2.5-Flash deployment name
```

Optional, for the side-by-side comparison with the base model:

```
AZURE_MAI_IMAGE_25_DEPLOYMENT         # your MAI-Image-2.5 deployment name
```

## Notebook

| Notebook | Concepts |
|---|---|
| [mai-image-2.5-flash.ipynb](mai-image-2.5-flash.ipynb) | Compare with MAI-Image-2.5 · Batch generation and throughput · Concurrent requests |

**MAI-Image-2.5-Flash** is the production-efficiency variant of the MAI-Image-2.5 family. It delivers the
same text-to-image generation and image-to-image editing capabilities as the base model, optimised for
lower latency and cost per image at scale. Choose Flash when throughput and cost efficiency matter more
than maximum fidelity.

- [MAI-Image-2.5 capsule](../mai-image-2.5/) — base model; start here if new to the family
- [MAI-Image-2.5-Pro capsule](../mai-image-2.5-pro/) — Pro variant with portrait quality and text rendering

The notebook also puts Flash next to the base model on the same prompts, showing each pair of images with its latency and estimated cost. Its "Before You Begin" section compares the 2.5 models with the newer MAI-Image-2.6-Flash.

## API endpoints

| API | URL pattern | Body |
|---|---|---|
| Image generations | `https://<resource>.services.ai.azure.com/mai/v1/images/generations` | JSON |
| Image edits | `https://<resource>.services.ai.azure.com/mai/v1/images/edits` | multipart/form-data |

Constraints: `width` and `height` both ≥ 768; `width × height` ≤ 1,048,576. Output is always PNG.

## References

- [Deploy and use MAI image models in Microsoft Foundry](https://learn.microsoft.com/azure/foundry/foundry-models/how-to/use-foundry-models-mai-image?tabs=python) — official how-to covering the generations and edits APIs, authentication, and rate limits.
- [Build 2026 MAI keynote transcript](https://microsoft.ai/news/microsoft-build-2026-mai-keynote-transcript/) — keynote introducing the full MAI model family including Flash.
- [MAI-Image-2.5 model page](https://microsoft.ai/models/mai-image-2-5/) — model overview, capability comparison, and arena benchmarks.
- [MAI-Image-2.6 and MAI-Image-2.6-Flash](https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/mai-image-2-6-and-mai-image-2-6-flash-quality-and-speed-at-production-scale/4550970) — the newer generation: features, pricing, and when to choose each.
