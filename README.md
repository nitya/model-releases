<!-- prettier-ignore -->
<p align="center">
  <img src="./docs/images/logo.png" alt="Model Releases from Microsoft Foundry" width="320" />
</p>

<p align="center">
  <b><i>Find the right model by building with it.</i></b>
</p>

<p align="center">
  <a href="https://codespaces.new/microsoft-foundry/model-releases"><img src="https://img.shields.io/badge/Open-GitHub_Codespaces-24292F?style=flat-square&logo=github" alt="Open: GitHub Codespaces" /></a>
  <a href="https://ai.azure.com/catalog/models"><img src="https://img.shields.io/badge/Browse-Microsoft_Foundry_Catalog-00A4EF?style=flat-square" alt="Browse: Microsoft Foundry Catalog" /></a>
  <a href="https://aka.ms/model-mondays"><img src="https://img.shields.io/badge/Watch-Model_Mondays_Livestream-F25022?style=flat-square" alt="Watch: Model Mondays Livestream" /></a>
  <a href="https://aka.ms/model-mastery"><img src="https://img.shields.io/badge/Complete-Model_Mastery_Workshops-7FBA00?style=flat-square" alt="Complete: Model Mastery Workshops" /></a>
  <a href="./LICENSE"><img src="https://img.shields.io/badge/License-MIT-FFB900?style=flat-square" alt="License: MIT" /></a>
</p>

<p align="center">
  <a href="#what-are-model-releases">What</a> &nbsp;•&nbsp;
  <a href="#why-do-they-matter">Why</a> &nbsp;•&nbsp;
  <a href="#how-can-i-get-started">Get started</a> &nbsp;•&nbsp;
  <a href="#how-can-i-learn-more">Learn more</a> &nbsp;•&nbsp;
  <a href="#where-can-i-find-the-details">Details</a>
</p>

<br/>

## What are model releases?

A model release is the moment a new model, or a major update to one, lands in the
[Microsoft Foundry catalog](https://ai.azure.com/catalog). A release post tells us what
changed, but not how the model behaves on our own inputs or what to check when a result
surprises us.

This repository turns each release into a **capsule**: a folder with a README and
runnable notebooks. We build something, look closely at what the model did, change an
input, and practice fixing what breaks. Ready to try one? [Get started](#how-can-i-get-started),
[see what just shipped](#how-can-i-learn-more), or
[open an issue](https://github.com/microsoft-foundry/model-releases/issues/new) if we're missing a release.

<br/>

## Why do they matter?

Think of an AI agent as a vehicle built to get a job done: the model is the engine,
instructions are the manual, tools are accessories (like power windows), memory is saved
settings, and traces are the diagnostics.

```mermaid
flowchart LR
    job["A job to do"] --> agent
    subgraph agent["Agent (the vehicle)"]
        model["Model<br/>(engine)"]
        instructions["Instructions<br/>(manual)"]
        tools["Tools<br/>(accessories)"]
        memory["Memory<br/>(settings)"]
        traces["Traces<br/>(diagnostics)"]
    end
    agent --> done["A finished job"]
```

Every release adds another engine to choose from, so we can match the engine to the job.
A small electric car is plenty for a weekly grocery run, a tractor is built for fields,
and a snow-plowing business needs a heavy-duty pickup. More power isn't better if the job
doesn't need it. It just costs more.

_Models work the same way.__ Some generate images, some reason through hard problems, and
some listen and speak. Within each kind, we trade power for speed and cost. So the useful
question isn't "which model is best?" but "which one is right-sized for this job?"

_Traces help us answer it._ They record what the model was asked, what it returned, and what each step cost in time and money. That shows how it really behaves on our task. When an agent stumbles, traces become evidence we can analyze to debug problems or performance.

<br/>

<a id="notebook-collections"></a>
<a id="quickstart-explore-model-releases-hands-on"></a>
<a id="capsule-what-can-i-do-with-this-release"></a>
<a id="try-a-notebook-what-can-i-build"></a>

## How can I get started?

<!-- BEGIN:RECENT-CAPSULES -->
<p align="center">
  <a href="models/microsoft-ai/README.md"><img src="https://img.shields.io/badge/Microsoft%20AI-8-00A4EF?style=flat-square" alt="Microsoft AI: 8 notebooks" /></a>
  <a href="models/model-router/README.md"><img src="https://img.shields.io/badge/Model%20Router-3-7F3FBF?style=flat-square" alt="Model Router: 3 notebooks" /></a>
  <a href="models/anthropic/README.md"><img src="https://img.shields.io/badge/Anthropic-0-D97757?style=flat-square" alt="Anthropic: 0 notebooks" /></a>
  <a href="models/azure-openai/README.md"><img src="https://img.shields.io/badge/Azure%20OpenAI-0-0078D4?style=flat-square" alt="Azure OpenAI: 0 notebooks" /></a>
  <a href="models/black-forest-labs/README.md"><img src="https://img.shields.io/badge/Black%20Forest%20Labs-0-222222?style=flat-square" alt="Black Forest Labs: 0 notebooks" /></a>
  <a href="models/cohere/README.md"><img src="https://img.shields.io/badge/Cohere-0-39594D?style=flat-square" alt="Cohere: 0 notebooks" /></a>
  <a href="models/deepseek/README.md"><img src="https://img.shields.io/badge/DeepSeek-0-4D6BFE?style=flat-square" alt="DeepSeek: 0 notebooks" /></a>
  <a href="models/fireworks/README.md"><img src="https://img.shields.io/badge/Fireworks-0-E5484D?style=flat-square" alt="Fireworks: 0 notebooks" /></a>
  <a href="models/hugging-face/README.md"><img src="https://img.shields.io/badge/Hugging%20Face-0-FFD21E?style=flat-square" alt="Hugging Face: 0 notebooks" /></a>
  <a href="models/mistral/README.md"><img src="https://img.shields.io/badge/Mistral-0-FF7000?style=flat-square" alt="Mistral: 0 notebooks" /></a>
  <a href="models/nvidia/README.md"><img src="https://img.shields.io/badge/NVIDIA-0-76B900?style=flat-square" alt="NVIDIA: 0 notebooks" /></a>
  <a href="models/xai/README.md"><img src="https://img.shields.io/badge/xAI-0-555555?style=flat-square" alt="xAI: 0 notebooks" /></a>
</p>
<!-- END:RECENT-CAPSULES -->

- **Setup** → [Open the repository in GitHub Codespaces](https://codespaces.new/microsoft-foundry/model-releases), then run `./scripts/1-create-rg.sh` once.
  It signs you in, creates your Foundry project with monitoring and access, and writes your `.env`
  ([quickstart](./models/quickstart/README.md)).
- **Pick a family** → Click a badge to see notebooks - if `0` try [creating the first one](./docs/README.md#contributing-how-can-i-add-new-content).
- **Try a notebook** → Deploy the model it needs with `./scripts/3-deploy-model.sh`, open the notebook in VS Code, select the kernel, and run the cells.

Not sure where to start? [MAI-Image-2.5](./models/microsoft-ai/mai-image-2.5/mai-image-2.5.ipynb) gives a visual result fast. Then change an input, test a hunch, and fix whatever breaks, because that's where most of the learning happens.

Want release summaries and update dates? Try the [CAPSULES](./docs/CAPSULES.md).

<br/>

<a id="announcements-whats-new-in-foundry-models"></a>

## How can I learn more?

Want to see what just shipped? Every release announcement is logged in
[ANNOUNCEMENTS](./docs/ANNOUNCEMENTS.md) with a link to the original post, the publisher, and the
capabilities. Here are the three most recent:

<!-- BEGIN:RECENTLY-ADDED -->
- **Microsoft-Decision-1** · [2026-10-09](https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/introducing-microsoft-decision-1-in-microsoft-foundry-for-decision-and-classific/4562742) · Decision Models
- **Claude Haiku 5.5** · [2026-10-07](https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/claude-haiku-5-5-is-now-available-in-microsoft-foundry/4562408) · Chat Completion · Multimodal · Function Calling
- **Grok 4.7** · [2026-10-06](https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/introducing-grok-4-7-on-microsoft-foundry/4562168) · Reasoning · Chat Completion · Function Calling
<!-- END:RECENTLY-ADDED -->

<br/>

<a id="reference-where-do-i-learn-more"></a>

## Where can I find the details?

- [Reference guide](./docs/README.md): how repo is organized, plus a glossary of terms
- [Contribute content](./docs/README.md#contributing-how-can-i-add-new-content): add a capsule, publisher, capability, or glossary term
- [Use it from an agent](./docs/README.md#using-this-repo-from-an-agent): fetch repo data through `catalog.json` or `llms.txt`
