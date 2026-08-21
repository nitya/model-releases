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

## B

_No entries yet._

## C

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

**Reference:** [Work with chat completion models — Microsoft Foundry](https://learn.microsoft.com/en-us/azure/foundry/openai/how-to/chatgpt)

## D

_No entries yet._

## E

_No entries yet._

## F

_No entries yet._

## G

_No entries yet._

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
- [Model router for Microsoft Foundry](https://learn.microsoft.com/en-us/azure/foundry/openai/concepts/model-router)

## I

_No entries yet._

## J

_No entries yet._

## K

_No entries yet._

## L

_No entries yet._

## M

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
- [Optimize model cost and performance in Microsoft Foundry](https://learn.microsoft.com/en-us/azure/foundry/control-plane/how-to-optimize-cost-performance)
- [A Developer's Guide to Managing Models, Cost and Quality in Microsoft Foundry](https://devblogs.microsoft.com/foundry/build-2026-foundry-models/)

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
- [Model router for Microsoft Foundry](https://learn.microsoft.com/en-us/azure/foundry/openai/concepts/model-router)

## S

_No entries yet._

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
- [Optimize model cost and performance in Microsoft Foundry](https://learn.microsoft.com/en-us/azure/foundry/control-plane/how-to-optimize-cost-performance)

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
