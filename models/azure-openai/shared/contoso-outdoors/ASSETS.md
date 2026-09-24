# Contoso Outdoors capsule assets

This directory is a deliberately small, local subset of the Contoso Outdoors
sample catalog. The Azure OpenAI capsules use the same two products, manuals,
and images so that each notebook changes the model task rather than the
scenario.

## Included files

| Local file | Source file |
|---|---|
| `products.json` | Product IDs 1 and 2 from `src/data/products.json` |
| `manuals/product_info_1.md` | `content/manuals/product_info_1.md` |
| `manuals/product_info_2.md` | `content/manuals/product_info_2.md` |
| `images/product_1.webp` | `public/media/products/1/1.webp` |
| `images/product_2.webp` | `public/media/products/2/1.webp` |
| `audio/shopper-tent-question.wav` | Generated for the GPT-Live-1 notebook |

The files were copied from
[`nitya/gpt-demo-sample`](https://github.com/nitya/gpt-demo-sample) at commit
[`87a4fc388c75b96eaea79f33b531acc46871c6c3`](https://github.com/nitya/gpt-demo-sample/commit/87a4fc388c75b96eaea79f33b531acc46871c6c3).
Only the two requested product records were retained. Their `manual` and
`images` values were rewritten to the local subset paths; product facts were
not changed.

That repository's import script identifies
[`Azure-Samples/contoso-web`](https://github.com/Azure-Samples/contoso-web) at
commit
[`e13b0d346bdc0f2139552df6b9268cbe71b5b644`](https://github.com/Azure-Samples/contoso-web/commit/e13b0d346bdc0f2139552df6b9268cbe71b5b644)
as the source. The manuals are byte-for-byte copies of the files under
`public/manuals/` at that upstream revision. The WebP files are optimized
derivatives of the upstream product PNGs, produced by the pinned import script.

Both repositories publish MIT license evidence:

- [`nitya/gpt-demo-sample` license](https://github.com/nitya/gpt-demo-sample/blob/87a4fc388c75b96eaea79f33b531acc46871c6c3/LICENSE)
- [`Azure-Samples/contoso-web` license](https://github.com/Azure-Samples/contoso-web/blob/e13b0d346bdc0f2139552df6b9268cbe71b5b644/LICENSE.md)

The applicable notices are preserved in the repository root
[`THIRD_PARTY_NOTICES.md`](../../../../THIRD_PARTY_NOTICES.md).

The shopper audio fixture says, "Can you explain how to set up the TrailMaster
X4 tent?" It was generated on 2026-09-21 with Azure AI Speech voice
`en-US-AvaMultilingualNeural` and saved as mono PCM16 WAV at 24 kHz. It contains
no copied product audio or personal voice recording.
