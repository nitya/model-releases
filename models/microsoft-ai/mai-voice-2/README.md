---
kind: capsule
publisher: microsoft-ai
model: mai-voice-2
summary: "Direct expressive, multilingual, and long-form speech synthesis"
release_date: "2026-06-02"
last_updated: "2026-08-19"
capabilities: [audio-speech]
model_card: https://ai.azure.com/catalog/models/MAI-Voice-2
announcement: https://microsoft.ai/news/mai-voice-2/
pricing:
  url: https://azure.microsoft.com/pricing/details/speech/
  notes: "Speech synthesis is billed per character; rates vary by region and tier"
dependencies: [azure-cognitiveservices-speech]
domains: [accessibility, education, entertainment, media-production]
notebooks:
  - path: 01-direct-expressive-delivery.ipynb
    title: "Direct expressive delivery with MAI-Voice-2"
    concepts:
      - baseline speech synthesis with a prebuilt voice
      - SSML style and style-degree comparisons
      - controlled scene direction and playback review
  - path: 02-test-multilingual-long-form.ipynb
    title: "Test multilingual and long-form speech with MAI-Voice-2"
    concepts:
      - multilingual voice comparison
      - Hindi-English and Spanish-English code-switching
      - chunked long-form synthesis and consistency review
---

# MAI-Voice-2 — Release Capsule

**Released:** 2026-06-02 · **Publisher:** [Microsoft AI](../README.md) · **Capability:** Audio / Speech

MAI-Voice-2 is a text-to-speech model for expressive, multilingual, and long-form audio.
These notebooks turn the same text into controlled listening comparisons so you can judge
delivery, locale handling, and consistency for your own scenario.

> **Public preview.** MAI-Voice is available through Azure Speech in public preview, without
> a service-level agreement, and isn't recommended for production workloads.

## Before You Begin

| Detail | Value |
|---|---|
| Model card | [MAI-Voice-2 — Foundry catalog](https://ai.azure.com/catalog/models/MAI-Voice-2) |
| Announcement | [Introducing MAI-Voice-2](https://microsoft.ai/news/mai-voice-2/) |
| Pricing | Speech synthesis is billed per character; check [current regional pricing](https://azure.microsoft.com/pricing/details/speech/) |
| Release date | 2026-06-02 |
| Retirement date | No retirement date announced |
| Regions | Check the live [Azure Speech region table](https://learn.microsoft.com/azure/ai-services/speech-service/regions) before creating the resource |

Complete [models/quickstart/](../../quickstart/README.md) for first-time Foundry setup, then
create an Azure Speech resource in a region that supports MAI models.

**Required environment variables:**

```text
MICROSOFT_FOUNDRY_ENDPOINT   # shared quickstart setting
MICROSOFT_FOUNDRY_API_KEY    # Speech or AIServices resource key
AZURE_SPEECH_ENDPOINT        # e.g. https://<resource>.cognitiveservices.azure.com/
```

The notebooks derive the service origin from `AZURE_SPEECH_ENDPOINT` and never embed a key.
The endpoint and key must belong to the same resource and region.

## What you'll learn

- Synthesize text with the Azure Speech SDK and a prebuilt MAI-Voice-2 voice.
- Hold text and voice constant while comparing SSML styles and intensity.
- Test multilingual, code-switched, and chunked long-form scripts with repeatable inputs.
- Save WAV outputs and review listening evidence without treating subjective impressions as metrics.

## Notebooks

| Notebook | What you'll learn |
|---|---|
| [01-direct-expressive-delivery.ipynb](01-direct-expressive-delivery.ipynb) | Establish a baseline, build an SSML delivery matrix, and direct a short audio scene |
| [02-test-multilingual-long-form.ipynb](02-test-multilingual-long-form.ipynb) | Compare locale-specific voices, test code-switching, and assemble a chunked narration |

Both notebooks are independently runnable. Generated WAV files go to `output/`, which is
created at runtime and should not be committed.

## Choose a voice and delivery

The supplied SDK example uses `en-US-Ethan:MAI-Voice-2`. MAI-Voice-2 also provides
locale-specific prebuilt voices. A voice's locale and supported styles determine which SSML
experiments are valid; use the live [prebuilt voice table](https://learn.microsoft.com/azure/ai-services/speech-service/mai-voices#prebuilt-voices)
as the source of truth.

Expressive synthesis uses `mstts:express-as`:

```xml
<mstts:express-as style="hopeful" styledegree="1.2">
  We found a safe route through the storm.
</mstts:express-as>
```

Use plain text synthesis for a baseline and SSML synthesis for controlled style comparisons.
The notebooks request PCM WAV output so Python can inspect durations and join compatible
segments without another audio dependency.

## Know the boundaries

- MAI-Voice-2 favors fidelity and long-form consistency over latency-critical interaction.
  Compare it with MAI-Voice-2-Flash when responsiveness is the primary constraint.
- Style availability varies by voice. Unsupported style and voice combinations can be
  rejected or produce an unhelpful comparison.
- Listening tests are qualitative. Keep script, voice, format, and playback conditions fixed
  before attributing a difference to style or locale.
- Instant voice cloning is a gated feature. It requires limited-access approval, licensed or
  consented voice material, and system-level consent safeguards. It is intentionally not
  included in executable notebook cells.

## References

- [MAI-Voice overview](https://learn.microsoft.com/azure/ai-services/speech-service/mai-voices) — official feature, SSML, voice, language, preview, and gated-access guidance.
- [MAI-Voice-2 model card](https://ai.azure.com/catalog/models/MAI-Voice-2) — Foundry catalog capabilities and model details.
- [Introducing MAI-Voice-2](https://microsoft.ai/news/mai-voice-2/) — release examples, supported languages, code-switching, use cases, and consent guidance.
- [Azure Speech SDK samples](https://github.com/Azure-Samples/cognitive-services-speech-sdk) — official SDK examples across supported languages.
- [Speech synthesis with the Speech SDK](https://learn.microsoft.com/azure/ai-services/speech-service/get-started-text-to-speech) — authentication, audio output, and result handling.
- [Speech service regions](https://learn.microsoft.com/azure/ai-services/speech-service/regions) — live region and endpoint guidance.
- [Speech pricing](https://azure.microsoft.com/pricing/details/speech/) — current character-based text-to-speech pricing.
- [Audio / Speech primer](../../../docs/primers/audio-speech.md) — capability background and deployment considerations.
