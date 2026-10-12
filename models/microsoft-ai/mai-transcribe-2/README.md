---
kind: capsule
publisher: microsoft-ai
model: mai-transcribe-2
summary: "Transcribe noisy multilingual audio with diarization, timestamps, and domain biasing"
release_date: "2026-09-03"
last_updated: "2026-09-14"
capabilities: [audio-speech]
model_card: https://ai.azure.com/catalog/models/MAI-Transcribe-2
announcement: https://microsoft.ai/news/mai-transcribe-2-is-the-fastest-most-accurate-and-cheapest-speech-recognition-model-in-the-world/
pricing:
  url: https://microsoft.ai/models/mai-transcribe-2/
  notes: "$0.10 per hour of audio for a limited time; standard pricing is $0.36 per hour"
dependencies: [azure-ai-transcription, azure-identity]
domains: [contact-center, healthcare, media-captioning, meetings, accessibility]
notebooks:
  - path: mai-transcribe-2.ipynb
    title: "Speaker-aware transcription and MAI-Transcribe-1.5 comparison with MAI-Transcribe-2"
    concepts:
      - speaker-aware transcription with timestamps and controlled noise levels
      - multilingual transcription and domain vocabulary biasing
      - controlled comparison with MAI-Transcribe-1.5
---

# MAI-Transcribe-2 — Release Capsule

**Released:** 2026-09-03 · **Publisher:** [Microsoft AI](../README.md) · **Capability:** Audio / Speech

> **Public preview.** MAI-Transcribe runs on the LLM Speech API, which is in public preview — no SLA, not recommended for production workloads.

## Before You Begin

| Detail | Value |
|---|---|
| Model card | [MAI-Transcribe-2 — Foundry catalog](https://ai.azure.com/catalog/models/MAI-Transcribe-2) |
| Announcement | [Introducing MAI-Transcribe-2](https://microsoft.ai/news/mai-transcribe-2-is-the-fastest-most-accurate-and-cheapest-speech-recognition-model-in-the-world/) |
| Pricing | $0.10 per hour for a limited time; standard price $0.36 per hour — [source](https://microsoft.ai/models/mai-transcribe-2/) |
| Release date | 2026-09-03 |
| Deployment regions | See [Speech service regions](https://learn.microsoft.com/azure/ai-services/speech-service/regions?tabs=llmspeech) — LLM Speech is available in a subset of Speech regions |

See [models/quickstart/](../../quickstart/README.md) for first-time Foundry project setup.

**Required environment variables:**

```text
MICROSOFT_FOUNDRY_ENDPOINT   # e.g. https://<resource>.services.ai.azure.com/api/projects/<project>
MICROSOFT_FOUNDRY_API_KEY    # AIServices (Speech) resource key
```

Optional overrides:

```text
AZURE_SPEECH_ENDPOINT        # use when your Speech resource differs from the Foundry project resource
```

> MAI-Transcribe-2 needs **no deployment name**. Select the model by passing `MAI-Transcribe-2`
> in the request's `enhancedMode` block.

## Notebook

| Notebook | Concepts |
|---|---|
| [mai-transcribe-2.ipynb](mai-transcribe-2.ipynb) | Speaker diarization and word timestamps · Multilingual and controlled noise-level transcription · Domain vocabulary biasing · Controlled comparison with MAI-Transcribe-1.5 |

## What MAI-Transcribe-2 provides

MAI-Transcribe-2 is a multilingual speech recognition model for noisy and real-world audio.
It supports:

- **60 languages** with automatic language identification and code switching
- **Speaker diarization** to identify who spoke
- **Word-level timestamps** for alignment, search, navigation, and editing
- **Keyword biasing** through `phraseList` for specialized vocabulary
- **Configurable transcript style**, including verbatim output that preserves fillers and
  a readability-oriented style for cleaner transcripts

The model is designed for contact-centre documentation, clinical notes, accessibility tools,
content creation, and voice-agent workflows.

## API surface

| Piece | Value |
|---|---|
| Endpoint | `https://<resource>.cognitiveservices.azure.com/speechtotext/transcriptions:transcribe?api-version=2025-10-15` |
| Body | `multipart/form-data` — `audio` file + `definition` JSON |
| Auth header | `Ocp-Apim-Subscription-Key`, or Entra ID via `DefaultAzureCredential` |
| Python SDK | [`azure-ai-transcription`](https://pypi.org/project/azure-ai-transcription/) — `TranscriptionClient.transcribe()` |

A request can combine model selection with diarization, word timestamps, transcript style,
and domain vocabulary:

```json
{
  "locales": ["en-US"],
  "phraseList": {
    "phrases": ["Microsoft Foundry", "AI", "DevOps"]
  },
  "diarization": {
    "enabled": true
  },
  "enhancedMode": {
    "model": "MAI-Transcribe-2"
  },
  "modelOptions": {
    "timestamps": "word",
    "transcribeStyle": "verbatim"
  }
}
```

Omit `locales` to allow automatic language identification. When supplied, use a full BCP-47
tag such as `en-US`; the current documentation describes locale forcing as a strong hint for
one language.

## Know the boundaries

- Speaker diarization is currently limited to shorter recordings in preview. Longer requests
  can time out or fail with service errors; for long recordings, transcribe without diarization
  and use word timestamps with a separate diarization step.
- Audio and request limits, supported locales, and feature availability can change while the
  API is in preview. Check the live Speech documentation before building a production workflow.
- Diarization attributes words to speakers within the returned segments; inspect the response
  shape before coupling downstream logic to a particular segment layout.
- Pricing is time-sensitive. Treat the MAI model page as the source of truth for the current
  limited-time and standard rates.

## References

- [MAI-Transcribe-2 model page](https://microsoft.ai/models/mai-transcribe-2/) — features, language coverage, benchmarks, and current pricing.
- [MAI-Transcribe-2 announcement](https://microsoft.ai/news/mai-transcribe-2-is-the-fastest-most-accurate-and-cheapest-speech-recognition-model-in-the-world/) — release context and comparative accuracy results.
- [MAI-Transcribe in Azure Speech](https://learn.microsoft.com/azure/ai-services/speech-service/mai-transcribe?context=%2Fazure%2Ffoundry%2Fcontext%2Fcontext&pivots=ai-foundry) — REST parameters, language support, diarization, timestamps, transcript styles, and limitations.
- [LLM Speech for speech transcription and translation](https://learn.microsoft.com/azure/ai-services/speech-service/llm-speech?tabs=new-foundry%2Cwindows&pivots=programming-language-python) — authentication, the `azure-ai-transcription` SDK, and response handling.
- [Speech service regions](https://learn.microsoft.com/azure/ai-services/speech-service/regions?tabs=llmspeech) — current region and endpoint guidance.
- [Audio / Speech primer](../../../docs/primers/audio-speech.md) — capability background and deployment considerations.
