# Microsoft Foundry Model Glossary

Plain-language explainers for the terminology you'll meet across this repo's
capsules, notebooks, and primers. This model-releases repo is about two things:
building practical **model knowledge** and a **model optimization playbook** for
building efficient AI agents — and this glossary is the shared vocabulary that
ties them together.

Every term is a level-3 heading, so it has a stable kebab-case anchor you can
link to from anywhere:

```markdown
See [context window](../docs/GLOSSARY.md#context-window).
```

Entries lead with the developer question they answer, keep the explanation to a
few sentences, cross-link related terms, and end with a reference you can follow
to go deeper.

**Jump to:**
[A](#a) · [B](#b) · [C](#c) · [D](#d) · [E](#e) · [F](#f) · [G](#g) ·
[H](#h) · [I](#i) · [J](#j) · [K](#k) · [L](#l) · [M](#m) · [N](#n) ·
[O](#o) · [P](#p) · [Q](#q) · [R](#r) · [S](#s) · [T](#t) · [U](#u) ·
[V](#v) · [W](#w) · [X](#x) · [Y](#y) · [Z](#z)

---

## A

### Abstention Option

*"What should a model answer when it doesn't have enough to go on?"*

An abstention option is an answer we add to a closed question, such as "cannot tell" or
"unclear," so a [decision model](#decision-model) can decline to choose. Without one, the model
has to spread its probability over the options we gave it, and a vague input still gets a
confident-looking answer. When our code treats the abstention as "send this to a person," missing
evidence becomes a signal we can act on. Notebooks 01 and 03 of the
[Microsoft-Decision-1 capsule](../models/microsoft/microsoft-decision-1/README.md) show both cases.

**Reference:** [Deploy and use Microsoft-Decision-1 in Microsoft Foundry](https://learn.microsoft.com/azure/foundry/foundry-models/how-to/use-foundry-models-microsoft-decision)

### Active Parameters

*"This model has 235 billion parameters — so why is it fast?"*

Active parameters are the parameters a model actually uses to process one token.
In a [dense model](#dense-model) that is all of them. In a
[Mixture of Experts](#mixture-of-experts-moe) model it is only the experts the
router picks, so Qwen3 235B-A22B uses about 22B per token. Total parameters hint
at capacity and the memory needed to host the model; active parameters hint at
per-token speed and cost. See the
[Model Architecture primer](primers/model-architecture.md) for fact-sheet numbers.

**Reference:** [LLM Architecture Gallery](https://sebastianraschka.com/llm-architecture-gallery/)

### Agent Optimization

*"My agent works in the demo — how do I make it worth running in production?"*

Agent Optimization is about treating an AI agent as something we continuously
tune rather than ship once. We match each request to the
[right-sized](#right-sizing) model and settings, improve the agent's workflow as
real usage reveals what works, and keep spend bounded and attributable. It runs
as a loop across three horizons: optimize each request at runtime (for example
with a model router, caching, and deployment or pricing modes), improve the agent
workflow over days and weeks by [hill climbing](#hill-climbing) toward better
results, and govern spend continuously with budgets and limits — the model-layer
moves are [Model Optimization](#model-optimization). Because tokens are the unit
of spend ([Tokenomics](#tokenomics)), our practical starting point is a
scorecard — cost, latency, and quality — that tells us whether each change is
actually an improvement.

**Reference:** [The Economics of Agent Optimization: From pilots to measurable returns](https://azure.microsoft.com/en-us/blog/the-economics-of-agent-optimization-from-pilots-to-measurable-returns/)

### Attention

*"How does the model decide which earlier words matter?"*

Attention is the step in a [transformer](#transformer) block where each token
looks at the other tokens in the context and weighs how much each one matters.
Because tokens can look back at everything before them, attention is where context
length turns into memory use (the [KV cache](#kv-cache)) and compute. Variants such
as [grouped-query](#grouped-query-attention-gqa),
[multi-head latent](#multi-head-latent-attention-mla),
[sliding-window](#sliding-window-attention), and [hybrid](#hybrid-attention)
attention change that cost. See the
[Model Architecture primer](primers/model-architecture.md).

**Reference:** [Attention Is All You Need](https://arxiv.org/abs/1706.03762)

## B

_No entries yet._

## C

### Calibration

*"If the model says 0.9, is it right nine times out of ten?"*

Calibration is how well a model's stated probabilities match how often it is right. A calibrated
0.9 is correct about 90 percent of the time, which is what lets us automate confident answers and
escalate the rest with a threshold. We check calibration on our own labeled data, because a model
can be well calibrated on familiar tasks and overconfident on others. A worked check is in
[notebook 02](../models/microsoft/microsoft-decision-1/02-set-confidence-thresholds.ipynb) of the Microsoft-Decision-1 capsule.

**Reference:** [Deploy and use Microsoft-Decision-1 in Microsoft Foundry](https://learn.microsoft.com/azure/foundry/foundry-models/how-to/use-foundry-models-microsoft-decision)

### Context Window

*"How much can the model actually take in on a single call?"*

A context window is the maximum number of tokens a model can consider at once —
our prompt, the conversation history, retrieved documents, and the model's own
reply all count against it. When we exceed it, older content is dropped or must
be summarized, which can quietly change the answer we get back. "Long context"
models push this into the hundreds of thousands of tokens; most chat models sit
in the tens of thousands. Because everything in the window is billed as input,
the context window is where [Tokenomics](#tokenomics) meets a hard limit — a
practical reason to trim context and [right-size](#right-sizing) each request.

**Reference:** [Work with chat completion models — Microsoft Foundry](https://learn.microsoft.com/azure/foundry/openai/how-to/chatgpt)

## D

### Decision Model

*"Which model do we use for a step that picks, scores, or checks instead of writing?"*

A decision model answers closed questions about some state with a choice, a score, or a
probability, and doesn't generate free-form text. Our code can branch on the typed answer, so it
fits the routing, gating, ranking, and grading steps that run often and need a predictable
response. Microsoft-Decision-1 is one example. See the
[Decision Models primer](primers/decision-models.md) for how the decision API works, and
[Abstention Option](#abstention-option) and [Calibration](#calibration) for two habits that make
the answers safer to act on.

**Reference:** [Deploy and use Microsoft-Decision-1 in Microsoft Foundry](https://learn.microsoft.com/azure/foundry/foundry-models/how-to/use-foundry-models-microsoft-decision)

### Dense Model

*"Does every parameter work on every token?"*

A dense model sends every token through all of its parameters, so its total and
active parameters are the same. That makes it simple and predictable, and it is
the design a [Mixture of Experts](#mixture-of-experts-moe) model departs from.
Llama 3 8B is a dense example. See the
[Model Architecture primer](primers/model-architecture.md) for how dense and MoE
models compare.

**Reference:** [LLM Architecture Gallery](https://sebastianraschka.com/llm-architecture-gallery/)

## E

_No entries yet._

## F

_No entries yet._

## G

### Grouped-Query Attention (GQA)

*"How do models keep long conversations from using so much memory?"*

Grouped-query attention lets several attention heads share one set of keys and
values instead of each head keeping its own. That shrinks the
[KV cache](#kv-cache) and speeds up decoding while staying close to full
multi-head quality. In the gallery, Llama 3 8B uses it at 128 KiB per token,
where GPT-2 XL's full multi-head attention needs 300 KiB. See the
[Model Architecture primer](primers/model-architecture.md).

**Reference:** [GQA: Training Generalized Multi-Query Transformer Models from Multi-Head Checkpoints](https://arxiv.org/abs/2305.13245)

## H

### Hill Climbing

*"Do I improve this with one big rewrite, or lots of small steps?"*

Hill Climbing is an iterative optimization strategy that starts from a working
solution and repeatedly makes small changes, keeping each change only when it
improves a measured objective and discarding it otherwise. Progress comes from
many incremental, evidence-backed steps toward a target metric rather than one
large redesign. Microsoft AI frames model building this way — a "hill-climbing
machine" that compounds small, measurable gains across releases. The same idea
applies to applications: we compare models and adjust routing to find a better
balance of quality, cost, and latency, and a model router shortens that search by
[right-sizing](#right-sizing) each request. The same discipline underlies
[Model Optimization](#model-optimization), which tunes model choice and settings
step by step against target metrics, and the broader
[Agent Optimization](#agent-optimization) loop, where each request or workflow
change is kept only when the scorecard (cost, latency, quality) improves.

**Reference:**
- [Building a hill-climbing machine: launching seven new MAI models](https://microsoft.ai/news/building-a-hillclimbing-machine-launching-seven-new-mai-models/)
- [Model router for Microsoft Foundry](https://learn.microsoft.com/azure/foundry/openai/concepts/model-router)

### Hybrid Attention

*"Can a model handle a million tokens without a million-token cache?"*

Hybrid attention mixes a few full-attention layers with many linear or recurrent
layers that fold the past into a fixed-size state. Because that state doesn't grow
with context, the [KV cache](#kv-cache) stays small. Qwen3 Next 80B-A3B pairs 12
gated-attention layers with 36 DeltaNet layers and shows 24 KiB per token in the
gallery. It is a newer design, so we check quality on our own tasks. See the
[Model Architecture primer](primers/model-architecture.md).

**Reference:**
- [LLM Architecture Gallery](https://sebastianraschka.com/llm-architecture-gallery/)
- [Gated Delta Networks: Improving Mamba2 with Delta Rule](https://arxiv.org/abs/2412.06464)

## I

_No entries yet._

## J

_No entries yet._

## K

### KV Cache

*"Why does memory climb as the conversation gets longer?"*

The KV cache holds the keys and values of every token a model has already
processed, so it doesn't recompute them for each new token. It grows with the
context in use, and at long context it often matters more to memory than the
model's parameter count. Attention designs such as
[grouped-query](#grouped-query-attention-gqa) and
[multi-head latent](#multi-head-latent-attention-mla) attention exist largely to
shrink it. See the [Model Architecture primer](primers/model-architecture.md) for
per-token figures.

**Reference:** [LLM Architecture Gallery](https://sebastianraschka.com/llm-architecture-gallery/)

## L

_No entries yet._

## M

### Mixture of Experts (MoE)

*"How can a model have hundreds of billions of parameters and still be quick?"*

A Mixture of Experts model splits each feed-forward layer into many smaller
blocks called experts, and a small router picks a few of them for each token. Only
those experts run, so the model's [active parameters](#active-parameters) are a
small share of its total. Mixtral 8x7B has access to 47B parameters but uses 13B
per token. The experts all still need to be available in memory. See the
[Model Architecture primer](primers/model-architecture.md), which contrasts MoE
with a [dense model](#dense-model).

**Reference:** [Mixtral of Experts](https://arxiv.org/abs/2401.04088)

### Model Optimization

*"My model costs just spiked — what do I actually change?"*

Model Optimization is a continuous improvement loop that iteratively moves an
application toward its cost, quality, and latency goals by pulling on a set of
levers — model selection ([right-sizing](#right-sizing)), prompt optimization,
context engineering, evaluation, fine-tuning, quantization, and distillation —
rather than a one-time configuration step. In practice we run it as an
operational workflow: spot a cost or latency regression, diagnose the driver
(token usage, completion length, or frequent evaluation runs), switch to or tune
a more cost-efficient model, then confirm the change against an evaluation
dataset that reflects our real workload. Each pass is a
[hill-climbing](#hill-climbing) step — we keep the change only if the metrics
improve. Model optimization works at the model layer and is one lever within the
broader [Agent Optimization](#agent-optimization) loop, which also improves the
surrounding agent workflow and governs spend continuously.

**Reference:**
- [Optimize model cost and performance in Microsoft Foundry](https://learn.microsoft.com/azure/foundry/control-plane/how-to-optimize-cost-performance)
- [A Developer's Guide to Managing Models, Cost and Quality in Microsoft Foundry](https://devblogs.microsoft.com/foundry/build-2026-foundry-models/)

### Multi-Head Latent Attention (MLA)

*"Can the KV cache be compressed instead of shared?"*

Multi-head latent attention compresses keys and values into a smaller latent
vector, which cuts the [KV cache](#kv-cache) without having heads share keys the
way [grouped-query attention](#grouped-query-attention-gqa) does. DeepSeek V3 uses
it and shows 68.6 KiB per token in the gallery. See the
[Model Architecture primer](primers/model-architecture.md).

**Reference:** [DeepSeek-V2: A Strong, Economical, and Efficient Mixture-of-Experts Language Model](https://arxiv.org/abs/2405.04434)

## N

_No entries yet._

## O

### Optimization Lever

*"What can I actually turn to move cost, quality, or latency?"*

An optimization lever is one of the concrete controls we can pull to move an
application's cost, quality, or latency — model selection and
[right-sizing](#right-sizing), prompt optimization, context engineering, caching,
deployment and pricing modes, fine-tuning, quantization, and distillation. No
single lever wins on its own, so the model optimization playbook is the ordered
set of levers we try, measuring after each one. Levers are what
[Model Optimization](#model-optimization) and [Agent Optimization](#agent-optimization)
pull on — we [hill climb](#hill-climbing) by keeping a lever's change only when
the scorecard improves, and [Tokenomics](#tokenomics) usually tells us which
lever to reach for first.

**Reference:** [Build smarter AI systems in Foundry as models and costs evolve (BRK230)](https://build.microsoft.com/en-US/sessions/BRK230)

## P

_No entries yet._

## Q

_No entries yet._

## R

### Right-Sizing

*"Do I really need the biggest model for every request?"*

Right-Sizing is about matching each request to the smallest, cheapest model and
settings that still meet its quality bar, so simple work never pays
frontier-model prices. Most workloads are a mix: a quick classification and a
multi-step reasoning task have very different needs, yet sending both to one
large model overpays for the easy ones. Right-sizing is the runtime lever of
optimization — a model router applies it automatically by sending each prompt to
a cost, quality, or balanced choice, while we can also right-size by hand through
model selection, deployment and pricing modes, and shorter prompts. It is where
[Tokenomics](#tokenomics) turns into action inside the
[Model Optimization](#model-optimization) and
[Agent Optimization](#agent-optimization) loops.

**Reference:**
- [The Economics of Agent Optimization: From pilots to measurable returns](https://azure.microsoft.com/en-us/blog/the-economics-of-agent-optimization-from-pilots-to-measurable-returns/)
- [Model router for Microsoft Foundry](https://learn.microsoft.com/azure/foundry/openai/concepts/model-router)

## S

### Sliding-Window Attention

*"Does every layer need to look at the whole conversation?"*

In sliding-window attention, each token looks only at a window of nearby tokens
instead of everything before it, which caps the [KV cache](#kv-cache) for that
layer. Models usually mix these layers with a few global-attention layers so
distant context still reaches the output. Gemma 3 27B uses a 5:1 ratio of
sliding-window to global layers. See the
[Model Architecture primer](primers/model-architecture.md).

**Reference:** [Longformer: The Long-Document Transformer](https://arxiv.org/abs/2004.05150)

## T

### Tokenomics

*"Why does my bill keep growing even when users ask simple questions?"*

Tokenomics is about the economics of tokens — the unit a language model reads
input and writes output in, and therefore the unit we pay in. Every request is
priced by its tokens:
input tokens (the system prompt, conversation history, tool definitions, and
retrieved context) plus the output tokens the model generates. Because models are
stateless, the full context is resent on every call — bounded by the model's
[Context Window](#context-window) — so cost can climb even when the user only
asks a short follow-up, and an agent that makes several model calls per request
multiplies the effect. Understanding tokenomics is the groundwork for
optimization: it shows where spend comes from so [Model Optimization](#model-optimization)
and [Agent Optimization](#agent-optimization) can act on it —
[right-sizing](#right-sizing) models, trimming context, caching repeated content,
and limiting unnecessary tool calls.

**Reference:**
- [Microsoft Mechanics: token economics episode](https://www.youtube.com/watch?v=mB0IyELzjRg)
- [Optimize model cost and performance in Microsoft Foundry](https://learn.microsoft.com/azure/foundry/control-plane/how-to-optimize-cost-performance)

### Transformer

*"What is almost every modern language model made of?"*

A transformer is a neural network built from a stack of identical blocks, each
combining [attention](#attention) with a feed-forward layer. Text becomes tokens,
tokens become vectors, and each block mixes information across the sequence
before the model predicts the next token. [Dense](#dense-model) and
[Mixture of Experts](#mixture-of-experts-moe) models differ in the feed-forward
layer. See the [Model Architecture primer](primers/model-architecture.md).

**Reference:** [Attention Is All You Need](https://arxiv.org/abs/1706.03762)

## U

_No entries yet._

## V

_No entries yet._

## W

_No entries yet._

## X

_No entries yet._

## Y

_No entries yet._

## Z

_No entries yet._

<!--
Adding a term:
1. Find its letter section above.
2. Insert alphabetically, using a level-3 heading (### Term Name).
3. Write 2–4 sentences.
4. End with **Reference:** <link> — ideally to learn.microsoft.com.
5. Replace the section's "_No entries yet._" placeholder if it was empty.
-->
