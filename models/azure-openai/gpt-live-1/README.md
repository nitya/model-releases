---
kind: capsule
publisher: azure-openai
model: gpt-live-1
summary: "Redirect a full-duplex spoken product explanation while preserving the session transcript and audio"
release_date: "2026-09-10"
last_updated: "2026-09-21"
capabilities: [audio-speech, function-calling]
model_card: https://ai.azure.com/catalog/models/gpt-live-1
announcement: https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/create-multimodal-applications-with-openai-models-in-microsoft-foundry/4543593
pricing:
  url: https://azure.microsoft.com/pricing/details/azure-openai/
  notes: "Voice-session duration and any delegated backend work are billed separately"
dependencies: [websockets, python-dotenv, azure-identity]
domains: [retail, outdoor-recreation]
notebooks:
  - path: 01-redirect-a-product-explanation.ipynb
    title: "Redirect a spoken product explanation"
    concepts:
      - full-duplex conversation redirection
---

# GPT-Live-1 — Release Capsule

**Released:** 2026-09-10 · **Publisher:** [Azure OpenAI](../README.md) ·
**Core notebook capability:** Full-duplex conversation redirection

A voice assistant should adapt when a shopper changes direction instead of
finishing an obsolete answer. This capsule uses a deterministic, server-side
WebSocket flow: a committed shopper-audio fixture asks about the tent, the
application redirects the session after output begins, and the model continues
with the backpack.

## Before You Begin

| Detail | Value |
|---|---|
| Model card | [GPT-Live-1 — Foundry catalog](https://ai.azure.com/catalog/models/gpt-live-1) |
| Announcement | [Create multimodal applications with OpenAI models in Microsoft Foundry](https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/create-multimodal-applications-with-openai-models-in-microsoft-foundry/4543593) |
| Pricing | [Current Azure OpenAI pricing](https://azure.microsoft.com/pricing/details/azure-openai/) |
| Release date | 2026-09-10 |
| Deployment | A Microsoft Foundry deployment named in `AZURE_OPENAI_GPT_LIVE_1_DEPLOYMENT` |

Complete the [model quickstart](../../quickstart/README.md), run `az login`, then
set the Azure OpenAI endpoint and deployment variables documented in
[`scripts/sample.env`](../../../scripts/sample.env). The local notebook uses
Microsoft Entra ID rather than placing an API key on the WebSocket. The default
path does not use a microphone because it streams the committed PCM fixture.
Received audio is written only under the ignored `output/` directory.

## What we'll learn

We will start a GPT-Live session, stream a local shopper question, redirect the
session after its first output-audio delta, collect interleaved transcript
fragments, and close the connection gracefully.

## Use cases

- Redirect a retail voice assistant when a shopper changes products.
- Steer a spoken explanation from a trusted server-side application.
- Capture audio, transcript fragments, and final cumulative session usage.

## Notebook

| Notebook | Developer question |
|---|---|
| [`01-redirect-a-product-explanation.ipynb`](01-redirect-a-product-explanation.ipynb) | Can an application redirect a voice shopping assistant after its tent explanation begins? |

## References

- [GPT-Live-1 model card](https://ai.azure.com/catalog/models/gpt-live-1) — Foundry catalog entry.
- [What is GPT-Live?](https://learn.microsoft.com/en-us/azure/foundry/openai/concepts/gpt-live) — full-duplex behavior, redirection, and application responsibilities.
- [Use GPT-Live for real-time voice](https://learn.microsoft.com/en-us/azure/foundry/openai/how-to/gpt-live) — WebSocket lifecycle and audio format.
- [GPT-Live event API reference](https://learn.microsoft.com/en-us/azure/foundry/openai/gpt-live-reference) — client and server event schemas.
